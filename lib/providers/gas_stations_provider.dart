/// Main state management provider for gas stations
/// Now uses Isar database for caching and incremental updates
/// Optimized with Isolate-based sorting and pre-calculated price thresholds

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
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
  static const String _prefsKeyVisibleProvinces = 'visible_provinces';

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
  Set<String> _visibleProvinceCodes =
      {}; // Track current + nearby provinces for list filtering

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

  /// Get all stations filtered by search and fuel, but NOT by province (for Map)
  List<GasStation> get allFilteredStations {
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

  /// Get stations filtered by search, fuel AND province (for List)
  /// Only shows stations in the current or nearby provinces to avoid showing
  /// stations 500km away in the list.
  List<GasStation> get filteredStations {
    final baseList = allFilteredStations;

    if (_visibleProvinceCodes.isEmpty && _visibleProvinceNames.isEmpty) {
      // If we haven't determined location yet, strictly return nothing to avoid
      // showing stations from the wrong side of the country.
      // The user must wait for location/province determination.
      return [];
    }

    return baseList.where((s) {
      // We assume station.province contains the NAME, but we have CODES in _visibleProvinceCodes?
      // Wait, StationEntity has 'province' distinct from ID?
      // Looking at `GasStation` model: `final String province;`
      // Looking at `ApiService`: `Province` has ID and Name.
      // `GasStation.fromJSON`: `province: json['Provincia']` which is the NAME.
      // So we need to match names or codes.
      // The API returns Province names in the station object, not codes.
      // But `fetchStationsByProvince` takes a CODE.
      // So `_visibleProvinceCodes` has CODES.
      // We need to know the mapping or store allowed NAMES.

      // Let's check `_provinceLookupService`. It maps Code -> Bounds.
      // It doesn't seem to map Code -> Name directly exposed, but `fetchProvinces` returns `Province` objects (ID, Name).
      // So we should store allowed NAMES in `_visibleProvinceNames` instead of codes,
      // OR we fetch the names when we fetch the codes.

      // In `fetchStations`, we iterate over codes and get province names?
      // Yes: `final provinceName = allProvinces.firstWhere(...)`.

      // So let's filter by checking if the station's province NAME is in our allowed set.
      return _visibleProvinceNames.contains(s.province);
    }).toList();
  }

  // Helper set for province names
  Set<String> _visibleProvinceNames = {};

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

      final savedProvinces = prefs.getStringList(_prefsKeyVisibleProvinces);
      if (savedProvinces != null) {
        _visibleProvinceNames = savedProvinces.toSet();
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

      // Clear previous visible set and add new ones
      _visibleProvinceCodes = provincesToLoad.toSet();
      _visibleProvinceNames.clear();

      // Populate visible province names for filtering
      for (final code in provincesToLoad) {
        final p = allProvinces.firstWhere(
          (p) => p.id == code,
          orElse: () => Province(id: code, name: ''),
        );
        if (p.name.isNotEmpty) {
          _visibleProvinceNames.add(p.name);
        }
      }

      // Persist visible province names
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        _prefsKeyVisibleProvinces,
        _visibleProvinceNames.toList(),
      );

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
        const priceWeight = 0.50;
        const distanceWeight = 0.50;

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

  /// Get stations optimized for the map viewport (grid clustering)
  /// Returns a subset of stations based on zoom level and bounds
  List<GasStation> getStationsForMap({
    required LatLngBounds bounds,
    required double zoom,
  }) {
    // 1. If strict filtering is active (e.g. searching), just return those
    // or maybe we still want clustering? Let's clustering always for performance.
    // actually if user searches "Repsol", they want to see ALL Repsols.
    // So if search query is active, disable clustering (unless result count is huge).

    final sourceList = allFilteredStations; // Use unrestricted list for map

    if (_searchQuery.isNotEmpty) {
      if (sourceList.length < 50) return sourceList; // Show all if few
    }

    // 2. Filter by bounds first (coarse filter)
    // Add some padding to bounds to avoid items popping in/out at edges
    final paddedBounds = LatLngBounds(
      LatLng(bounds.south - 0.1, bounds.west - 0.1),
      LatLng(bounds.north + 0.1, bounds.east + 0.1),
    );

    final visibleStations = sourceList.where((s) {
      return paddedBounds.contains(LatLng(s.latitude, s.longitude));
    }).toList();

    // 3. If zoom is high enough, return all visible
    if (zoom >= 13.0) {
      return visibleStations;
    }

    // 4. Grid clustering based on zoom
    // Lower zoom = larger grid cells = fewer stations
    // Grid size in degrees approx.
    double gridSize;
    int maxPerCell;

    // Trigger background load for visible provinces
    _scheduleProvinceCheck(bounds);

    if (zoom <= 6) {
      gridSize = 2.0; // Whole Spain view -> very coarse (approx 200km)
      maxPerCell = 1;
    } else if (zoom <= 8) {
      gridSize = 0.8; // Region view (approx 80km)
      maxPerCell = 1;
    } else if (zoom <= 10) {
      gridSize = 0.25; // Province view (approx 25km)
      maxPerCell = 1; // Only 1 best station per 25km block
    } else if (zoom <= 11.5) {
      gridSize = 0.05; // City approach
      maxPerCell = 2;
    } else {
      // Zoom > 11.5
      gridSize = 0.01; // City details
      maxPerCell = 3;
    }

    final Map<String, List<GasStation>> grid = {};

    for (var s in visibleStations) {
      // Calculate grid key
      final latKey = (s.latitude / gridSize).floor();
      final lngKey = (s.longitude / gridSize).floor();
      final key = '$latKey,$lngKey';

      if (!grid.containsKey(key)) {
        grid[key] = [];
      }
      grid[key]!.add(s);
    }

    final List<GasStation> result = [];

    grid.forEach((key, stationsInCell) {
      if (stationsInCell.length <= maxPerCell) {
        result.addAll(stationsInCell);
      } else {
        // Sort by CURRENT fuel price
        stationsInCell.sort((a, b) {
          final pA = a.getPrice(_selectedFuelType) ?? double.infinity;
          final pB = b.getPrice(_selectedFuelType) ?? double.infinity;
          return pA.compareTo(pB);
        });
        result.addAll(stationsInCell.take(maxPerCell));
      }
    });

    return result;
  }

  Timer? _bgLoadTimer;
  bool _isBackgroundLoading = false;

  void _scheduleProvinceCheck(LatLngBounds bounds) {
    if (_bgLoadTimer?.isActive ?? false) return;

    // Debounce to avoid checking on every frame/pan
    _bgLoadTimer = Timer(const Duration(seconds: 1), () {
      _checkAndLoadProvinces(bounds);
    });
  }

  Future<void> _checkAndLoadProvinces(LatLngBounds bounds) async {
    if (_isBackgroundLoading) return;

    final visibleProvinces = _provinceLookupService.getProvincesInBounds(
      bounds.south,
      bounds.north,
      bounds.west,
      bounds.east,
    );

    final missingProvinces = visibleProvinces
        .where((code) => !_loadedProvinceCodes.contains(code))
        .toList();

    if (missingProvinces.isEmpty) return;

    _isBackgroundLoading = true;
    notifyListeners(); // Optionally notify to show a small loader?

    try {
      // Load one by one to keep UI responsive
      for (final provinceCode in missingProvinces) {
        // Double check if already loaded by another process
        if (_loadedProvinceCodes.contains(provinceCode)) continue;

        try {
          final stations = await _apiService.fetchStationsByProvince(
            provinceCode,
          );
          final entities = stations
              .map((s) => StationEntity.fromGasStation(s))
              .toList();

          await _databaseService.saveStations(entities);
          _loadedProvinceCodes.add(provinceCode);

          // Update in-memory list
          final allEntities = await _databaseService.getAllStations();
          _stations = allEntities.map((e) => e.toGasStation()).toList();

          // Re-sort/calc in background
          _calculatePriceThresholds();

          // Notify listeners to update map with new data
          notifyListeners();

          // Small delay to yield to UI
          await Future.delayed(const Duration(milliseconds: 100));
        } catch (e) {
          print('Error bg loading province $provinceCode: $e');
        }
      }

      // Final sort after batch
      await _sortStationsAsync();
    } finally {
      _isBackgroundLoading = false;
      notifyListeners();
    }
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
