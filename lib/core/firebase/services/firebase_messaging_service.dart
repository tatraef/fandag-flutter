import 'package:firebase_messaging/firebase_messaging.dart';

/// Firebase Cloud Messaging service for handling push notifications.
///
/// Provides basic FCM functionality:
/// - Token management
/// - Permission requests
/// - Foreground/background message handling
class FirebaseMessagingService {
  /// Creates a [FirebaseMessagingService] with the given Messaging instance.
  const FirebaseMessagingService({required FirebaseMessaging messaging})
    : _messaging = messaging;

  final FirebaseMessaging _messaging;

  /// Requests notification permissions from the user.
  ///
  /// Returns the authorization status after the request.
  /// On iOS, this will show the native permission dialog.
  /// On Android 12 and below, permissions are granted automatically.
  ///
  /// Example:
  /// ```dart
  /// final NotificationSettings settings =
  ///     await messagingService.requestPermission();
  /// if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  ///   debugPrint('User granted permission');
  /// }
  /// ```
  Future<NotificationSettings> requestPermission() async {
    final NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    return settings;
  }

  /// Gets the current FCM registration token.
  ///
  /// This token uniquely identifies this app installation and is used
  /// to send push notifications to this device.
  ///
  /// Returns `null` if the token is not available yet.
  ///
  /// Example:
  /// ```dart
  /// final String? token = await messagingService.getToken();
  /// if (token != null) {
  ///   debugPrint('FCM Token: $token');
  ///   // Send token to your backend
  /// }
  /// ```
  Future<String?> getToken() async {
    return _messaging.getToken();
  }

  /// Subscribes to a topic for receiving targeted notifications.
  ///
  /// Topic names can be any string that matches the regex `[a-zA-Z0-9-_.~%]+`.
  ///
  /// Example:
  /// ```dart
  /// await messagingService.subscribeToTopic('news');
  /// ```
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }

  /// Unsubscribes from a topic.
  ///
  /// Example:
  /// ```dart
  /// await messagingService.unsubscribeFromTopic('news');
  /// ```
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }

  /// Sets up foreground message handler.
  ///
  /// Call this during app initialization to handle messages
  /// that arrive while the app is in the foreground.
  ///
  /// Example:
  /// ```dart
  /// messagingService.onForegroundMessage((RemoteMessage message) {
  ///   debugPrint('Foreground message: ${message.notification?.title}');
  ///   // Show in-app notification or update UI
  /// });
  /// ```
  void onForegroundMessage(void Function(RemoteMessage message) handler) {
    FirebaseMessaging.onMessage.listen(handler);
  }

  /// Sets up background message handler.
  ///
  /// Call this during app initialization to handle messages
  /// that arrive while the app is in the background or terminated.
  ///
  /// Note: The handler must be a top-level function, not a class method.
  ///
  /// Example:
  /// ```dart
  /// @pragma('vm:entry-point')
  /// Future<void> _firebaseMessagingBackgroundHandler(
  ///   RemoteMessage message,
  /// ) async {
  ///   await Firebase.initializeApp();
  ///   debugPrint('Background message: ${message.notification?.title}');
  /// }
  ///
  /// // In initialization:
  /// FirebaseMessaging.onBackgroundMessage(
  ///   _firebaseMessagingBackgroundHandler,
  /// );
  /// ```
  static void onBackgroundMessage(BackgroundMessageHandler handler) {
    FirebaseMessaging.onBackgroundMessage(handler);
  }
}
