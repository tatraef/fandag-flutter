/// Abstract interface for analytics event tracking.
///
/// Implementations should handle logging events, user properties, and screen views
/// to analytics platforms (e.g., Firebase Analytics, Mixpanel, Amplitude).
abstract class AnalyticsService {
  /// Logs an analytics event with optional parameters.
  ///
  /// Event names should follow these constraints:
  /// - Max 40 characters
  /// - Alphanumeric, underscore, and hyphen characters only
  /// - Must start with an alphabetic character
  ///
  /// Example:
  /// ```dart
  /// await analyticsService.logEvent(
  ///   'purchase_completed',
  ///   parameters: {
  ///     'item_id': 'SKU_123',
  ///     'price': 29.99,
  ///     'currency': 'USD',
  ///   },
  /// );
  /// ```
  Future<void> logEvent(String name, {Map<String, Object?>? parameters});

  /// Sets the user ID for analytics tracking.
  ///
  /// Call this after successful authentication to associate
  /// analytics events with a specific user.
  ///
  /// Pass `null` to clear the user ID (e.g., on logout).
  ///
  /// Example:
  /// ```dart
  /// await analyticsService.setUserId(user.id);
  /// ```
  Future<void> setUserId(String? userId);

  /// Sets a custom user property for analytics segmentation.
  ///
  /// User properties are attributes you can use to define segments
  /// of your user base (e.g., language preference, subscription tier).
  ///
  /// Example:
  /// ```dart
  /// await analyticsService.setUserProperty(
  ///   name: 'subscription_tier',
  ///   value: 'premium',
  /// );
  /// ```
  Future<void> setUserProperty({required String name, required String? value});

  /// Sets the current screen name for analytics tracking.
  ///
  /// Call this when navigating to a new screen to track
  /// screen views in your analytics platform.
  ///
  /// Example:
  /// ```dart
  /// await analyticsService.setCurrentScreen('home_screen');
  /// ```
  Future<void> setCurrentScreen(String screenName);
}
