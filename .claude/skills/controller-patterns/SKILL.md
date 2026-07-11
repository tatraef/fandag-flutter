---
name: controller-patterns
description: Riverpod controller patterns (form, async list, global state). Auto-loads when creating controllers, state management, or discussing presentation layer logic.
user-invocable: false
---

# Controller Patterns

Controllers manage **presentation logic** using Riverpod codegen. Choose the pattern based on use case.

## Decision Tree

```
What does this controller manage?
├── Form with validation → Pattern 1 (Form Controller)
├── List/data from API  → Pattern 2 (Async List Controller)
└── Global app state    → Pattern 3 (Global State Controller)
```

---

## Pattern 1 — Form Controller

For forms with validation, loading state, and submission.

**IMPORTANT**: Validation happens **in TextField widgets**, NOT in controllers. Controllers receive `isValid` flags from widget callbacks and store field values + validity state.

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_template_v3/features/<feature>/presentation/controllers/controllers.dart';

part '<name>_controller.freezed.dart';
part '<name>_controller.g.dart';

@freezed
abstract class XState with _$XState {
  const factory XState({
    @Default('') String field1,
    @Default('') String field2,
    @Default(false) bool isField1Valid,  // Validity flag from widget
    @Default(false) bool isField2Valid,  // Validity flag from widget
    @Default(false) bool isLoading,
    Exception? error,
  }) = _XState;
}

@riverpod
class XController extends _$XController {
  @override
  XState build() => const XState();

  void setField1(String value, {required bool isValid}) {
    state = state.copyWith(field1: value, isField1Valid: isValid, error: null);
  }

  void setField2(String value, {required bool isValid}) {
    state = state.copyWith(field2: value, isField2Valid: isValid, error: null);
  }

  Future<void> submit() async {
    if (!state.isField1Valid || !state.isField2Valid) {
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      await ref.read(featureRepositoryProvider).doSomething(
        field1: state.field1,
        field2: state.field2,
      );
    } on Exception catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }
}
```

### Real Example — SignInController

```dart
// lib/features/auth/presentation/controllers/sign_in_controller.dart
@freezed
abstract class SignInState with _$SignInState {
  const factory SignInState({
    @Default('') String email,
    @Default('') String password,
    @Default(false) bool isEmailValid,     // Validity flag from EmailTextField
    @Default(false) bool isPasswordValid,  // Validity flag from PasswordTextField
    @Default(false) bool isLoading,
    Exception? error,
  }) = _SignInState;
}

@riverpod
class SignInController extends _$SignInController {
  @override
  SignInState build() => const SignInState();

  void setEmail(String value, {required bool isValid}) {
    state = state.copyWith(email: value, isEmailValid: isValid, error: null);
  }

  void setPassword(String value, {required bool isValid}) {
    state = state.copyWith(password: value, isPasswordValid: isValid, error: null);
  }

  Future<void> submit() async {
    if (!state.isEmailValid || !state.isPasswordValid) {
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      await ref
          .read(authRepositoryProvider)
          .signIn(email: state.email, password: state.password);
      await ref.read(authStateControllerProvider.notifier).onSignedIn();
    } on Exception catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }
}

// Page usage:
EmailTextField(
  controller: _emailController,
  onChanged: ref.read(signInControllerProvider.notifier).setEmail,
  // Widget calls setEmail(text, isValid: true/false)
),
```

---

## Pattern 2 — Async List Controller

For data fetched from API with loading/error/data states.

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_template_v3/features/<feature>/domain/domain.dart';
import 'package:flutter_template_v3/features/<feature>/presentation/controllers/controllers.dart';

part '<name>_controller.g.dart';

@riverpod
class XController extends _$XController {
  @override
  Future<List<Entity>> build() async {
    return ref.read(featureRepositoryProvider).getEntities();
  }

  Future<void> refresh() async {
    state = const AsyncLoading<List<Entity>>();

    try {
      final List<Entity> items = await ref
          .read(featureRepositoryProvider)
          .getEntities();
      state = AsyncData<List<Entity>>(items);
    } on Exception catch (e, st) {
      state = AsyncError<List<Entity>>(e, st);
    }
  }

  Future<void> deleteItem(String id) async {
    try {
      await ref.read(featureRepositoryProvider).deleteEntity(id);
      await refresh();
    } on Exception catch (e, st) {
      state = AsyncError<List<Entity>>(e, st);
    }
  }
}
```

### Real Example — HomeController

```dart
// lib/features/home/presentation/controllers/home_controller.dart
@riverpod
class HomeController extends _$HomeController {
  @override
  Future<List<Post>> build() async {
    return ref.read(homeRepositoryProvider).getPosts();
  }

  Future<void> refresh() async {
    state = const AsyncLoading<List<Post>>();

    try {
      final List<Post> posts = await ref
          .read(homeRepositoryProvider)
          .getPosts();
      state = AsyncData<List<Post>>(posts);
    } on Exception catch (e, st) {
      state = AsyncError<List<Post>>(e, st);
    }
  }

  Future<void> createPost({required String title, required String body}) async {
    try {
      await ref
          .read(homeRepositoryProvider)
          .createPost(title: title, body: body);
      await refresh();
    } on Exception catch (e, st) {
      state = AsyncError<List<Post>>(e, st);
    }
  }

  Future<void> deletePost(String id) async {
    try {
      await ref.read(homeRepositoryProvider).deletePost(id);
      await refresh();
    } on Exception catch (e, st) {
      state = AsyncError<List<Post>>(e, st);
    }
  }
}
```

