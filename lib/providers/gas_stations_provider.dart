/// Main state management provider for gas stations

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../models/fuel_type.dart';
import '../models/gas_station.dart';
import '../services/api_service.dart';
import '../services/location_service.dart';
import '../services/distance_service.dart';

enum SortMode { price, distance, combined }

enum LoadingState { idle, loading, loaded, error }

class GasStationsProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final LocationService _locationService = LocationService();
  final DistanceService _distanceService = DistanceService();

  // State
  List<GasStation> _stations = [];
  LoadingState _loadingState = LoadingState.idle;
  String? _errorMessage;
  FuelType _selectedFuelType = FuelType.gasolina95;
  String? _selectedProvinceCode;
  SortMode _sortMode = SortMode.price;
  Position? _userPosition;
  bool _useLocation = false;

  // Getters
  List<GasStation> get stations => _stations;
  LoadingState get loadingState => _loadingState;
  String? get errorMessage => _errorMessage;
  FuelType get selectedFuelType => _selectedFuelType;
  String? get selectedProvinceCode => _selectedProvinceCode;
  SortMode get sortMode => _sortMode;
  Position? get userPosition => _userPosition;
  bool get useLocation => _useLocation;
  bool get hasLocation => _userPosition != null;

  /// Get filtered stations (only those with selected fuel type price)
  List<GasStation> get filteredStations {
    return _stations.where((s) => s.hasPrice(_selectedFuelType)).toList();
  }

  /// Set fuel type filter
  void setFuelType(FuelType fuelType) {
    _selectedFuelType = fuelType;
    _sortStations();
    notifyListeners();
  }

  /// Set province filter
  void setProvince(String? provinceCode) {
    _selectedProvinceCode = provinceCode;
    notifyListeners();
  }

  /// Set sort mode
  void setSortMode(SortMode mode) {
    _sortMode = mode;
    _sortStations();
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

  /// Fetch stations based on current filters
  Future<void> fetchStations() async {
    _loadingState = LoadingState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_useLocation && _userPosition == null) {
        await fetchUserLocation();
      }

      if (_selectedProvinceCode != null) {
        _stations = await _apiService.fetchStationsByProvince(
          _selectedProvinceCode!,
        );
      } else {
        // If using location, we fetch all and filter by distance
        // For performance, you might want to fetch by province based on user's location
        _stations = await _apiService.fetchStationsByProvince(
          '08',
        ); // Default to Barcelona for demo
      }

      // Calculate distances if we have user location
      if (_userPosition != null) {
        _distanceService.calculateDistances(
          _stations,
          _userPosition!.latitude,
          _userPosition!.longitude,
        );
      }

      _sortStations();
      _loadingState = LoadingState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _loadingState = LoadingState.error;
    }

    notifyListeners();
  }

  /// Sort stations based on current sort mode
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

  /// Combined sort: balance between price and distance
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
