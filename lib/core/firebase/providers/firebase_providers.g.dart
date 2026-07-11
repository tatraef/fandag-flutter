// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the singleton instance of [FirebaseCrashlytics].
///
/// This is a low-level provider that exposes the Firebase SDK directly.
/// Most code should use [remoteLoggingServiceProvider] instead.

@ProviderFor(firebaseCrashlytics)
final firebaseCrashlyticsProvider = FirebaseCrashlyticsProvider._();

/// Provides the singleton instance of [FirebaseCrashlytics].
///
/// This is a low-level provider that exposes the Firebase SDK directly.
/// Most code should use [remoteLoggingServiceProvider] instead.

final class FirebaseCrashlyticsProvider
    extends
        $FunctionalProvider<
          FirebaseCrashlytics,
          FirebaseCrashlytics,
          FirebaseCrashlytics
        >
    with $Provider<FirebaseCrashlytics> {
  /// Provides the singleton instance of [FirebaseCrashlytics].
  ///
  /// This is a low-level provider that exposes the Firebase SDK directly.
  /// Most code should use [remoteLoggingServiceProvider] instead.
  FirebaseCrashlyticsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firebaseCrashlyticsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firebaseCrashlyticsHash();

  @$internal
  @override
  $ProviderElement<FirebaseCrashlytics> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FirebaseCrashlytics create(Ref ref) {
    return firebaseCrashlytics(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseCrashlytics value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseCrashlytics>(value),
    );
  }
}

String _$firebaseCrashlyticsHash() =>
    r'ec3f4a67182053acbe6ec6a982a70fe6adbd1a3a';

/// Provides the singleton instance of [FirebaseAnalytics].
///
/// This is a low-level provider that exposes the Firebase SDK directly.
/// Most code should use [analyticsServiceProvider] instead.

@ProviderFor(firebaseAnalytics)
final firebaseAnalyticsProvider = FirebaseAnalyticsProvider._();

/// Provides the singleton instance of [FirebaseAnalytics].
///
/// This is a low-level provider that exposes the Firebase SDK directly.
/// Most code should use [analyticsServiceProvider] instead.

final class FirebaseAnalyticsProvider
    extends
        $FunctionalProvider<
          FirebaseAnalytics,
          FirebaseAnalytics,
          FirebaseAnalytics
        >
    with $Provider<FirebaseAnalytics> {
  /// Provides the singleton instance of [FirebaseAnalytics].
  ///
  /// This is a low-level provider that exposes the Firebase SDK directly.
  /// Most code should use [analyticsServiceProvider] instead.
  FirebaseAnalyticsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firebaseAnalyticsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firebaseAnalyticsHash();

  @$internal
  @override
  $ProviderElement<FirebaseAnalytics> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FirebaseAnalytics create(Ref ref) {
    return firebaseAnalytics(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseAnalytics value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseAnalytics>(value),
    );
  }
}

String _$firebaseAnalyticsHash() => r'50223a2a038fe07ae55006344e88f86923613e7d';

/// Provides the singleton instance of [FirebaseMessaging].
///
/// This is a low-level provider that exposes the Firebase SDK directly.
/// Most code should use [firebaseMessagingServiceProvider] instead.

@ProviderFor(firebaseMessaging)
final firebaseMessagingProvider = FirebaseMessagingProvider._();

/// Provides the singleton instance of [FirebaseMessaging].
///
/// This is a low-level provider that exposes the Firebase SDK directly.
/// Most code should use [firebaseMessagingServiceProvider] instead.

final class FirebaseMessagingProvider
    extends
        $FunctionalProvider<
          FirebaseMessaging,
          FirebaseMessaging,
          FirebaseMessaging
        >
    with $Provider<FirebaseMessaging> {
  /// Provides the singleton instance of [FirebaseMessaging].
  ///
  /// This is a low-level provider that exposes the Firebase SDK directly.
  /// Most code should use [firebaseMessagingServiceProvider] instead.
  FirebaseMessagingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firebaseMessagingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firebaseMessagingHash();

  @$internal
  @override
  $ProviderElement<FirebaseMessaging> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FirebaseMessaging create(Ref ref) {
    return firebaseMessaging(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseMessaging value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseMessaging>(value),
    );
  }
}

String _$firebaseMessagingHash() => r'1672e956b9febea725d18574f63c5ce88cefb132';

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

