import 'package:flutter/foundation.dart';

/// Abstract interface for remote logging and crash reporting services.
///
/// Implementations should handle recording errors, crashes, and user context
/// to remote monitoring platforms (e.g., Firebase Crashlytics, Sentry).
abstract class RemoteLoggingService {
  /// Records a non-fatal error with optional stack trace and reason.
  ///
  /// Used for caught exceptions that should be logged remotely
  /// but don't crash the app.
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   await riskyOperation();
  /// } catch (error, stackTrace) {
  ///   await remoteLoggingService.recordError(
  ///     error,
  ///     stackTrace,
  ///     reason: 'Failed to complete risky operation',
  ///   );
  /// }
  /// ```
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    String? reason,
  });

  /// Records a Flutter framework error (typically from [FlutterError.onError]).
  ///
  /// This should be used as the handler for Flutter's error reporting:
  /// ```dart
  /// FlutterError.onError = remoteLoggingService.recordFlutterError;
  /// ```
  Future<void> recordFlutterError(FlutterErrorDetails details);

  /// Associates a user identifier with crash reports.
  ///
  /// Call this after successful authentication to track which user
  /// experienced crashes. The identifier will be included in all
  /// subsequent crash reports.
  ///
  /// Example:
  /// ```dart
  /// await remoteLoggingService.setUserIdentifier(user.id);
  /// ```
  Future<void> setUserIdentifier(String userId);

  /// Clears the user identifier from crash reports.
  ///
  /// Call this on logout to stop associating crashes with the user.
  ///
  /// Example:
  /// ```dart
  /// await remoteLoggingService.clearUserIdentifier();
  /// ```
  Future<void> clearUserIdentifier();
}
