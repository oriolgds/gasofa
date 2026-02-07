/// Main state management provider for gas stations
/// Now uses Isar database for caching and incremental updates
/// Optimized with Isolate-based sorting and pre-calculated price thresholds

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import '../models/fuel_type.dart';
import '../models/gas_station.dart';
import '../models/station_entity.dart';
import '../services/api_service.dart';
import '../services/location_service.dart';
import '../services/distance_service.dart';
import '../services/database_service.dart';
import '../services/province_lookup_service.dart';

enum SortMode { price, distance, combined }

enum LoadingState { idle, loading, syncing, loaded, error }

class GasStationsProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final LocationService _locationService = LocationService();
  final DistanceService _distanceService = DistanceService();
  final DatabaseService _databaseService = DatabaseService();

  final ProvinceLookupService _provinceLookupService = ProvinceLookupService();

  static const String _prefsKeyFuelType = 'selected_fuel_type';

  // State
  List<GasStation> _stations = [];
  LoadingState _loadingState = LoadingState.idle;
  String? _errorMessage;
  String? _syncStatus;
  FuelType _selectedFuelType = FuelType.gasolina95;
  String? _selectedProvinceCode;
  SortMode _sortMode = SortMode.combined;
  Position? _userPosition;
  bool _useLocation = false;
  String _searchQuery = '';
  Set<String> _loadedProvinceCodes = {}; // Track which provinces we've loaded

  // Caching and Optimization
  Map<FuelType, List<GasStation>> _sortedStationsCache =
      {}; // Cache for Price sort
  String? _processingStatus;
  Timer? _searchDebounce;

  // Pre-calculated thresholds for the current filtered/sorted list
  // ensuring O(1) checks in list rendering instead of O(N)
  double? _lowPriceThreshold;
  double? _highPriceThreshold;

  // Getters
  List<GasStation> get stations => _stations;
  LoadingState get loadingState => _loadingState;
  String? get errorMessage => _errorMessage;
  String? get syncStatus => _syncStatus;
  FuelType get selectedFuelType => _selectedFuelType;
  String? get selectedProvinceCode => _selectedProvinceCode;
  SortMode get sortMode => _sortMode;
  Position? get userPosition => _userPosition;
  bool get useLocation => _useLocation;
  bool get hasLocation => _userPosition != null;
  String get searchQuery => _searchQuery;
  String? get processingStatus => _processingStatus;

  // Public thresholds
  double? get lowPriceThreshold => _lowPriceThreshold;
  double? get highPriceThreshold => _highPriceThreshold;

  GasStationsProvider() {
    // Initial fetch from DB
    _loadFromDatabase();
  }

  /// Get filtered stations (only those with selected fuel type price and matching search)
  /// Uses pre-calculated cache when sorting by price for instant switching
  List<GasStation> get filteredStations {
    // 1. Select source list
    List<GasStation> sourceList;

    // If sorting by Price, use the cache if available
    if (_sortMode == SortMode.price &&
        _sortedStationsCache.containsKey(_selectedFuelType)) {
      sourceList = _sortedStationsCache[_selectedFuelType]!;
    } else {
      // Otherwise use the main list (which is sorted by current mode)
      sourceList = _stations;
    }

    // 2. Filter by search query and price availability
    // Optimization: If no search query, return list directly (assuming all have price? No, still need to check)
    // Actually, we should filter out zero-prices or nulls for the selected fuel type

    return sourceList.where((s) {
      if (!s.hasPrice(_selectedFuelType)) return false;

      if (_searchQuery.isEmpty) return true;
      return s.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  /// Set search query with debounce
  void setSearchQuery(String query) {
    if (_searchQuery == query) return;

    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      _searchQuery = query;
      notifyListeners();
    });
  }

  /// Set fuel type filter
  Future<void> setFuelType(FuelType fuelType) async {
    if (_selectedFuelType == fuelType) return;

    _selectedFuelType = fuelType;

    // Save to preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKeyFuelType, fuelType.name);

    // Recalculate thresholds for the new fuel type immediately
    _calculatePriceThresholds();

    notifyListeners();

    // If not sorting by price, we might need to re-sort
    if (_sortMode != SortMode.price) {
      await _sortStationsAsync();
    }
  }

  /// Set province filter
  void setProvince(String? provinceCode) {
    _selectedProvinceCode = provinceCode;
    notifyListeners();
  }

  /// Set sort mode
  Future<void> setSortMode(SortMode mode) async {
    if (_sortMode == mode) return;

    _sortMode = mode;
    notifyListeners(); // Notify to update UI selection state

    // Sort asynchronously
    await _sortStationsAsync();
  }

  /// Toggle use of user location
  void setUseLocation(bool value) {
    _useLocation = value;
    notifyListeners();
  }

  /// Get user's current location
  Future<bool> fetchUserLocation() async {
    _userPosition = await _locationService.getCurrentPosition();
    if (_userPosition != null) {
      _useLocation = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Load stations from local DB
  Future<void> _loadFromDatabase() async {
    _loadingState = LoadingState.loading;

    notifyListeners();

    try {
      // Load preferences first
      final prefs = await SharedPreferences.getInstance();
      final savedFuelType = prefs.getString(_prefsKeyFuelType);
      if (savedFuelType != null) {
        // Find matching enum value
        try {
          _selectedFuelType = FuelType.values.firstWhere(
            (e) => e.name == savedFuelType,
            orElse: () => FuelType.gasolina95,
          );
        } catch (_) {}
      }

      final entities = await _databaseService.getAllStations();
      _stations = entities.map((e) => e.toGasStation()).toList();

      if (_stations.isNotEmpty) {
        if (_userPosition != null) {
          _distanceService.calculateDistances(
            _stations,
            _userPosition!.latitude,
            _userPosition!.longitude,
          );
        }

        // Initial sort and calculations
        await _precalculateSortedLists(); // Pre-calc price lists
        await _sortStationsAsync(); // Sort main list
        _calculatePriceThresholds(); // Calc thresholds

        _loadingState = LoadingState.loaded;
      } else {
        _loadingState = LoadingState.idle;
      }
    } catch (e) {
      _errorMessage = 'Error loading local data: $e';
      _loadingState = LoadingState.error;
    }
    notifyListeners();
  }

  /// Fetch stations - only load current province and nearby provinces for performance
  Future<void> fetchStations() async {
    if (_stations.isEmpty) {
      _loadingState = LoadingState.loading;
    } else {
      _loadingState = LoadingState.syncing;
    }
    _errorMessage = null;
    notifyListeners();

    try {
      if (_useLocation && _userPosition == null) {
        await fetchUserLocation();
      }

      if (_userPosition == null) {
        _errorMessage = 'Ubicación necesaria para cargar gasolineras cercanas';
        _loadingState = LoadingState.error;
        notifyListeners();
        return;
      }

      _syncStatus = 'Obteniendo provincias cercanas...';
      notifyListeners();

      final allProvinces = await _apiService.fetchProvinces();

      final currentProvinceCode = _provinceLookupService
          .getProvinceCodeFromCoordinates(
            _userPosition!.latitude,
            _userPosition!.longitude,
          );

      if (currentProvinceCode == null) {
        _errorMessage = 'No se pudo determinar la provincia actual';
        _loadingState = LoadingState.error;
        _syncStatus = null;
        notifyListeners();
        return;
      }

      List<String> provincesToLoad = [currentProvinceCode];
      final nearbyProvinceCodes = _provinceLookupService.getNearbyProvinceCodes(
        currentProvinceCode,
      );
      provincesToLoad.addAll(nearbyProvinceCodes);

      int total = provincesToLoad.length;
      int current = 0;

      for (final provinceCode in provincesToLoad) {
        current++;

        final provinceName = allProvinces
            .firstWhere(
              (p) => p.id == provinceCode,
              orElse: () => Province(id: provinceCode, name: provinceCode),
            )
            .name;

        if (current == 1) {
          _syncStatus = 'Cargando provincia actual: $provinceName...';
        } else {
          _syncStatus =
              'Cargando provincias cercanas: $provinceName ($current/$total)...';
        }
        notifyListeners();

        try {
          final stations = await _apiService.fetchStationsByProvince(
            provinceCode,
          );
          final entities = stations
              .map((s) => StationEntity.fromGasStation(s))
              .toList();
          await _databaseService.saveStations(entities);

          _loadedProvinceCodes.add(provinceCode);

          final allEntities = await _databaseService.getAllStations();
          _stations = allEntities.map((e) => e.toGasStation()).toList();

          if (_userPosition != null) {
            _distanceService.calculateDistances(
              _stations,
              _userPosition!.latitude,
              _userPosition!.longitude,
            );
          }

          // Re-sort and re-calculate occasionally or at end?
          // Doing it here gives immediate feedback but might be jerky if not backgrounded.
          // Since we use background isolate now, it should be fine.

          await _sortStationsAsync();
          _calculatePriceThresholds();

          notifyListeners();
        } catch (e) {
          print('Error loading province $provinceName: $e');
        }
      }

      _syncStatus = null;
      _loadingState = LoadingState.loaded;
      notifyListeners();

      // Final full pre-calculation
      await _precalculateSortedLists();
    } catch (e) {
      print('Fetch error: $e');
      _errorMessage = e.toString();
      _loadingState = LoadingState.error;
      _syncStatus = null;
    }

    notifyListeners();
  }

  /// Pre-calculate sorted lists for all fuel types in background Isolate
  Future<void> _precalculateSortedLists() async {
    _processingStatus = 'Optimizando listas...';
    notifyListeners();

    try {
      // We process all fuel types in one go or separate tasks?
      // One go is better to avoid overhead.
      // But we can just use the generic sort for each.

      for (final fuelType in FuelType.values) {
        final sorted = await compute(_sortStationsWorker, {
          'stations': _stations,
          'mode': SortMode.price, // Always cache Price sort
          'fuelType': fuelType,
        });
        _sortedStationsCache[fuelType] = sorted;
      }
    } catch (e) {
      print('Error accessing isolate: $e');
    }

    _processingStatus = null;
    notifyListeners();
  }

  /// Sort stations asynchronously using Isolate
  Future<void> _sortStationsAsync() async {
    _processingStatus = 'Ordenando...';
    notifyListeners();

    try {
      // Use compute to run in background isolate
      final sorted = await compute(_sortStationsWorker, {
        'stations': _stations,
        'mode': _sortMode,
        'fuelType': _selectedFuelType,
      });

      _stations = sorted;

      // Update thresholds based on new list/fuel type
      _calculatePriceThresholds();
    } catch (e) {
      print('Sort error: $e');
    }

    _processingStatus = null;
    notifyListeners();
  }

  /// Static worker function for Isolate
  static List<GasStation> _sortStationsWorker(Map<String, dynamic> args) {
    final List<GasStation> stations = List<GasStation>.from(args['stations']);
    final SortMode mode = args['mode'];
    final FuelType fuelType = args['fuelType'];

    switch (mode) {
      case SortMode.price:
        stations.sort((a, b) {
          final priceA = a.getPrice(fuelType) ?? double.infinity;
          final priceB = b.getPrice(fuelType) ?? double.infinity;
          return priceA.compareTo(priceB);
        });
        break;

      case SortMode.distance:
        // Assume distanceKm is already calculated on the objects
        stations.sort((a, b) {
          final distA = a.distanceKm ?? double.infinity;
          final distB = b.distanceKm ?? double.infinity;
          return distA.compareTo(distB);
        });
        break;

      case SortMode.combined:
        // Combined logic inside isolate
        if (stations.isEmpty) return stations;

        final prices = stations
            .map((s) => s.getPrice(fuelType))
            .whereType<double>()
            .toList();
        final distances = stations
            .map((s) => s.distanceKm)
            .whereType<double>()
            .toList();

        if (prices.isEmpty || distances.isEmpty) {
          // Fallback to price sort
          stations.sort((a, b) {
            final priceA = a.getPrice(fuelType) ?? double.infinity;
            final priceB = b.getPrice(fuelType) ?? double.infinity;
            return priceA.compareTo(priceB);
          });
          return stations;
        }

        final maxPrice = prices.reduce((a, b) => a > b ? a : b);
        final minPrice = prices.reduce((a, b) => a < b ? a : b);
        // We use a fixed reference distance (e.g. 50km) to ensure local differences
        // are significant and not compressed by far-away outliers.
        const referenceMaxDistance = 50.0;
        final maxDistFallback = distances.reduce((a, b) => a > b ? a : b);

        // Prioritize distance more heavily
        const priceWeight = 0.35;
        const distanceWeight = 0.65;

        stations.sort((a, b) {
          final priceA = a.getPrice(fuelType) ?? maxPrice;
          final priceB = b.getPrice(fuelType) ?? maxPrice;
          final distA = a.distanceKm ?? maxDistFallback;
          final distB = b.distanceKm ?? maxDistFallback;

          final normPriceA =
              (priceA - minPrice) / (maxPrice - minPrice + 0.001);
          final normPriceB =
              (priceB - minPrice) / (maxPrice - minPrice + 0.001);

          // Normalize distance relative to reference (can be > 1.0)
          final normDistA = distA / referenceMaxDistance;
          final normDistB = distB / referenceMaxDistance;

          final scoreA =
              (normPriceA * priceWeight) + (normDistA * distanceWeight);
          final scoreB =
              (normPriceB * priceWeight) + (normDistB * distanceWeight);

          return scoreA.compareTo(scoreB);
        });
        break;
    }

    return stations;
  }

  /// Calculate price thresholds for the current station list and fuel type
  /// This is O(N) but only runs once when data/filter changes, not per item
  void _calculatePriceThresholds() {
    if (_stations.isEmpty) {
      _lowPriceThreshold = null;
      _highPriceThreshold = null;
      return;
    }

    final prices = _stations
        .map((s) => s.getPrice(_selectedFuelType))
        .whereType<double>()
        .toList();

    if (prices.isEmpty) {
      _lowPriceThreshold = null;
      _highPriceThreshold = null;
      return;
    }

    prices.sort();
    _lowPriceThreshold = prices[(prices.length * 0.33).floor()];
    _highPriceThreshold = prices[(prices.length * 0.66).floor()];
  }

  /// Get price category using pre-calculated thresholds (O(1))
  PriceCategory getCategoryForPrice(double? price) {
    if (price == null) return PriceCategory.unknown;
    if (_lowPriceThreshold == null || _highPriceThreshold == null)
      return PriceCategory.medium;

    if (price <= _lowPriceThreshold!) return PriceCategory.low;
    if (price >= _highPriceThreshold!) return PriceCategory.high;
    return PriceCategory.medium;
  }
}

enum PriceCategory { low, medium, high, unknown }
