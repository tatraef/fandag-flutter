# Mock Repository Patterns

Mock repositories for standalone development and demo mode without a backend.

---

## When to Create Mocks

Create a mock repository when a feature needs:

- **Standalone development** -- work on UI without a running backend
- **Demo mode** -- showcase the app with realistic data
- **Testing** -- predictable data for widget/integration tests

---

## Mock Repository Structure

A mock repository implements the domain interface directly, returning hardcoded data after simulated delays:

```dart
import 'dart:async';

import 'package:flutter_template_v3/features/<feature>/domain/domain.dart';

class MockFeatureRepository implements FeatureRepository {
  static const Duration _simulatedDelay = Duration(milliseconds: 500);

  @override
  Future<List<Item>> getItems() async {
    await Future<void>.delayed(_simulatedDelay);

    return const <Item>[
      Item(id: '1', title: 'Mock Item 1'),
      Item(id: '2', title: 'Mock Item 2'),
    ];
  }

  @override
  Future<void> createItem({required String title}) async {
    await Future<void>.delayed(_simulatedDelay);
    // No-op for mock
  }
}
```

### Key Rules

1. **Implements domain interface** -- `implements FeatureRepository`, not `extends`
2. **Simulated delay** -- `Future.delayed(Duration(milliseconds: 500))` for realistic UX
3. **Hardcoded response data** -- realistic but static values
4. **Lives in data layer** -- `lib/features/<feature>/data/repositories/mock_<feature>_repository.dart`
5. **Added to sub-barrel** -- export from `repositories/repositories.dart`

---

## Real Example: MockAuthRepository

From `lib/features/auth/data/repositories/mock_auth_repository.dart`:

```dart
class MockAuthRepository implements AuthRepository {
  static const Duration _simulatedDelay = Duration(milliseconds: 500);

  final StreamController<bool> _authStateController =
      StreamController<bool>.broadcast();

  User? _currentUser;

  @override
  Future<AuthTokens> signIn({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(_simulatedDelay);

    _currentUser = User(
      id: 'mock-user-id',
      email: email,
      name: email.split('@').first,
    );
    _authStateController.add(true);

    return const AuthTokens(
      accessToken: 'mock-access-token',
      refreshToken: 'mock-refresh-token',
    );
  }

  @override
  Future<void> signOut() async {
    await Future<void>.delayed(_simulatedDelay);

    _currentUser = null;
    _authStateController.add(false);
  }

  @override
  Stream<bool> getAuthState() => _authStateController.stream;
}
```

---

## AppConfig.useMock Switching

The `AppConfig.useMock` flag switches between real and mock implementations in the DI provider:

```dart
// In <feature>_providers.dart
@Riverpod(keepAlive: true)
FeatureRepository featureRepository(Ref ref) {
  if (AppConfig.useMock) {
    return MockFeatureRepository();
  }

  final FeatureRemoteDataSource dataSource = ref.watch(
    featureRemoteDataSourceProvider,
  );

  return FeatureRepositoryImpl(remoteDataSource: dataSource);
}
```

Run in mock mode:
```bash
make run-mock
# or: flutter run --dart-define=USE_MOCK=true
```

---

## File Placement

```
features/<feature>/
  data/
    repositories/
      repositories.dart              # Sub-barrel (add mock export)
      <feature>_repository_impl.dart # Real implementation
      mock_<feature>_repository.dart # Mock implementation
```

---

## Anti-Patterns

### WRONG: Mock in production code path

```dart
// WRONG -- mock should only be reached via AppConfig.useMock
@Riverpod(keepAlive: true)
FeatureRepository featureRepository(Ref ref) {
  return MockFeatureRepository(); // Always returns mock!
}
```

### WRONG: Forgetting to update mock when interface changes

When the domain interface adds a new method, the mock must also implement it. The compiler will catch this since the mock `implements` the interface.

### WRONG: No simulated delay

```dart
// WRONG -- instant responses don't reflect real UX
@override
Future<List<Item>> getItems() async {
  return <Item>[...]; // No delay
}

// CORRECT -- simulate network latency
@override
Future<List<Item>> getItems() async {
  await Future<void>.delayed(_simulatedDelay);

  return <Item>[...];
}
```

### WRONG: Mock throws real exceptions

```dart
// WRONG -- mocks should return data, not throw
@override
Future<User> getUser() async {
  throw const ServerException();
}

// CORRECT -- return hardcoded success data
// (For error testing, create a separate MockErrorFeatureRepository)
```

---

## References

- `lib/features/auth/data/repositories/mock_auth_repository.dart` -- Canonical mock example
- `lib/core/environment/app_config.dart` -- `AppConfig.useMock` flag
- `lib/features/auth/presentation/controllers/auth_providers.dart` -- Mock switching in provider
- `docs/app-setup.md` -- Environment configuration
