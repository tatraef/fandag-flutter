# Navigation Patterns

GoRouter navigation with type-safe routes, auth guards, and Riverpod integration.

---

## AppRoute Enum

All routes are defined as enum values with associated paths in `lib/core/router/app_route.dart`:

```dart
enum AppRoute {
  signIn('/sign-in'),
  signUp('/sign-up'),
  passwordRecovery('/password-recovery'),
  home('/home');

  const AppRoute(this.path);

  final String path;
}
```

### Adding a New Route

1. Add enum value with path:
```dart
enum AppRoute {
  // ... existing routes
  profile('/profile'),  // New route
}
```

2. Add `GoRoute` in `app_router.dart`:
```dart
GoRoute(
  path: AppRoute.profile.path,
  builder: (BuildContext context, GoRouterState state) =>
      const ProfilePage(),
),
```

3. Import the page via feature presentation barrel.

---

## Router Setup

The router is a Riverpod provider in `lib/core/router/app_router.dart`:

```dart
@riverpod
GoRouter appRouter(Ref ref) {
  final ValueNotifier<bool> isAuthenticated = ValueNotifier<bool>(false);

  ref.listen(authStateControllerProvider, (_, AsyncValue<AuthState> next) {
    next.whenData((AuthState state) {
      isAuthenticated.value = state.isAuthenticated;
    });
  });

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoute.signIn.path,
    refreshListenable: isAuthenticated,
    redirect: (BuildContext context, GoRouterState state) {
      final bool isAuth = isAuthenticated.value;
      final bool isAuthRoute =
          state.matchedLocation == AppRoute.signIn.path ||
          state.matchedLocation == AppRoute.signUp.path ||
          state.matchedLocation == AppRoute.passwordRecovery.path;

      if (!isAuth && !isAuthRoute) {
        return AppRoute.signIn.path;
      }

      if (isAuth && isAuthRoute) {
        return AppRoute.home.path;
      }

      return null;
    },
    routes: <RouteBase>[
      // GoRoute definitions here
    ],
  );
}
```

### Auth Redirect Logic

- `ValueNotifier<bool>` bridges Riverpod state to GoRouter's `refreshListenable`
- `ref.listen` on `authStateControllerProvider` updates the notifier
- `redirect` callback checks auth state on every navigation:
  - Unauthenticated user on protected route -> redirect to sign-in
  - Authenticated user on auth route -> redirect to home
  - Otherwise -> `null` (no redirect)

---

## Navigation in Widgets

### `context.go()` -- full replacement

Replaces the entire navigation stack. Use for top-level navigation:

```dart
context.go(AppRoute.home.path);
```

### `context.push()` -- stack push

Pushes onto the navigation stack. Use for detail screens:

```dart
context.push(AppRoute.profile.path);
```

### Required imports

```dart
import 'package:flutter_template_v3/core/router/router.dart'; // AppRoute
import 'package:go_router/go_router.dart'; // context.go(), context.push()
```

---

## Side-Effect Navigation (ref.listen)

Use `ref.listen` in page `build()` for navigation triggered by state changes:

```dart
@override
Widget build(BuildContext context) {
  ref.listen(
    signInControllerProvider.select((SignInState s) => s.isSuccess),
    (bool? previous, bool next) {
      if (next) {
        context.go(AppRoute.home.path);
      }
    },
  );

  // ... widget tree
}
```

---

## Anti-Patterns

### WRONG: Hardcoded path strings

```dart
// WRONG
context.go('/home');

// CORRECT -- use AppRoute enum
context.go(AppRoute.home.path);
```

### WRONG: Missing auth guard for new routes

When adding a protected route, ensure the `redirect` callback in `app_router.dart` covers it. By default, any route not listed as an auth route will redirect unauthenticated users to sign-in.

### WRONG: Navigation in controller

```dart
// WRONG -- controllers should not know about navigation
class SignInController extends _$SignInController {
  Future<void> submit() async {
    // ... sign in logic
    context.go(AppRoute.home.path); // WRONG
  }
}

// CORRECT -- controller updates state, page listens and navigates
// Controller: state = state.copyWith(isSuccess: true);
// Page: ref.listen(...) { context.go(...); }
```

---

## References

- `lib/core/router/app_route.dart` -- Route enum
- `lib/core/router/app_router.dart` -- GoRouter provider with auth redirect
- `docs/architecture/navigation.md` -- Full navigation documentation