@ProviderFor(remoteLoggingService)
final remoteLoggingServiceProvider = RemoteLoggingServiceProvider._();

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

final class RemoteLoggingServiceProvider
    extends
        $FunctionalProvider<
          RemoteLoggingService,
          RemoteLoggingService,
          RemoteLoggingService
        >
    with $Provider<RemoteLoggingService> {
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
  RemoteLoggingServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'remoteLoggingServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$remoteLoggingServiceHash();

  @$internal
  @override
  $ProviderElement<RemoteLoggingService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RemoteLoggingService create(Ref ref) {
    return remoteLoggingService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RemoteLoggingService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RemoteLoggingService>(value),
    );
  }
}

String _$remoteLoggingServiceHash() =>
    r'830b7157366aca53b00f1a17ddaaf73558baa356';

/// Provides the [AnalyticsService] implementation.
///
/// Use this provider to log analytics events to Firebase Analytics.
///
/// Example:
/// ```dart
/// final AnalyticsService analytics = ref.read(analyticsServiceProvider);
/// await analytics.logEvent('button_clicked', parameters: {'button_id': 'submit'});
/// ```

@ProviderFor(analyticsService)
final analyticsServiceProvider = AnalyticsServiceProvider._();

/// Provides the [AnalyticsService] implementation.
///
/// Use this provider to log analytics events to Firebase Analytics.
///
/// Example:
/// ```dart
/// final AnalyticsService analytics = ref.read(analyticsServiceProvider);
/// await analytics.logEvent('button_clicked', parameters: {'button_id': 'submit'});
/// ```

final class AnalyticsServiceProvider
    extends
        $FunctionalProvider<
          AnalyticsService,
          AnalyticsService,
          AnalyticsService
        >
    with $Provider<AnalyticsService> {
  /// Provides the [AnalyticsService] implementation.
  ///
  /// Use this provider to log analytics events to Firebase Analytics.
  ///
  /// Example:
  /// ```dart
  /// final AnalyticsService analytics = ref.read(analyticsServiceProvider);
  /// await analytics.logEvent('button_clicked', parameters: {'button_id': 'submit'});
  /// ```
  AnalyticsServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'analyticsServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$analyticsServiceHash();

  @$internal
  @override
  $ProviderElement<AnalyticsService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AnalyticsService create(Ref ref) {
    return analyticsService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnalyticsService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnalyticsService>(value),
    );
  }
}

String _$analyticsServiceHash() => r'e4bca556994ef612381ea297dcdaea8e2e4f7f2f';

/// Provides the [FirebaseMessagingService] implementation.
///
/// Use this provider to handle push notifications with Firebase Cloud Messaging.
///
/// Example:
/// ```dart
/// final FirebaseMessagingService messaging = ref.read(firebaseMessagingServiceProvider);
/// final String? token = await messaging.getToken();
/// ```

@ProviderFor(firebaseMessagingService)
final firebaseMessagingServiceProvider = FirebaseMessagingServiceProvider._();

/// Provides the [FirebaseMessagingService] implementation.
///
/// Use this provider to handle push notifications with Firebase Cloud Messaging.
///
/// Example:
/// ```dart
/// final FirebaseMessagingService messaging = ref.read(firebaseMessagingServiceProvider);
/// final String? token = await messaging.getToken();
/// ```

final class FirebaseMessagingServiceProvider
    extends
        $FunctionalProvider<
          FirebaseMessagingService,
          FirebaseMessagingService,
          FirebaseMessagingService
        >
    with $Provider<FirebaseMessagingService> {
  /// Provides the [FirebaseMessagingService] implementation.
  ///
  /// Use this provider to handle push notifications with Firebase Cloud Messaging.
  ///
  /// Example:
  /// ```dart
  /// final FirebaseMessagingService messaging = ref.read(firebaseMessagingServiceProvider);
  /// final String? token = await messaging.getToken();
  /// ```
  FirebaseMessagingServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firebaseMessagingServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firebaseMessagingServiceHash();

  @$internal
  @override
  $ProviderElement<FirebaseMessagingService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FirebaseMessagingService create(Ref ref) {
    return firebaseMessagingService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseMessagingService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseMessagingService>(value),
    );
  }
}

String _$firebaseMessagingServiceHash() =>
    r'07130c4b9345d3c5618e369da3629044f7a9e33f';
