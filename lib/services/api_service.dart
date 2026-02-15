/// API Service for fetching gas station data from the Ministry of Industry
library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/constants.dart';
import '../models/gas_station.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  /// Fetch all gas stations in Spain
  Future<List<GasStation>> fetchAllStations() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.allStations}'),
    );

    if (response.statusCode == 200) {
      return _parseStationsResponse(response.body);
    } else {
      throw Exception('Error al obtener estaciones: ${response.statusCode}');
    }
  }

  /// Fetch gas stations by province code
  Future<List<GasStation>> fetchStationsByProvince(String provinceCode) async {
    final response = await http.get(
      Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.stationsByProvince}$provinceCode',
      ),
    );

    if (response.statusCode == 200) {
      return _parseStationsResponse(response.body);
    } else {
      throw Exception(
        'Error al obtener estaciones de la provincia: ${response.statusCode}',
      );
    }
  }

  /// Fetch list of provinces
  Future<List<Province>> fetchProvinces() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.provinces}'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Province.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener provincias: ${response.statusCode}');
    }
  }

  /// Parse the JSON response and return list of GasStation
  List<GasStation> _parseStationsResponse(String responseBody) {
    final Map<String, dynamic> jsonData = json.decode(responseBody);

    if (jsonData['ResultadoConsulta'] != 'OK') {
      throw Exception('La consulta a la API falló');
    }

    final List<dynamic> stationsList = jsonData['ListaEESSPrecio'] ?? [];

    return stationsList
        .map((stationJson) => GasStation.fromJson(stationJson))
        .where((station) => station.latitude != 0 && station.longitude != 0)
        .toList();
  }
}

class Province {
  final String id;
  final String name;

  Province({required this.id, required this.name});

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      id: json['IDPovincia'] ?? '',
      name: json['Provincia'] ?? '',
    );
  }
}
