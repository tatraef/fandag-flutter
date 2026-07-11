import 'package:fandag/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Initializes Firebase services for the application.
///
/// This function should be called once during app startup, before
/// any other Firebase services are used.
///
/// It performs the following:
/// - Initializes Firebase Core with platform-specific options
/// - Configures Crashlytics to catch Flutter framework errors
/// - Configures Crashlytics to catch platform-specific errors
///
/// Example usage in main.dart:
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await initFirebase();
///   // ... rest of initialization
/// }
/// ```
Future<void> initFirebase() async {
  // Initialize Firebase with platform-specific configuration
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Configure Crashlytics to catch Flutter framework errors
  // This sets the global error handler for Flutter framework errors
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Configure Crashlytics to catch platform-specific errors
  // This handles errors from the platform (iOS/Android) that cross
  // into the Flutter engine
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
}
