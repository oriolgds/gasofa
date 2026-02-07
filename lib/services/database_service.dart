import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/station_entity.dart';
import 'package:flutter/foundation.dart';

class DatabaseService {
  late Future<Isar> db;

  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;

  DatabaseService._internal() {
    db = _initDB();
  }

  Future<Isar> _initDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [StationEntitySchema],
        directory: dir.path,
        inspector: kDebugMode,
      );
    }
    return Future.value(Isar.getInstance());
  }

  /// Save a list of stations to the database
  Future<void> saveStations(List<StationEntity> stations) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.stationEntitys.putAll(stations);
    });
  }

  /// Get all stations
  Future<List<StationEntity>> getAllStations() async {
    final isar = await db;
    return await isar.stationEntitys.where().findAll();
  }

  /// Get stations by province
  Future<List<StationEntity>> getStationsByProvince(String provinceCode) async {
    // Note: The API returns province names or IDs. We store what the API gives us.
    // If filtering by ID is needed, ensure the model has it.
    // For now assuming we filter by filtering the full list or using a query if we had strict IDs.
    // Since 'province' field in entity is the name, we might need adjustments if we filter by code '08'.
    // However, the provider often deals with codes. Let's see what the API returns in 'Provincia'.
    // It returns names usually like "BARCELONA".

    final isar = await db;
    // Simple implementation: return all and let provider filter or implement exact match if we know the string
    // But optimal is database filtering.
    // Let's assume for now we want everything and filter in memory or get all.
    return await isar.stationEntitys
        .filter()
        .provinceContains(provinceCode, caseSensitive: false)
        .findAll();
  }

  /// Clear all data
  Future<void> clearAll() async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.stationEntitys.clear();
    });
  }

  /// Get count of stations
  Future<int> getCount() async {
    final isar = await db;
    return await isar.stationEntitys.count();
  }
}
