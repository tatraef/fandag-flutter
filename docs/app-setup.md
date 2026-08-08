# App Setup

Covers `main.dart`, `app.dart`, and the initialization flow.

---

## Initialization Flow

```
runZonedGuarded
  -> WidgetsFlutterBinding.ensureInitialized()
  -> LocaleSettings.useDeviceLocale()
  -> initMadInspector()
  -> SharedPreferences.getInstance()
  -> runApp(
       TranslationProvider(
         ReloadableWidget(
           ProviderScope(
             overrides: [sharedPrefsProvider],
             observers: [RiverpodObserver (test builds only)],
             child: App()
           )
         )
       )
     )
```

### main.dart

```dart
void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await LocaleSettings.useDeviceLocale();
      await initMadInspector();

      final SharedPreferences sharedPrefs =
          await SharedPreferences.getInstance();

      runApp(
        TranslationProvider(
          child: ReloadableWidget(
            builder: (BuildContext context) => ProviderScope(
              overrides: [sharedPrefsProvider.overrideWithValue(sharedPrefs)],
              observers: const <ProviderObserver>[
                if (isTestBuild) RiverpodObserver(),
              ],
              child: const App(),
            ),
          ),
        ),
      );
    },
    (Object error, StackTrace stackTrace) {
      debugPrint('Zone error', tag: 'Zone', error: error, stackTrace: stackTrace);
    },
  );
}
```

**Key points:**

- `runZonedGuarded` catches uncaught async errors and routes them to the custom `debugPrint` (which logs to MadInspector when available).
- `LocaleSettings.useDeviceLocale()` -- sets the locale from slang before the widget tree starts.
- `initMadInspector()` -- initializes the debug inspector. Must be called before `ProviderScope` so the Dio interceptor is available when Dio is created.
- `SharedPreferences` is obtained as a `Future` before the widget tree, then injected via `overrideWithValue` -- this avoids async provider initialization. The `sharedPrefsProvider` itself throws `UnimplementedError` if not overridden, so the override is mandatory.
- `TranslationProvider` wraps the entire app for slang localization.
- `ReloadableWidget` enables full widget tree rebuild without hot restart (used by the debug menu).
- `RiverpodObserver` is only added in test/debug builds (controlled by `isTestBuild`).

---

## app.dart

```dart
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoRouter router = ref.watch(appRouterProvider);

    return MadInspectorView(
      navigatorKey: rootNavigatorKey,
      child: MaterialApp.router(
        title: context.t.common.appTitle,
        theme: lightTheme(),
        darkTheme: darkTheme(),
        themeMode: ThemeMode.system,
        locale: TranslationProvider.of(context).flutterLocale,
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocaleUtils.supportedLocales,
        routerConfig: router,
        builder: (BuildContext context, Widget? child) => GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: child,
        ),
      ),
    );
  }
}
```

**Key points:**

- `ConsumerWidget` -- watches `appRouterProvider` for reactive router updates.
- `MadInspectorView` -- debug overlay that wraps the entire app (no-op in release).
- `MaterialApp.router` -- uses GoRouter instead of `Navigator`.
- `lightTheme()` / `darkTheme()` -- custom ThemeData with ThemeExtensions.
- `ThemeMode.system` -- follows the OS light/dark preference.
- `GestureDetector` builder -- tapping outside a text field dismisses the keyboard.
- `rootNavigatorKey` -- shared `GlobalKey<NavigatorState>` used by both GoRouter and MadInspector. Recreated during app reload to fully reset navigation state.

---

## Environment Configuration

### AppConfig

```dart
abstract class AppConfig {
  static const bool useMock = bool.fromEnvironment('USE_MOCK');
}
```

Switch between real and mock implementations at build time:

```bash
# Real API
make run

# Mock mode
fvm flutter run --dart-define=USE_MOCK=true
```

Used in provider wiring (e.g., `auth_providers.dart`):

```dart
@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  if (AppConfig.useMock) {
    return AuthRepositoryMock();
  }
  // ... real implementation
}
```

### Build Flags

Two compile-time flags control debug tooling (defined via `--dart-define`):

| Flag | Default | Purpose |
|---|---|---|
| `mb.isTestBuild` | `true` | Enables `RiverpodObserver`, `RouterObserver`, custom `debugPrint` logging, and dev servers in server selection |
| `mb.isInspectorOnDebugMode` | `true` | Enables MadInspector UI overlay and debug menu buttons |

Both flags are declared in `inspector_initializer.dart`. When `isTestBuild` is `false`, all debug logging and observers become no-ops at zero cost.

### Secrets

```dart
// GENERATED CODE - DO NOT MODIFY BY HAND
abstract class Secrets {
  static const baseUrlDev = 'https://api-dev.example.com';
  static const baseUrlStage = 'https://api-stage.example.com';
  static const baseUrlProd = 'https://api.example.com';
}
```

Generated by `mad_env_cli` from environment config files. Regenerate with:

