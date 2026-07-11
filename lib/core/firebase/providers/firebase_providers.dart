import 'package:fandag/core/firebase/firebase.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_providers.g.dart';

/// Provides the singleton instance of [FirebaseCrashlytics].
///
/// This is a low-level provider that exposes the Firebase SDK directly.
/// Most code should use [remoteLoggingServiceProvider] instead.
@Riverpod(keepAlive: true)
FirebaseCrashlytics firebaseCrashlytics(Ref ref) {
  return FirebaseCrashlytics.instance;
}

/// Provides the singleton instance of [FirebaseAnalytics].
///
/// This is a low-level provider that exposes the Firebase SDK directly.
/// Most code should use [analyticsServiceProvider] instead.
@Riverpod(keepAlive: true)
FirebaseAnalytics firebaseAnalytics(Ref ref) {
  return FirebaseAnalytics.instance;
}

/// Provides the singleton instance of [FirebaseMessaging].
///
/// This is a low-level provider that exposes the Firebase SDK directly.
/// Most code should use [firebaseMessagingServiceProvider] instead.
@Riverpod(keepAlive: true)
FirebaseMessaging firebaseMessaging(Ref ref) {
  return FirebaseMessaging.instance;
}

/// Provides the [RemoteLoggingService] implementation.
///
/// Use this provider to record errors and crashes to Firebase Crashlytics.
///
/// Example:
/// ```dart
/// final RemoteLoggingService loggingService = ref.read(remoteLoggingServiceProvider);
/// try {
///   await riskyOperation();
/// } catch (error, stackTrace) {
///   await loggingService.recordError(error, stackTrace);
/// }
/// ```
@Riverpod(keepAlive: true)
RemoteLoggingService remoteLoggingService(Ref ref) {
  final FirebaseCrashlytics crashlytics = ref.watch(
    firebaseCrashlyticsProvider,
  );
  return FirebaseCrashlyticsService(crashlytics: crashlytics);
}

/// Provides the [AnalyticsService] implementation.
///
/// Use this provider to log analytics events to Firebase Analytics.
///
/// Example:
/// ```dart
/// final AnalyticsService analytics = ref.read(analyticsServiceProvider);
/// await analytics.logEvent('button_clicked', parameters: {'button_id': 'submit'});
/// ```
@Riverpod(keepAlive: true)
AnalyticsService analyticsService(Ref ref) {
  final FirebaseAnalytics analytics = ref.watch(firebaseAnalyticsProvider);
  return FirebaseAnalyticsService(analytics: analytics);
}

/// Provides the [FirebaseMessagingService] implementation.
///
/// Use this provider to handle push notifications with Firebase Cloud Messaging.
///
/// Example:
/// ```dart
/// final FirebaseMessagingService messaging = ref.read(firebaseMessagingServiceProvider);
/// final String? token = await messaging.getToken();
/// ```
@Riverpod(keepAlive: true)
FirebaseMessagingService firebaseMessagingService(Ref ref) {
  final FirebaseMessaging messaging = ref.watch(firebaseMessagingProvider);
  return FirebaseMessagingService(messaging: messaging);
}
