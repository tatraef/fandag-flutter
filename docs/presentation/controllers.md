# Controllers

Three controller patterns used in this project: form controller, async list controller, and global state controller.

---

## Rules

- Use `@riverpod` (auto-dispose) unless state must survive navigation
- Use `@Riverpod(keepAlive: true)` for global state (auth, settings)
- Use `ref.read()` in all methods except `build()`
- State class and controller in the same file
- Import repository via controllers barrel (which re-exports providers)
- Always run `make gen` after creating a new controller

---

## Controller Method Ordering (Strict)

All methods in a controller class must follow this exact order:

1. **`build()` method** — FIRST (this is the controller's initializer, analogous to constructor)
2. **Setter methods** (`setX`, `updateX`, etc.) — alphabetically by name
3. **Action methods** (`submit`, `refresh`, `delete`, etc.) — alphabetically by name
4. **Private helper methods** — alphabetically by name

**Example:**

```dart
@riverpod
class SignInController extends _$SignInController {
  // 1. build() FIRST
  @override
  SignInState build() => const SignInState();

  // 2. Setters (alphabetically)
  void setEmail(String value, {required bool isValid}) {
    state = state.copyWith(email: value, isEmailValid: isValid, error: null);
  }

  void setPassword(String value, {required bool isValid}) {
    state = state.copyWith(password: value, isPasswordValid: isValid, error: null);
  }

  // 3. Actions (alphabetically)
  Future<void> submit() async {
    if (!_validateForm()) {
      return;
    }
    state = state.copyWith(isLoading: true, error: null);
    try {
      await ref.read(authRepositoryProvider).signIn(
        email: state.email,
        password: state.password,
      );
    } on Exception catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  // 4. Private methods (alphabetically)
  bool _validateForm() {
    return state.isEmailValid && state.isPasswordValid;
  }
}
```

**Alphabetical ordering examples:**

```dart
// ✅ CORRECT -- setters alphabetically
void setEmail(...) { ... }      // 'e' comes before 'p'
void setPassword(...) { ... }   // 'p' comes after 'e'

// ✅ CORRECT -- actions alphabetically
Future<void> delete() async { ... }     // 'd' first
Future<void> refresh() async { ... }    // 'r' second
Future<void> submit() async { ... }     // 's' last

// ❌ WRONG -- not alphabetically sorted
void setPassword(...) { ... }   // Should be second!
void setEmail(...) { ... }      // Should be first!
```

---

## Decision Tree

```
Does the screen have a form with validation?
├── YES → Pattern 1 (Form Controller)
Does the screen display a list loaded from an API?
├── YES → Pattern 2 (Async List Controller)
Is it app-wide state that survives navigation?
├── YES → Pattern 3 (Global State Controller)
Is it a detail screen with a single loaded entity?
└── YES → Pattern 2 (variant: Future<Entity> instead of Future<List<Entity>>)
```

---

## Anti-Patterns

### WRONG: `ref.watch` in methods

```dart
// WRONG -- ref.watch creates subscription, only for build()
Future<void> submit() async {
  await ref.watch(authRepositoryProvider).signIn(...); // WRONG
}

// CORRECT -- ref.read for one-shot access
Future<void> submit() async {
  await ref.read(authRepositoryProvider).signIn(...);
}
```

### WRONG: Missing validation guard

```dart
// WRONG -- submits without checking validity flags
Future<void> submit() async {
  state = state.copyWith(isLoading: true);
  await ref.read(authRepositoryProvider).signIn(...);
}

// CORRECT -- check all validity flags first
Future<void> submit() async {
  if (!state.isEmailValid || !state.isPasswordValid) {
    return;
  }
  state = state.copyWith(isLoading: true, error: null);
  // ...
}
```

### WRONG: Not resetting `isLoading` on error

```dart
// WRONG -- loading spinner stays forever on error
on Exception catch (e) {
  state = state.copyWith(error: e); // isLoading still true!
}

// CORRECT -- reset isLoading on error
on Exception catch (e) {
  state = state.copyWith(isLoading: false, error: e);
}
```

### WRONG: Manual provider instead of codegen

```dart
// WRONG -- manual provider
final signInControllerProvider = StateNotifierProvider<SignInController, SignInState>(...);

// CORRECT -- codegen
@riverpod
class SignInController extends _$SignInController { ... }
```

### WRONG: Storing error messages instead of validation flags

```dart
// WRONG -- storing localized error messages in state
@freezed
abstract class SignInState with _$SignInState {
  const factory SignInState({
    String? emailError,  // WRONG -- localized UI strings in state
    String? passwordError,  // WRONG
  }) = _SignInState;
}

void setEmail(String value) {
  if (!_isValidEmail(value)) {
    state = state.copyWith(emailError: 'Invalid email');  // WRONG
  }
}

// CORRECT -- storing validation flags, localization in page
@freezed
abstract class SignInState with _$SignInState {
  const factory SignInState({
    @Default(false) bool isEmailValid,  // CORRECT -- bool flag
    @Default(false) bool isPasswordValid,  // CORRECT
  }) = _SignInState;
}

void setEmail(String value, {required bool isValid}) {
  state = state.copyWith(email: value, isEmailValid: isValid, error: null);
}
```

**Why:** Controllers should not contain localized strings. Validation happens in TextField widgets (which have access to `context.t`), and controllers only store the validation result as a boolean flag. See [Form TextField Widgets](pages-and-widgets.md#form-textfield-widgets).

---

## Pattern 1: Form Controller

For screens with form input, validation, and submission.

### Structure

1. **State class** -- Freezed, co-located in same file
   - Form field values (`String email`, `String password`, `String name`)
   - Per-field validity flags (`bool isEmailValid`, `bool isPasswordValid`) with `@Default(false)`
   - `bool isLoading` with `@Default(false)`
   - Optional `bool isSuccess` for success indication (e.g., password recovery)
   - General error (`Exception? error`) -- typed exception from repository, **localized in page via feature-specific extensions** (e.g., `context.localizedSignInError(error)`)

2. **`build()`** -- returns `const` initial state (empty form, all validity flags `false`)

3. **Setter methods** -- one per field, receive `{required bool isValid}` from TextField widget:
   ```dart
   void setField(String value, {required bool isValid}) {
     state = state.copyWith(field: value, isFieldValid: isValid, error: null);
   }
   ```

4. **`submit()`** -- check all validity flags → set loading → call repository → update global state or set error

**IMPORTANT:** Validation logic lives in specialized TextField widgets (`EmailTextField`, `PasswordTextField`, etc.), NOT in controllers. Widgets pass validation results to controllers via `isValid` parameter. See [Form TextField Widgets](pages-and-widgets.md#form-textfield-widgets).

### Key Snippet

```dart
// lib/features/auth/presentation/controllers/sign_in_controller.dart
@freezed
abstract class SignInState with _$SignInState {
  const factory SignInState({
    @Default('') String email,
    @Default('') String password,
    @Default(false) bool isEmailValid,
    @Default(false) bool isPasswordValid,
    @Default(false) bool isLoading,
    Exception? error,  // ← Localized in page via context.localizedSignInError()
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
      await ref.read(authRepositoryProvider).signIn(
        email: state.email, password: state.password,
      );
      await ref.read(authStateControllerProvider.notifier).onSignedIn();
    } on Exception catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }
}
```

See full: `lib/features/auth/presentation/controllers/sign_in_controller.dart`

### Error Localization

Controllers store typed exceptions (`Exception? error`), NOT localized strings. Pages localize errors via **feature-specific extensions** on `BuildContext`:

```dart
// lib/features/auth/presentation/extensions/auth_error_ext.dart
extension AuthErrorsExt on BuildContext {
  String localizedSignInError(Exception error) {
    return switch (error) {
      UnauthorizedException() => t.auth.errors.invalidCredentials,
      BadRequestException() => t.auth.errors.invalidInput,
      NetworkException() => t.common.errors.network,
      _ => localizedErrorMessage(error), // Fallback to global
    };
  }
}

// In page:
Consumer(
  builder: (BuildContext context, WidgetRef ref, Widget? child) {
    final Exception? error = ref.watch(
      signInControllerProvider.select((SignInState s) => s.error),
    );
    if (error == null) return const SizedBox.shrink();

    return Text(
      context.localizedSignInError(error),  // ← Feature-specific localization
      style: TextStyle(color: context.theme.colorScheme.error),
    );
  },
)
```

**Why feature-specific?** Different screens interpret the same error differently:
- 401 on sign in → "Invalid credentials"
- 401 on authenticated request → "Session expired"

See full: `lib/features/auth/presentation/extensions/auth_error_ext.dart`

---

## Pattern 2: Async List Controller

For screens that display a list loaded from an API with CRUD operations.

### Structure

1. **`build()`** -- returns `Future<List<Entity>>`, auto-becomes `AsyncValue`
2. **`refresh()`** -- set `AsyncLoading`, fetch, set `AsyncData` or `AsyncError`
3. **CRUD methods** -- call repository, then `await refresh()` to reload list
4. **Error handling** -- catch `Exception`, set `AsyncError<T>(e, st)`
5. **DI providers** can be co-located in the same file for simpler features

### Key Snippet

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
      final List<Post> posts = await ref.read(homeRepositoryProvider).getPosts();
      state = AsyncData<List<Post>>(posts);
    } on Exception catch (e, st) {
      state = AsyncError<List<Post>>(e, st);
    }
  }
}
```

### UI Consumption

```dart
final AsyncValue<List<Post>> postsAsync = ref.watch(homeControllerProvider);