```bash
make generate_env_files
```

This reads from `config/config.env` and `config/secrets.env` using the generation config at `config/env_gen_config.json`.

### ServerConfig

`ServerConfig` uses `Secrets` to provide server URLs to the MadInspector server selection module:

- In test builds (`isTestBuild == true`): all three environments (dev, stage, prod) are available for selection.
- In production builds: only the prod URL is available.
- `ServerConfig.getCurrentServerUrl()` returns the currently selected server URL (defaults to prod).

---

## ReloadableWidget

Enables full widget tree rebuild without hot restart. Useful for debug menu operations (clear storage, switch server, etc.).

### How It Works

`ReloadableWidget` is a `StatefulWidget` that holds a `UniqueKey`. When `reloadWidget()` is called, it generates a new `UniqueKey` via `setState`, causing Flutter to treat the entire subtree as new and rebuild it from scratch. Since `ProviderScope` is inside the `ReloadableWidget` builder, all Riverpod providers are recreated.

### Usage

```dart
// Trigger from anywhere with BuildContext
ReloadableWidget.reloadWidget(context);

// or using the extension
context.reloadWidget();

// Safe across async gaps (capture before await)
final VoidCallback? reload = ReloadableWidget.captureReloadFunction(context);
await someAsyncOperation();
reload?.call();
```

### AppReloader

`AppReloader.reload(context)` is the high-level reload entry point used by the debug menu. It performs three steps:

1. Captures the `ReloadableWidget` state reference (before any async gap).
2. Re-initializes MadInspector (`await initMadInspector()`).
3. Recreates `rootNavigatorKey` to reset navigation state.
4. Calls the captured reload function to rebuild the widget tree.

**What gets reset:** all Riverpod providers, navigation state, MadInspector state.
**What gets preserved:** zone error handling (at `runZonedGuarded` level), `SharedPreferences` instance (re-injected via override).

---

## MadInspector Initialization

`initMadInspector()` performs the following:

1. Initializes MadInspector in debug or release mode (based on `isInspectorOnDebugMode`).
2. Registers modules: `MadDioModule` (network traffic logging), `MadDebugMenuModule` (debug menu UI), `MadServerSelectionModule` (server switching).
3. Creates a default `appLogger` and wires it into the custom `debugPrint`/`debugPublicPrint` system -- all log output is routed to MadInspector's log viewer.
4. Sets up the `printZoneErrorLogger` callback so zone errors also appear in the inspector.
5. In debug mode, configures the debug menu with `ReloadApplicationButton` and `SystemInfoWidget`.

---

## RiverpodObserver

`RiverpodObserver` is a `ProviderObserver` that routes Riverpod lifecycle events to MadInspector's log viewer. It logs:

- `CREATED` -- when a provider is first initialized (with its value).
- `UPDATED` -- when a provider's value changes (with previous and new values, truncated to 300 characters).
- `DISPOSED` -- when a provider is disposed.
- `ERROR` -- when a provider fails (with error and stack trace).
- `MUTATION START` / `MUTATION SUCCESS` / `MUTATION ERROR` / `MUTATION RESET` -- experimental Riverpod mutation lifecycle events.

Each provider's name is used as the log tag, so providers get their own sections in the inspector's log viewer for easy filtering.

Only active when `isTestBuild` is `true` -- zero cost in release builds.

---

## SharedPreferences Provider Pattern

The `sharedPrefsProvider` uses a "throw-then-override" pattern:

```dart
@Riverpod(keepAlive: true)
SharedPreferences sharedPrefs(Ref ref) {
  throw UnimplementedError(
    'sharedPrefsProvider must be overridden with a valid SharedPreferences instance',
  );
}
```

This is a synchronous provider whose body intentionally throws. In `main.dart`, the `SharedPreferences` instance is obtained asynchronously before the widget tree starts, then injected via `overrideWithValue`. This pattern avoids the need for `AsyncValue<SharedPreferences>` throughout the app -- consumers can use `ref.watch(sharedPrefsProvider)` and get a synchronous `SharedPreferences` value directly.

---

## File Locations

| File | Path |
|---|---|
| Entry point | `lib/main.dart` |
| App widget | `lib/app.dart` |
| AppConfig | `lib/core/environment/app_config.dart` |
| Secrets (generated) | `lib/core/environment/secrets.dart` |
| Inspector initializer | `lib/core/inspector/inspector_initializer.dart` |
| ServerConfig | `lib/core/inspector/server_config.dart` |
| RiverpodObserver | `lib/core/inspector/riverpod_observer.dart` |
| ReloadableWidget | `lib/core/widgets/reloadable_widget.dart` |
| AppReloader | `lib/core/app/app_reloader.dart` |
| SharedPrefs provider | `lib/core/storage/shared_prefs_provider.dart` |
| Custom debugPrint | `lib/core/utils/debug_print.dart` |
| Router (appRouterProvider) | `lib/core/router/app_router.dart` |
