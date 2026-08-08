# Riverpod Providers

All providers use codegen -- never write manual `final myProvider = Provider(...)`.

---

## Rules

- Always use codegen: `@riverpod` or `@Riverpod(keepAlive: true)`
- Provider function signatures use plain `Ref` (not auto-generated types like `DioRef`)
- Use `ref.watch()` in `build()` only -- creates reactive subscription
- Use `ref.read()` in all methods except `build()` -- one-shot read
- Use `ref.listen()` for side-effects (navigation, snackbars, dialogs)
- Run `make gen` after adding or modifying any `@riverpod` provider

---

## Anti-Patterns

### WRONG: Manual provider

```dart
// WRONG -- never write manual providers
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(...);
});

// CORRECT -- always use codegen
@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) { ... }
```

### WRONG: Auto-generated Ref type

```dart
// WRONG -- do not use generated ref types
@Riverpod(keepAlive: true)
Dio dio(DioRef ref) { ... }

// CORRECT -- use plain Ref
@Riverpod(keepAlive: true)
Dio dio(Ref ref) { ... }
```

### WRONG: `ref.watch` outside `build()`

```dart
// WRONG -- ref.watch in a controller method
Future<void> submit() async {
  final AuthRepository repo = ref.watch(authRepositoryProvider); // WRONG
  await repo.signIn(...);
}

// CORRECT -- ref.read in methods
Future<void> submit() async {
  await ref.read(authRepositoryProvider).signIn(...);
}
```

### WRONG: Missing keepAlive on infrastructure

```dart
// WRONG -- Dio will be disposed when no widget watches it
@riverpod
Dio dio(Ref ref) { ... }

// CORRECT -- infrastructure singletons must persist
@Riverpod(keepAlive: true)
Dio dio(Ref ref) { ... }
```

---

## Provider Types

| Type | Annotation | Use Case | Example |
|------|-----------|----------|---------|
| Auto-dispose function | `@riverpod` | Simple computed values, per-screen DI | `homeRemoteDataSource` |
| Singleton function | `@Riverpod(keepAlive: true)` | Dio, SharedPrefs, datasources, repos | `dioProvider`, `authRepository` |
| Auto-dispose Notifier | `@riverpod class X extends _$X` | Form controllers, page state | `SignInController` |
| Singleton Notifier | `@Riverpod(keepAlive: true) class X extends _$X` | Global state (auth, settings) | `AuthStateController` |

### When to Use keepAlive

- **Use `@riverpod` (auto-dispose)** by default. Provider is disposed when no widget watches it.
- **Use `@Riverpod(keepAlive: true)`** for:
  - Infrastructure singletons: Dio, ApiClient, SharedPreferences, FlutterSecureStorage
  - Datasources and repositories (they depend on ApiClient / long-lived deps)
  - Global state that must survive screen navigation (auth state)

---

## DI Wiring Pattern

Datasource and repository providers are defined in a `<feature>_providers.dart` file inside `presentation/controllers/`.

### Key Snippet

```dart
// lib/features/auth/presentation/controllers/auth_providers.dart
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

  final AuthRemoteDataSource dataSource = ref.watch(authRemoteDataSourceProvider);
  final FlutterSecureStorage secureStorage = ref.watch(secureStorageProvider);

  return AuthRepositoryImpl(
    remoteDataSource: dataSource,
    secureStorage: secureStorage,
  );
}
```

- Both providers are `@Riverpod(keepAlive: true)` -- singletons
- `AppConfig.useMock` switches to mock implementation at build time
- Return type is the abstract interface -- consumers don't know the impl
- **Decision rule** — use a separate `<feature>_providers.dart` when ANY of:
  1. 2+ controllers share the same repository
  2. Mock switching is needed (`AppConfig.useMock`)
  3. Multiple external deps (SecureStorage, SharedPrefs, DB)
- Otherwise, inline providers in the controller file with `@riverpod`

See full: `lib/features/auth/presentation/controllers/auth_providers.dart`

---

## Ref Usage Rules (Strict)

### Decision Tree: ref.watch vs ref.read

**In DI provider functions (datasources, repositories) → use `ref.watch`:**

```dart
@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  final AuthRemoteDataSource dataSource = ref.watch(authRemoteDataSourceProvider);  // watch!
  final FlutterSecureStorage storage = ref.watch(secureStorageProvider);  // watch!

  return AuthRepositoryImpl(dataSource: dataSource, secureStorage: storage);
}
```

**Why:** Creates dependency — when datasource recreates, repository recreates too. This ensures proper lifecycle management.

---

**In controller build() for one-shot initialization → use `ref.read`:**

```dart
@riverpod
class HomeController extends _$HomeController {
  @override
  Future<List<Post>> build() async {
    return ref.read(homeRepositoryProvider).getPosts();  // read!
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(homeRepositoryProvider).getPosts(),  // read!
    );
  }
}
```

**Why:** One-shot fetch. Controller doesn't need to rebuild when repository provider changes (provider changes are rare and manual).

