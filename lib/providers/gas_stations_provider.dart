/// Main state management provider for gas stations
/// Now uses Isar database for caching and incremental updates

import 'package:flutter/foundation.dart';
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

  // State
  List<GasStation> _stations = [];
  LoadingState _loadingState = LoadingState.idle;
  String? _errorMessage;
  String? _syncStatus;
  FuelType _selectedFuelType = FuelType.gasolina95;
  String? _selectedProvinceCode;
  SortMode _sortMode = SortMode.price;
  Position? _userPosition;
  bool _useLocation = false;
  String _searchQuery = '';
  Set<String> _loadedProvinceCodes = {}; // Track which provinces we've loaded

  // Pre-calculated sorted lists per fuel type
  Map<FuelType, List<GasStation>> _sortedStationsCache = {};
  String? _processingStatus;

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

  GasStationsProvider() {
    // Initial fetch from DB
    _loadFromDatabase();
  }

  /// Get filtered stations (only those with selected fuel type price and matching search)
  /// Uses pre-calculated cache when sorting by price for instant switching
  List<GasStation> get filteredStations {
    // Only use cache when sorting by price
    // For distance/combined sorting, use the sorted _stations list
    final sourceList =
        (_sortMode == SortMode.price &&
            _sortedStationsCache.containsKey(_selectedFuelType))
        ? _sortedStationsCache[_selectedFuelType]!
        : _stations;

    return sourceList.where((s) {
      if (!s.hasPrice(_selectedFuelType)) return false;
      if (_searchQuery.isEmpty) return true;
      return s.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  /// Set search query for filtering by name
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Set fuel type filter
  Future<void> setFuelType(FuelType fuelType) async {
    _selectedFuelType = fuelType;
    // Notify immediately so UI responds
    notifyListeners();
    // Sort asynchronously to avoid blocking UI
    await _sortStationsAsync();
    notifyListeners();
  }

  /// Set province filter
  void setProvince(String? provinceCode) {
    _selectedProvinceCode = provinceCode;
    notifyListeners();
  }

  /// Set sort mode
  Future<void> setSortMode(SortMode mode) async {
    _sortMode = mode;
    // Notify immediately so UI responds
    notifyListeners();
    // Sort asynchronously to avoid blocking UI
    await _sortStationsAsync();
    notifyListeners();
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
        _sortStations();
        _loadingState = LoadingState.loaded;
      } else {
        // If empty, user needs to enable location and load data
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
    // If we already have data, we just sync in background
    // If we have no data, we show loading
    if (_stations.isEmpty) {
      _loadingState = LoadingState.loading;
    } else {
      _loadingState = LoadingState.syncing;
    }
    _errorMessage = null;
    notifyListeners();

    try {
      // Get user location if enabled
      if (_useLocation && _userPosition == null) {
        await fetchUserLocation();
      }

      // We need user location to determine which provinces to load
      if (_userPosition == null) {
        _errorMessage = 'Ubicación necesaria para cargar gasolineras cercanas';
        _loadingState = LoadingState.error;
        notifyListeners();
        return;
      }

      // Step 1: Fetch all provinces list
      _syncStatus = 'Obteniendo provincias cercanas...';
      notifyListeners();

      final allProvinces = await _apiService.fetchProvinces();

      // Step 2: Determine which provinces to load (only current + nearby)
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

      // Build list of provinces to load: current + nearby only
      List<String> provincesToLoad = [currentProvinceCode];
      final nearbyProvinceCodes = _provinceLookupService.getNearbyProvinceCodes(
        currentProvinceCode,
      );
      provincesToLoad.addAll(nearbyProvinceCodes);

      // Step 3: Load only these provinces
      int total = provincesToLoad.length;
      int current = 0;

      for (final provinceCode in provincesToLoad) {
        current++;

        // Find province name for display
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

          // Track that we've loaded this province
          _loadedProvinceCodes.add(provinceCode);

          // Refresh UI after each province for immediate feedback
          final allEntities = await _databaseService.getAllStations();
          _stations = allEntities.map((e) => e.toGasStation()).toList();

          if (_userPosition != null) {
            _distanceService.calculateDistances(
              _stations,
              _userPosition!.latitude,
              _userPosition!.longitude,
            );
          }
          _sortStations();
          notifyListeners();
        } catch (e) {
          print('Error loading province $provinceName: $e');
          // Continue with next province
        }

        // Yield to UI thread to prevent freezing
        await Future.delayed(Duration.zero);
      }

      _syncStatus = null;
      _loadingState = LoadingState.loaded;
      notifyListeners();

      // Pre-calculate sorted lists for all fuel types in background
      await _precalculateSortedLists();
    } catch (e) {
      _errorMessage = e.toString();
      _loadingState = LoadingState.error;
      _syncStatus = null;
    }

    notifyListeners();
  }

  /// Pre-calculate sorted lists for all fuel types in background
  /// This runs after initial data load and allows instant fuel type switching
  Future<void> _precalculateSortedLists() async {
    for (final fuelType in FuelType.values) {
      _processingStatus = 'Ordenando ${fuelType.displayName}...';
      notifyListeners();

      // Create sorted copy for this fuel type
      final sortedList = List<GasStation>.from(_stations);
      sortedList.sort((a, b) {
        final priceA = a.getPrice(fuelType) ?? double.infinity;
        final priceB = b.getPrice(fuelType) ?? double.infinity;
        return priceA.compareTo(priceB);
      });

      _sortedStationsCache[fuelType] = sortedList;

      // Yield to UI thread to keep app responsive
      await Future.delayed(Duration.zero);
    }

    _processingStatus = null;
    notifyListeners();
  }

  /// Sort stations based on current sort mode (synchronous - used during initial load)
  void _sortStations() {
    switch (_sortMode) {
      case SortMode.price:
        _stations.sort((a, b) {
          final priceA = a.getPrice(_selectedFuelType) ?? double.infinity;
          final priceB = b.getPrice(_selectedFuelType) ?? double.infinity;
          return priceA.compareTo(priceB);
        });
        break;
      case SortMode.distance:
        _distanceService.sortByDistance(_stations);
        break;
      case SortMode.combined:
        _sortByCombined();
        break;
    }
  }

  /// Sort stations asynchronously to keep UI responsive
  Future<void> _sortStationsAsync() async {
    // Yield to UI thread before sorting
    await Future.delayed(Duration.zero);

    switch (_sortMode) {
      case SortMode.price:
        _stations.sort((a, b) {
          final priceA = a.getPrice(_selectedFuelType) ?? double.infinity;
          final priceB = b.getPrice(_selectedFuelType) ?? double.infinity;
          return priceA.compareTo(priceB);
        });
        break;
      case SortMode.distance:
        _distanceService.sortByDistance(_stations);
        break;
      case SortMode.combined:
        await _sortByCombinedAsync();
        return; // Already yielded in _sortByCombinedAsync
    }

    // Yield again after sorting
    await Future.delayed(Duration.zero);
  }

  /// Combined sort: balance between price and distance (synchronous)
  void _sortByCombined() {
    if (_stations.isEmpty) return;

    // Get max values for normalization
    final prices = _stations
        .map((s) => s.getPrice(_selectedFuelType))
        .whereType<double>()
        .toList();
    final distances = _stations
        .map((s) => s.distanceKm)
        .whereType<double>()
        .toList();

    if (prices.isEmpty || distances.isEmpty) {
      _sortStations();
      return;
    }

    final maxPrice = prices.reduce((a, b) => a > b ? a : b);
    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    final maxDistance = distances.reduce((a, b) => a > b ? a : b);

    const priceWeight = 0.6;
    const distanceWeight = 0.4;

    _stations.sort((a, b) {
      final priceA = a.getPrice(_selectedFuelType) ?? maxPrice;
      final priceB = b.getPrice(_selectedFuelType) ?? maxPrice;
      final distA = a.distanceKm ?? maxDistance;
      final distB = b.distanceKm ?? maxDistance;

      // Normalize values 0-1
      final normPriceA = (priceA - minPrice) / (maxPrice - minPrice + 0.001);
      final normPriceB = (priceB - minPrice) / (maxPrice - minPrice + 0.001);
      final normDistA = distA / (maxDistance + 0.001);
      final normDistB = distB / (maxDistance + 0.001);

      final scoreA = (normPriceA * priceWeight) + (normDistA * distanceWeight);
      final scoreB = (normPriceB * priceWeight) + (normDistB * distanceWeight);

      return scoreA.compareTo(scoreB);
    });
  }

  /// Combined sort: balance between price and distance (async version)
  Future<void> _sortByCombinedAsync() async {
    if (_stations.isEmpty) return;

    // Yield to UI thread
    await Future.delayed(Duration.zero);

    // Get max values for normalization
    final prices = _stations
        .map((s) => s.getPrice(_selectedFuelType))
        .whereType<double>()
        .toList();
    final distances = _stations
        .map((s) => s.distanceKm)
        .whereType<double>()
        .toList();

    if (prices.isEmpty || distances.isEmpty) {
      _sortStations();
      return;
    }

    final maxPrice = prices.reduce((a, b) => a > b ? a : b);
    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    final maxDistance = distances.reduce((a, b) => a > b ? a : b);

    const priceWeight = 0.6;
    const distanceWeight = 0.4;

    _stations.sort((a, b) {
      final priceA = a.getPrice(_selectedFuelType) ?? maxPrice;
      final priceB = b.getPrice(_selectedFuelType) ?? maxPrice;
      final distA = a.distanceKm ?? maxDistance;
      final distB = b.distanceKm ?? maxDistance;

      // Normalize values 0-1
      final normPriceA = (priceA - minPrice) / (maxPrice - minPrice + 0.001);
      final normPriceB = (priceB - minPrice) / (maxPrice - minPrice + 0.001);
      final normDistA = distA / (maxDistance + 0.001);
      final normDistB = distB / (maxDistance + 0.001);

      final scoreA = (normPriceA * priceWeight) + (normDistA * distanceWeight);
      final scoreB = (normPriceB * priceWeight) + (normDistB * distanceWeight);

      return scoreA.compareTo(scoreB);
    });

    // Yield after sorting
    await Future.delayed(Duration.zero);
  }

  /// Get price category for coloring
  static PriceCategory getPriceCategory(
    double? price,
    List<GasStation> stations,
    FuelType fuelType,
  ) {
    if (price == null) return PriceCategory.unknown;

    final prices = stations
        .map((s) => s.getPrice(fuelType))
        .whereType<double>()
        .toList();

    if (prices.isEmpty) return PriceCategory.medium;

    prices.sort();
    final lowThreshold = prices[(prices.length * 0.33).floor()];
    final highThreshold = prices[(prices.length * 0.66).floor()];

    if (price <= lowThreshold) return PriceCategory.low;
    if (price >= highThreshold) return PriceCategory.high;
    return PriceCategory.medium;
  }
}

enum PriceCategory { low, medium, high, unknown }
