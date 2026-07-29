---
name: provider-patterns
description: Riverpod DI wiring patterns with @Riverpod(keepAlive true) for datasources and repositories. Auto-loads when creating providers or discussing dependency injection.
user-invocable: false
---

# Provider Patterns (DI Wiring)

Providers wire up **datasources → repositories** using Riverpod codegen. They live in `presentation/controllers/<feature>_providers.dart`.

## Canonical Template

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fandag/core/network/network.dart';
import 'package:fandag/features/<feature>/data/data.dart';
import 'package:fandag/features/<feature>/domain/domain.dart';

part '<feature>_providers.g.dart';

@Riverpod(keepAlive: true)
FeatureRemoteDataSource featureRemoteDataSource(Ref ref) {
  final ApiClient apiClient = ref.watch(apiClientProvider);

  return FeatureRemoteDataSource(apiClient: apiClient);
}

@Riverpod(keepAlive: true)
FeatureRepository featureRepository(Ref ref) {
  final FeatureRemoteDataSource dataSource = ref.watch(
    featureRemoteDataSourceProvider,
  );

  return FeatureRepositoryImpl(remoteDataSource: dataSource);
}
```

## Rules

1. **`@Riverpod(keepAlive: true)`** for separate provider files — infrastructure providers are singletons
2. **`@riverpod`** is acceptable when providers live inline in a controller file (auto-dispose is fine because the controller re-creates them as needed)
3. **Function signature uses `Ref`** — not auto-generated types like `FeatureRemoteDataSourceRef`
4. **One providers file per feature** — `<feature>_providers.dart` (or inline in controller file for simple features)
5. **`part '<feature>_providers.g.dart'`** — codegen
6. **`ref.watch()`** in provider functions — to observe upstream providers
7. **Explicit types** on all variables

## Real Example — Auth Providers

```dart
// lib/features/auth/presentation/controllers/auth_providers.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fandag/core/core.dart';
import 'package:fandag/features/auth/data/data.dart';
import 'package:fandag/features/auth/domain/domain.dart';

part 'auth_providers.g.dart';

@Riverpod(keepAlive: true)
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  final ApiClient apiClient = ref.watch(apiClientProvider);

  return AuthRemoteDataSource(apiClient: apiClient);
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  if (AppConfig.useMock) {
    return AuthRepositoryMock();
  }

  final AuthRemoteDataSource dataSource = ref.watch(
    authRemoteDataSourceProvider,
  );
  final FlutterSecureStorage secureStorage = ref.watch(secureStorageProvider);

  return AuthRepositoryImpl(
    remoteDataSource: dataSource,
    secureStorage: secureStorage,
  );
}
```

## Real Example — Home Providers (inline in controller file)

For simple features (one controller, no mock switching), providers can live directly in the controller file using `@riverpod`:

```dart
// lib/features/home/presentation/controllers/home_controller.dart
@riverpod
HomeRemoteDataSource homeRemoteDataSource(Ref ref) {
  final ApiClient apiClient = ref.watch(apiClientProvider);

  return HomeRemoteDataSource(apiClient: apiClient);
}

@riverpod
HomeRepository homeRepository(Ref ref) {
  final HomeRemoteDataSource dataSource = ref.watch(
    homeRemoteDataSourceProvider,
  );

  return HomeRepositoryImpl(remoteDataSource: dataSource);
}
```

## When to Use Separate File vs Inline

Use a **separate** `<feature>_providers.dart` + `@Riverpod(keepAlive: true)` when **ANY** of:

1. **2+ controllers** share the same repository
2. **Mock switching** is needed (`AppConfig.useMock`)
3. **Multiple external deps** (SecureStorage, SharedPrefs, DB)

Otherwise → **inline** in controller file + `@riverpod` (auto-dispose)

| Criteria | Separate `<feature>_providers.dart` | Inline in controller file |
|---|---|---|
| 2+ controllers share the same repository | Yes | No |
| Mock switching (`AppConfig.useMock`) | Yes | No |
| Multiple external deps (SecureStorage, SharedPrefs, DB) | Yes | No |
| None of the above | No | Yes |

- **Separate file** → use `@Riverpod(keepAlive: true)` (singletons)
- **Inline** → `@riverpod` (auto-dispose) is acceptable — providers are re-created with controller

## Mock Switching

Use `AppConfig.useMock` to switch between real and mock implementations:

```dart
@Riverpod(keepAlive: true)
FeatureRepository featureRepository(Ref ref) {
  if (AppConfig.useMock) {
    return FeatureRepositoryMock();
  }

  final FeatureRemoteDataSource dataSource = ref.watch(
    featureRemoteDataSourceProvider,
  );

  return FeatureRepositoryImpl(remoteDataSource: dataSource);
}
```

## Provider Chain

```
dioProvider (core)
    ↓ ref.watch
apiClientProvider (core)
    ↓ ref.watch
featureRemoteDataSourceProvider
    ↓ ref.watch
featureRepositoryProvider
    ↓ ref.read (in controllers)
featureControllerProvider
```

## Barrel File

Add providers file to the sub-barrel `controllers/controllers.dart`:

```dart
// presentation/controllers/controllers.dart
export 'feature_providers.dart';
export 'feature_controller.dart';
```

## Anti-Patterns

```dart
// BAD: manual providers
final featureRepositoryProvider = Provider<FeatureRepository>((ref) {
  // WRONG — always use @riverpod or @Riverpod(keepAlive: true) codegen
});

// BAD: auto-generated ref types
@Riverpod(keepAlive: true)
FeatureRemoteDataSource featureRemoteDataSource(FeatureRemoteDataSourceRef ref) {
  // WRONG — use Ref, not auto-generated type
}

// BAD: auto-dispose in a separate providers file
// When providers live in a dedicated <feature>_providers.dart file,
// they should be singletons to avoid re-creation:
@riverpod  // WRONG in a separate providers file — use keepAlive
FeatureRemoteDataSource featureRemoteDataSource(Ref ref) { ... }
// CORRECT: @Riverpod(keepAlive: true)
// NOTE: @riverpod is acceptable when providers are inline in a controller file

// BAD: missing part directive
// Must have: part '<feature>_providers.g.dart';

// BAD: ref.read in provider functions
@Riverpod(keepAlive: true)
FeatureRepository featureRepository(Ref ref) {
  final dataSource = ref.read(featureRemoteDataSourceProvider);
  // WRONG — use ref.watch in provider functions
}
```
