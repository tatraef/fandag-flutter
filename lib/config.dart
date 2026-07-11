import 'package:flutter/foundation.dart';

/// Application-wide configuration.
///
/// The backend base URL lives here so it can be switched per environment
/// without touching the rest of the code.
///
/// Values for different environments:
/// - Web (Chrome):      `http://localhost:3000`
/// - Android emulator:  `http://10.0.2.2:3000`
/// - iOS simulator:     `http://localhost:3000`
/// - Real device:       `http://<computer-IP>:3000` (same Wi-Fi network)
/// - Production (later): VPS domain
abstract class ApiConfig {
  /// Base URL of the Fændag backend.
  ///
  /// Android emulators reach the host machine via the `10.0.2.2` alias, while
  /// web and every other platform talk to `localhost` directly.
  static String get baseUrl {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000';
    }

    return 'http://localhost:3000';
  }
}
