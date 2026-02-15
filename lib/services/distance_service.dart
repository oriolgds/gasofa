/// Distance service for calculating distances between locations
library;

import 'package:geolocator/geolocator.dart';
import '../models/gas_station.dart';

class DistanceService {
  static final DistanceService _instance = DistanceService._internal();
  factory DistanceService() => _instance;
  DistanceService._internal();

  /// Calculate distance between two coordinates in kilometers
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000;
  }

  /// Calculate distances for a list of gas stations from a given position
  void calculateDistances(
    List<GasStation> stations,
    double userLat,
    double userLon,
  ) {
    for (var station in stations) {
      station.distanceKm = calculateDistance(
        userLat,
        userLon,
        station.latitude,
        station.longitude,
      );
    }
  }

  /// Sort stations by distance (closest first)
  void sortByDistance(List<GasStation> stations) {
    stations.sort((a, b) {
      if (a.distanceKm == null && b.distanceKm == null) return 0;
      if (a.distanceKm == null) return 1;
      if (b.distanceKm == null) return -1;
      return a.distanceKm!.compareTo(b.distanceKm!);
    });
  }
}
