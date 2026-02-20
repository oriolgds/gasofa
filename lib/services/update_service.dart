/// Service to check Google Play for available app updates
library;

import 'package:in_app_update/in_app_update.dart';

class UpdateService {
  AppUpdateInfo? _updateInfo;

  /// Returns true if a flexible or immediate update is available on Play Store.
  bool get updateAvailable {
    final info = _updateInfo;
    if (info == null) return false;
    return info.updateAvailability == UpdateAvailability.updateAvailable;
  }

  /// Silently checks for updates. Call once at app start.
  Future<void> checkForUpdate() async {
    try {
      _updateInfo = await InAppUpdate.checkForUpdate();
    } catch (_) {
      // Not on Play Store (debug, iOS, etc.) — ignore silently.
      _updateInfo = null;
    }
  }

  /// Starts the flexible update flow. Call when user taps the update button.
  Future<void> startFlexibleUpdate() async {
    try {
      await InAppUpdate.startFlexibleUpdate();
      await InAppUpdate.completeFlexibleUpdate();
    } catch (_) {
      // Ignore — Play core not available.
    }
  }
}
