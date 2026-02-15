/// Gas station model with price and location data
library;

import 'fuel_type.dart';

class GasStation {
  final String id;
  final String name;
  final String address;
  final String postalCode;
  final String locality;
  final String municipality;
  final String province;
  final double latitude;
  final double longitude;
  final String schedule;
  final Map<FuelType, double?> prices;
  double? distanceKm;

  GasStation({
    required this.id,
    required this.name,
    required this.address,
    required this.postalCode,
    required this.locality,
    required this.municipality,
    required this.province,
    required this.latitude,
    required this.longitude,
    required this.schedule,
    required this.prices,
    this.distanceKm,
  });

  factory GasStation.fromJson(Map<String, dynamic> json) {
    return GasStation(
      id: json['IDEESS'] ?? '',
      name: json['Rótulo'] ?? 'Desconocido',
      address: json['Dirección'] ?? '',
      postalCode: json['C.P.'] ?? '',
      locality: json['Localidad'] ?? '',
      municipality: json['Municipio'] ?? '',
      province: json['Provincia'] ?? '',
      latitude: _parseCoordinate(json['Latitud']),
      longitude: _parseCoordinate(json['Longitud (WGS84)']),
      schedule: json['Horario'] ?? '',
      prices: _parsePrices(json),
    );
  }

  static double _parseCoordinate(String? value) {
    if (value == null || value.isEmpty) return 0.0;
    return double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
  }

  static Map<FuelType, double?> _parsePrices(Map<String, dynamic> json) {
    return {
      for (var fuelType in FuelType.values)
        fuelType: _parsePrice(json[fuelType.apiField]),
    };
  }

  static double? _parsePrice(String? value) {
    if (value == null || value.isEmpty) return null;
    return double.tryParse(value.replaceAll(',', '.'));
  }

  /// Get price for a specific fuel type
  double? getPrice(FuelType fuelType) => prices[fuelType];

  /// Check if station has price for a specific fuel type
  bool hasPrice(FuelType fuelType) => prices[fuelType] != null;

  /// Get formatted price string
  String getPriceFormatted(FuelType fuelType) {
    final price = prices[fuelType];
    if (price == null) return '-';
    return '${price.toStringAsFixed(3)} €/L';
  }

  /// Get formatted distance string
  String get distanceFormatted {
    if (distanceKm == null) return '-';
    if (distanceKm! < 1) {
      return '${(distanceKm! * 1000).round()} m';
    }
    return '${distanceKm!.toStringAsFixed(1)} km';
  }
}
