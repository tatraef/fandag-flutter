import 'dart:async';
import 'dart:ui';

import 'package:fandag/app.dart';
import 'package:fandag/core/firebase/firebase.dart';
import 'package:fandag/core/inspector/inspector.dart';
import 'package:fandag/core/storage/storage.dart';
import 'package:fandag/core/translations/generated/translations.g.dart';
import 'package:fandag/core/utils/debug_print.dart';
import 'package:fandag/core/widgets/widgets.dart';
import 'package:fandag/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart' hide debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Initialize Firebase Core
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      await LocaleSettings.useDeviceLocale();
      await initMadInspector();

      final SharedPreferences sharedPrefs =
          await SharedPreferences.getInstance();

      // Create ProviderContainer early to access services for error handlers
      final ProviderContainer container = ProviderContainer(
        // ignore: always_specify_types
        overrides: [sharedPrefsProvider.overrideWithValue(sharedPrefs)],
      );

      // Get logging service through our abstraction
      final RemoteLoggingService loggingService = container.read(
        remoteLoggingServiceProvider,
      );

      // Configure error handlers using our service abstraction
      FlutterError.onError = loggingService.recordFlutterError;

      PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
        loggingService.recordError(error, stack, reason: 'Platform error');
        return true;
      };

      runApp(
        TranslationProvider(
          child: ReloadableWidget(
            builder: (BuildContext context) => UncontrolledProviderScope(
              container: container,
              child: const App(),
            ),
          ),
        ),
      );
    },
    (Object error, StackTrace stackTrace) {
      debugPrint(
        'Zone error',
        tag: 'Zone',
        error: error,
        stackTrace: stackTrace,
      );

      // Note: In zone error handler we can't reliably access the container,
      // so we fall back to direct Firebase access here. This is acceptable
      // as it's a safety net for errors during app initialization.
      // After app is running, errors go through the service abstraction.
      try {
        Firebase.app();
        // Firebase is initialized, safe to use
        final RemoteLoggingService loggingService = FirebaseCrashlyticsService(
          crashlytics: FirebaseCrashlytics.instance,
        );
        loggingService.recordError(error, stackTrace, reason: 'Zone error');
      } catch (_) {
        // Firebase not initialized yet, skip remote logging
      }
    },
  );
}
