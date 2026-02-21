import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/gas_stations_provider.dart';
import 'services/preferences_service.dart';
import 'services/update_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Pre-load preferences
  final prefs = await PreferencesService.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GasStationsProvider()),
        ChangeNotifierProvider(create: (_) => UpdateService()),
      ],
      child: GasofaApp(isFirstLaunch: prefs.isFirstLaunch),
    ),
  );
}