---

## Pattern 3 — Global State Controller

For app-wide state that persists across navigation (auth, settings, theme).

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_template_v3/features/<feature>/presentation/controllers/controllers.dart';

part '<name>_controller.freezed.dart';
part '<name>_controller.g.dart';

@freezed
abstract class XState with _$XState {
  const factory XState({
    Entity? entity,
    @Default(false) bool isActive,
  }) = _XState;
}

@Riverpod(keepAlive: true)
class XStateController extends _$XStateController {
  @override
  Future<XState> build() async {
    // Check initial state (e.g., stored tokens)
    return const XState();
  }

  Future<void> onActivated() async {
    try {
      final Entity entity = await ref.read(featureRepositoryProvider).getEntity();
      state = AsyncData<XState>(XState(entity: entity, isActive: true));
    } on Exception catch (e, st) {
      state = AsyncError<XState>(e, st);
    }
  }

  Future<void> onDeactivated() async {
    state = const AsyncData<XState>(XState());
  }
}
```

### Real Example — AuthStateController

```dart
// lib/features/auth/presentation/controllers/auth_state_controller.dart
@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({User? user, @Default(false) bool isAuthenticated}) =
      _AuthState;
}

@Riverpod(keepAlive: true)
class AuthStateController extends _$AuthStateController {
  @override
  Future<AuthState> build() async {
    final bool hasToken = await _checkStoredToken();

    if (hasToken) {
      try {
        final User user = await ref
            .read(authRepositoryProvider)
            .getCurrentUser();

        return AuthState(user: user, isAuthenticated: true);
      } on Exception {
        return const AuthState();
      }
    }

    return const AuthState();
  }

  Future<void> onSignedIn() async {
    try {
      final User user = await ref.read(authRepositoryProvider).getCurrentUser();
      state = AsyncData<AuthState>(
        AuthState(user: user, isAuthenticated: true),
      );
    } on Exception catch (e, st) {
      state = AsyncError<AuthState>(e, st);
    }
  }

  Future<void> onSignedOut() async {
    await ref.read(authRepositoryProvider).signOut();
    state = const AsyncData<AuthState>(AuthState());
  }

  Future<bool> _checkStoredToken() async {
    final String? token = await ref
        .read(secureStorageProvider)
        .read(key: 'access_token');

    return token != null;
  }
}
```

---

## Where Do Providers Live?

Controllers need DI providers (datasource, repository). Two options:

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

**Simple feature (like home)** — providers live in the same file as the controller:
```dart
// home_controller.dart — providers + controller in one file
@riverpod
HomeRemoteDataSource homeRemoteDataSource(Ref ref) { ... }

@riverpod
HomeRepository homeRepository(Ref ref) { ... }

@riverpod
class HomeController extends _$HomeController { ... }
```

**Complex feature (like auth)** — separate `auth_providers.dart` file, controllers import via barrel:
```dart
// sign_in_controller.dart
import 'package:flutter_template_v3/features/auth/presentation/controllers/controllers.dart';
// ↑ accesses authRepositoryProvider via controllers barrel
```

See `provider-patterns` skill for detailed provider templates.

## Controller Rules

1. **`@riverpod`** (auto-dispose) by default
2. **`@Riverpod(keepAlive: true)`** only for global state (auth, settings)
3. **`ref.read()`** in all methods — never `ref.watch()` outside `build()`
4. **`ref.watch()`** only in `build()` method
5. **State class in same file** as controller
6. **Validate before submit** — return early if invalid
7. **Reset `isLoading` on error** — don't leave UI stuck in loading
8. **Named constants** for magic numbers (`_minPasswordLength`)
9. **Explicit types** on `AsyncData`, `AsyncError`, `AsyncLoading`

## Anti-Patterns

```dart
// BAD: ref.watch in methods — causes rebuild loops
Future<void> submit() async {
  await ref.watch(repositoryProvider).doSomething();  // WRONG — use ref.read
}

// BAD: missing validation guard
Future<void> submit() async {
  state = state.copyWith(isLoading: true);  // Sets loading before validation!
  if (!_validate()) return;  // Too late — UI already shows loading
  // ...
}

// BAD: not resetting isLoading on error
} on Exception catch (e) {
  state = state.copyWith(error: e);
  // MISSING: isLoading: false — UI stays loading forever
}

// BAD: manual providers
final signInControllerProvider = StateNotifierProvider<...>(...);
// WRONG — always use @riverpod codegen

// BAD: auto-generated ref types
@riverpod
XRemoteDataSource xRemoteDataSource(XRemoteDataSourceRef ref) {
  // WRONG — use Ref, not auto-generated type
}
```