---

**In global state controllers checking other state → use `ref.watch`:**

```dart
@Riverpod(keepAlive: true)
class AuthStateController extends _$AuthStateController {
  @override
  Future<AuthState> build() async {
    // Watch if you want to react to changes
    final bool hasNetwork = ref.watch(networkStatusProvider);

    // Read for one-shot initialization
    final String? token = await ref.read(secureStorageProvider).read(key: 'token');

    if (!hasNetwork) {
      return const AuthState.offline();
    }

    if (token == null) {
      return const AuthState.unauthenticated();
    }

    final User user = await ref.read(authRepositoryProvider).getCurrentUser();
    return AuthState.authenticated(user: user);
  }
}
```

**Why:** `ref.watch(networkStatusProvider)` creates subscription — when network status changes, auth state re-evaluates. But repository is one-shot read because we don't rebuild on repository changes.

---

**In widget build() → use `ref.watch` with Consumer + .select():**

```dart
class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Page build() NEVER calls ref.watch directly
    return Scaffold(
      body: Consumer(
        builder: (context, ref, child) {
          final AsyncValue<List<Post>> postsAsync = ref.watch(homeControllerProvider);  // watch!
          return postsAsync.when(...);
        },
      ),
    );
  }
}
```

**Why:** `ref.watch` creates subscription — widget rebuilds when controller state changes. Always wrap in `Consumer` for selective rebuilds.

---

**In all other methods (callbacks, event handlers) → use `ref.read`:**

```dart
Future<void> submit() async {
  await ref.read(authRepositoryProvider).signIn(...);  // read!
}

void _onTap() {
  ref.read(homeControllerProvider.notifier).refresh();  // read!
}
```

**Why:** One-shot access. No need to subscribe to changes in event handlers.

---

### Summary Table

| Context | Use | Reason |
|---------|-----|--------|
| **DI provider function** (`authRepository`, `dio`, etc.) | `ref.watch` | Create dependency — provider recreates when deps change |
| **Controller build()** (one-shot fetch) | `ref.read` | No need to rebuild on provider changes |
| **Global state controller build()** (reacting to state) | `ref.watch` | React to changes in other state providers |
| **Widget build()** (in Consumer) | `ref.watch` | React to state changes |
| **Controller methods** (`submit`, `refresh`, etc.) | `ref.read` | One-shot access, no subscription needed |
| **Callbacks / event handlers** | `ref.read` | One-shot access |

### `ref.listen()` -- side-effect reactions

- Use for navigation, snackbars, dialogs
- Place at the top of widget `build()` before the widget tree
- Use with `.select()` to listen to specific state fields

```dart
// In app_router.dart
ref.listen(authStateControllerProvider, (_, AsyncValue<AuthState> next) {
  next.whenData((AuthState state) {
    isAuthenticated.value = state.isAuthenticated;
  });
});
```

---

## State Management with Freezed

Controller state is defined as a Freezed class in the same file as the controller:

```dart
@freezed
abstract class SignInState with _$SignInState {
  const factory SignInState({
    @Default('') String email,
    @Default('') String password,
    @Default(false) bool isLoading,
    Exception? error,
    String? emailError,
    String? passwordError,
  }) = _SignInState;
}
```

- State class is in the same file as the controller
- Use `@Default(...)` for initial values
- Use `copyWith` for immutable updates: `state = state.copyWith(isLoading: true)`
- Nullable fields (`String?`) default to `null` -- no `@Default` needed

---

## AsyncValue Pattern

For controllers that load async data:

```dart
@riverpod
class HomeController extends _$HomeController {
  @override
  Future<List<Post>> build() async {
    return ref.read(homeRepositoryProvider).getPosts();
  }
}
```

The generated state type is `AsyncValue<List<Post>>` with three states: `AsyncLoading`, `AsyncData(value)`, `AsyncError(error, stackTrace)`.

### Updating AsyncValue State

```dart
Future<void> refresh() async {
  state = const AsyncLoading<List<Post>>();
  try {
    final List<Post> posts = await ref.read(homeRepositoryProvider).getPosts();
    state = AsyncData<List<Post>>(posts);
  } on Exception catch (e, st) {
    state = AsyncError<List<Post>>(e, st);
  }
}
```

---

## Provider Naming Convention

Generated provider names follow the pattern `<functionOrClassName>Provider`:
- Function `dio(Ref ref)` -> `dioProvider`
- Function `authRepository(Ref ref)` -> `authRepositoryProvider`
- Class `SignInController` -> `signInControllerProvider`

Notifier access: `ref.read(signInControllerProvider.notifier).submit()`

---

## Cross-References

- [Controllers](../presentation/controllers.md) -- Controller patterns using providers
- [Pages & Widgets](../presentation/pages-and-widgets.md) -- Selective rebuilds with Consumer+select()
- [Repository Pattern](../data-layer/repository-pattern.md) -- Entities and repos wired by providers
- [Code Style](../conventions/code-style.md) -- Selective rebuild rules
