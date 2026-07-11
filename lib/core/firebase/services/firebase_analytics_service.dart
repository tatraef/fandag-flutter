import 'package:fandag/core/firebase/firebase.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

/// Firebase Analytics implementation of [AnalyticsService].
///
/// Delegates all analytics tracking to Firebase Analytics.
class FirebaseAnalyticsService implements AnalyticsService {
  /// Creates a [FirebaseAnalyticsService] with the given Analytics instance.
  const FirebaseAnalyticsService({required FirebaseAnalytics analytics})
    : _analytics = analytics;

  final FirebaseAnalytics _analytics;

  @override
  Future<void> logEvent(String name, {Map<String, Object?>? parameters}) async {
    // Validate event name constraints (Firebase requirements)
    if (name.isEmpty || name.length > 40) {
      throw ArgumentError(
        'Event name must be between 1 and 40 characters. Got: "$name"',
      );
    }

    // Filter out null values for Firebase Analytics compatibility
    final Map<String, Object>? nonNullParameters = parameters
        ?.map(
          (String key, Object? value) => MapEntry<String, Object?>(key, value),
        )
        .cast<String, Object>();

    await _analytics.logEvent(name: name, parameters: nonNullParameters);
  }

  @override
  Future<void> setUserId(String? userId) async {
    await _analytics.setUserId(id: userId);
  }

  @override
  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  @override
  Future<void> setCurrentScreen(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }
}
