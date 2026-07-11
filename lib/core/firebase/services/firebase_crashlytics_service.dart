import 'package:fandag/core/firebase/firebase.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Firebase Crashlytics implementation of [RemoteLoggingService].
///
/// Delegates all crash reporting and error logging to Firebase Crashlytics.
class FirebaseCrashlyticsService implements RemoteLoggingService {
  /// Creates a [FirebaseCrashlyticsService] with the given Crashlytics instance.
  const FirebaseCrashlyticsService({required FirebaseCrashlytics crashlytics})
    : _crashlytics = crashlytics;

  final FirebaseCrashlytics _crashlytics;

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    String? reason,
  }) async {
    await _crashlytics.recordError(
      error,
      stackTrace,
      reason: reason,
      fatal: false,
    );
  }

  @override
  Future<void> recordFlutterError(FlutterErrorDetails details) async {
    await _crashlytics.recordFlutterFatalError(details);
  }

  @override
  Future<void> setUserIdentifier(String userId) async {
    await _crashlytics.setUserIdentifier(userId);
  }

  @override
  Future<void> clearUserIdentifier() async {
    await _crashlytics.setUserIdentifier('');
  }
}