postsAsync.when(
  loading: () => const Center(child: CircularProgressIndicator()),
  error: (Object error, StackTrace stackTrace) => /* error widget */,
  data: (List<Post> posts) => /* list widget */,
);
```

See full: `lib/features/home/presentation/controllers/home_controller.dart`

---

## Pattern 3: Global State Controller

For app-wide state that must survive screen navigation (auth, theme, settings).

### Structure

1. **`@Riverpod(keepAlive: true)`** -- NOT auto-disposed, persists across navigation
2. **`build()`** -- returns `Future<State>`, checks initial state on app start (e.g., stored token)
3. **State transitions** -- explicit `state = AsyncData<T>(...)` assignments
4. **Referenced by router** -- `ref.listen(authStateControllerProvider, ...)` in GoRouter
5. **Called from other controllers** -- e.g., `ref.read(authStateControllerProvider.notifier).onSignedIn()`

### Key Snippet

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

See full: `lib/features/auth/presentation/controllers/auth_state_controller.dart`

---

## Cross-References

- [Pages & Widgets](pages-and-widgets.md) -- How pages consume controllers
- [Riverpod Providers](../architecture/riverpod-providers.md) -- Provider types and DI wiring
- [Error Handling](../architecture/error-handling.md) -- Error flow through controllers
