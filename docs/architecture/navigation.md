# Navigation

GoRouter setup, route definitions, auth guards, and navigation patterns.

---

## Anti-Patterns

### WRONG: Hardcoded path string

```dart
// WRONG -- hardcoded path, easy to typo
context.go('/sign-in');

// CORRECT -- use AppRoute enum
context.go(AppRoute.signIn.path);
```

### WRONG: `context.push` when `context.go` is appropriate

```dart
// WRONG -- push creates back-stack entry for top-level navigation
context.push(AppRoute.home.path); // After login, user can press back to sign-in

// CORRECT -- go replaces the route, no back button
context.go(AppRoute.home.path);
```

### WRONG: Missing page import in app_router.dart

```dart
// WRONG -- forgot to import the feature's presentation barrel
GoRoute(
  path: AppRoute.profile.path,
  builder: (_, __) => const ProfilePage(), // Compilation error!
),

// CORRECT -- import the presentation barrel
import 'package:flutter_template_v3/features/profile/presentation/presentation.dart';
```

---

## AppRoute Enum

All routes are defined as enum values with their path:

```dart
// lib/core/router/app_route.dart
enum AppRoute {
  signIn('/sign-in'),
  signUp('/sign-up'),
  passwordRecovery('/password-recovery'),
  home('/home');

  const AppRoute(this.path);

  final String path;
}
```

**Path convention:** kebab-case, starting with `/`.

---

## GoRouter Setup

The router is a Riverpod provider defined in `lib/core/router/app_router.dart`:

```dart
/// Navigator key used by GoRouter, exposed for [MadInspectorView] integration.
///
/// Recreated in [AppReloader.reload] to fully reset navigation state.
GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

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
    observers: <NavigatorObserver>[
      if (isTestBuild) RouterObserver(),
    ],
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
      GoRoute(
        path: AppRoute.signIn.path,
        builder: (BuildContext context, GoRouterState state) =>
            const SignInPage(),
      ),
      GoRoute(
        path: AppRoute.signUp.path,
        builder: (BuildContext context, GoRouterState state) =>
            const SignUpPage(),
      ),
      GoRoute(
        path: AppRoute.passwordRecovery.path,
        builder: (BuildContext context, GoRouterState state) =>
            const PasswordRecoveryPage(),
      ),
      GoRoute(
        path: AppRoute.home.path,
        builder: (BuildContext context, GoRouterState state) =>
            const HomePage(),
      ),
    ],
  );
}
```

**Key points:**
- `@riverpod` (auto-dispose) -- router recreates when auth state invalidates it
- `refreshListenable` -- GoRouter re-evaluates `redirect` whenever `isAuthenticated` changes
- `ref.listen` bridges Riverpod auth state to GoRouter's `ValueNotifier`
- `rootNavigatorKey` -- shared with `MadInspectorView` for debug overlay

---

## Router Integration in App

The router is consumed in `lib/app.dart` via `ref.watch`:

```dart
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoRouter router = ref.watch(appRouterProvider);

    return MadInspectorView(
      navigatorKey: rootNavigatorKey,
      child: MaterialApp.router(
        routerConfig: router,
        // ...theme, locale, etc.
      ),
    );
  }
}
```

`rootNavigatorKey` is passed to both `GoRouter` and `MadInspectorView` so the debug overlay can sit above the navigation stack.

---

## Auth Guard Pattern

The `redirect` callback implements a guard:

| Condition | Action |
|-----------|--------|
| Not authenticated + not on auth page | Redirect to `/sign-in` |
| Authenticated + on auth page | Redirect to `/home` |
| Otherwise | `null` (no redirect) |

Auth pages are: `/sign-in`, `/sign-up`, `/password-recovery`.

The guard runs automatically whenever:
- A navigation occurs
- `isAuthenticated` value changes (via `refreshListenable`)

---

## Navigation in Code

### Replace current route (go)

