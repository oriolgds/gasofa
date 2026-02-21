/// App widget with pastel theme and onboarding flow
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'config/theme.dart';
import 'screens/onboarding_screen.dart';
import 'screens/main_shell.dart';

class GasofaApp extends StatefulWidget {
  final bool isFirstLaunch;

  const GasofaApp({super.key, required this.isFirstLaunch});

  @override
  State<GasofaApp> createState() => _GasofaAppState();
}

class _GasofaAppState extends State<GasofaApp> {
  late bool _showOnboarding;

  @override
  void initState() {
    super.initState();
    _showOnboarding = widget.isFirstLaunch;

    // Set system UI style for light/dark
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GASOFA',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: GasofaTheme.lightTheme,
      darkTheme: GasofaTheme.darkTheme,
      home: _showOnboarding
          ? OnboardingScreen(
              onComplete: () {
                setState(() => _showOnboarding = false);
              },
            )
          : const MainShell(),
    );
  }
}
