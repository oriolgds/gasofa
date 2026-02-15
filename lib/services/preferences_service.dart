/// Preferences service for first-launch detection and settings
library;

import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _keyFirstLaunch = 'first_launch_completed';
  static const String _keyDefaultProvince = 'default_province';

  static PreferencesService? _instance;
  late SharedPreferences _prefs;

  PreferencesService._();

  static Future<PreferencesService> getInstance() async {
    if (_instance == null) {
      _instance = PreferencesService._();
      _instance!._prefs = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  bool get isFirstLaunch => !(_prefs.getBool(_keyFirstLaunch) ?? false);

  Future<void> completeFirstLaunch() async {
    await _prefs.setBool(_keyFirstLaunch, true);
  }

  String? get defaultProvince => _prefs.getString(_keyDefaultProvince);

  Future<void> setDefaultProvince(String? province) async {
    if (province != null) {
      await _prefs.setString(_keyDefaultProvince, province);
    } else {
      await _prefs.remove(_keyDefaultProvince);
    }
  }
}