```dart
context.go(AppRoute.home.path);
```

Use for top-level navigation where you don't want a back button.

### Push onto stack (push)

```dart
context.push(AppRoute.signUp.path);
```

Use when user should be able to go back.

### Go back (pop)

```dart
context.pop();
```

### Navigate between auth pages

```dart
// From sign-in to sign-up
TextButton(
  onPressed: () => context.go(AppRoute.signUp.path),
  child: Text(context.t.auth.dontHaveAccount),
)

// From sign-in to password recovery
TextButton(
  onPressed: () => context.go(AppRoute.passwordRecovery.path),
  child: Text(context.t.auth.forgotPassword),
)
```

---

## Adding a New Route

### Step 1: Add enum value

```dart
// lib/core/router/app_route.dart
enum AppRoute {
  signIn('/sign-in'),
  signUp('/sign-up'),
  passwordRecovery('/password-recovery'),
  home('/home'),
  profile('/profile'),  // <-- NEW
  ;

  const AppRoute(this.path);
  final String path;
}
```

### Step 2: Add GoRoute

```dart
// lib/core/router/app_router.dart -- inside routes list
GoRoute(
  path: AppRoute.profile.path,
  builder: (BuildContext context, GoRouterState state) =>
      const ProfilePage(),
),
```

### Step 3: Update the redirect guard (if needed)

If the new route should be accessible without authentication, add it to the `isAuthRoute` check. Otherwise the default guard already protects it -- unauthenticated users will be redirected to `/sign-in`.

### Step 4: Import the page

Add the feature's presentation barrel to the imports of `app_router.dart`:

```dart
import 'package:flutter_template_v3/features/profile/presentation/presentation.dart';
```

### Step 5: Run code generation

```bash
make gen
```

The router provider's `.g.dart` file will be regenerated.

---

## Route with Parameters

For routes that need parameters (e.g., detail pages):

```dart
// Enum
orderDetail('/orders/:id'),

// GoRoute
GoRoute(
  path: AppRoute.orderDetail.path,
  builder: (BuildContext context, GoRouterState state) {
    final String id = state.pathParameters['id']!;

    return OrderDetailPage(id: id);
  },
),

// Navigation
context.push('/orders/$orderId');
```

---

## RouterObserver

`RouterObserver` is a `NavigatorObserver` that logs navigation events to MadInspector. It is defined in `lib/core/router/router_observer.dart`.

Only active in test/debug builds (`isTestBuild` comes from the `mb.isTestBuild` compile-time environment variable, defaulting to `true`):

```dart
observers: <NavigatorObserver>[
  if (isTestBuild) RouterObserver(),
],
```

It logs four event types under the `'Router'` tag:

| Event | Log format |
|-------|-----------|
| `didPush` | `>> PUSH /home \| from: /sign-in` |
| `didPop` | `<< POP /home \| back to: /sign-in` |
| `didReplace` | `~ REPLACE /sign-in -> /home` |
| `didRemove` | `- REMOVE /home` |

---

## AppReloader and Navigation Reset

`AppReloader` (in `lib/core/app/app_reloader.dart`) handles full application reload, which includes resetting navigation state:

```dart
// Recreate navigator key so new GoRouter starts with fresh navigation
rootNavigatorKey = GlobalKey<NavigatorState>();
```

This is triggered from MadInspector's debug menu (reload app action). The full reload sequence:
1. Re-initializes MadInspector
2. Recreates `rootNavigatorKey` (resets navigation stack)
3. Rebuilds the entire widget tree via `ReloadableWidget` (recreates `ProviderScope`, resetting all providers)

---

## Barrel File

All router files are re-exported from `lib/core/router/router.dart`:

```dart
export 'app_route.dart';
export 'app_router.dart';
export 'router_observer.dart';
```

Import in other files via:

```dart
import 'package:flutter_template_v3/core/router/router.dart';
```
