# Project Structure

## Full Tree

```
lib/
├── main.dart                          # Entry point: WidgetsBinding, Inspector, ProviderScope
├── app.dart                           # MaterialApp.router with theme, translations, GoRouter
│
├── core/                              # Shared infrastructure (not a feature)
│   ├── core.dart                      # Aggregate barrel for all core subfolders
│   │
│   ├── constants/
│   │   ├── constants.dart             # Barrel
│   │   ├── api_endpoints.dart         # API path constants
│   │   └── app_durations.dart         # Timeout / animation durations
│   │
│   ├── environment/
│   │   ├── app_config.dart            # Mock / real toggle
│   │   └── secrets.dart               # Build-time env variables
│   │
│   ├── extensions/
│   │   ├── extensions.dart            # Barrel
│   │   ├── context_ext.dart           # BuildContext helpers (theme, snackbar)
│   │   └── string_ext.dart            # String utilities
│   │
│   ├── inspector/
│   │   ├── inspector.dart             # Barrel
│   │   ├── inspector_initializer.dart # MadInspector bootstrap
│   │   └── server_config.dart         # Server selection config
│   │
│   ├── translations/                  # Translations (NOT in barrel)
│   │   ├── en.i18n.json               # English strings (nested JSON)
│   │   ├── ru.i18n.json               # Russian strings (nested JSON)
│   │   └── generated/                 # Auto-generated translations (slang)
│   │
│   ├── network/
│   │   ├── network.dart               # Barrel
│   │   ├── dio_provider.dart          # Riverpod provider for Dio
│   │   ├── api_interceptor.dart       # Auth header interceptor
│   │   └── api_exception.dart         # Typed API exceptions
│   │
│   ├── router/
│   │   ├── router.dart                # Barrel
│   │   ├── app_route.dart             # AppRoute enum with paths
│   │   └── app_router.dart            # GoRouter provider with redirect logic
│   │
│   ├── storage/
│   │   ├── storage.dart               # Barrel
│   │   ├── database/
│   │   │   ├── app_database.dart      # Drift database definition
│   │   │   └── app_database_provider.dart
│   │   ├── secure_storage_provider.dart
│   │   └── shared_prefs_provider.dart
│   │
│   ├── theme/
│   │   ├── theme.dart                 # Barrel
│   │   ├── app_colors.dart            # Colour palette constants
│   │   ├── app_theme_data.dart        # Base ThemeData builder
│   │   ├── dark_theme.dart            # Dark ThemeData
│   │   ├── light_theme.dart           # Light ThemeData
│   │   ├── primary_fonts.dart         # Font families
│   │   ├── theme_colors.dart          # Semantic colour tokens
│   │   └── theme_context_extension.dart
│   │
│   └── widgets/
│       ├── widgets.dart               # Barrel
│       ├── app_button.dart            # Reusable button
│       ├── app_text_field.dart        # Reusable text field
│       └── loading_overlay.dart       # Loading indicator overlay
│
└── features/                          # Business features
    ├── auth/
    │   ├── domain/
    │   │   ├── domain.dart            # Layer barrel → exports sub-barrels
    │   │   ├── entities/
    │   │   │   ├── entities.dart      # Sub-barrel
    │   │   │   ├── auth_tokens.dart   # @freezed AuthTokens
    │   │   │   └── user.dart          # @freezed User
    │   │   └── repositories/
    │   │       ├── repositories.dart  # Sub-barrel
    │   │       └── auth_repository.dart # Abstract AuthRepository
    │   │
    │   ├── data/
    │   │   ├── data.dart              # Layer barrel → exports sub-barrels
    │   │   ├── datasources/
    │   │   │   ├── datasources.dart   # Sub-barrel
    │   │   │   └── auth_remote_datasource.dart
    │   │   ├── models/
    │   │   │   ├── models.dart        # Sub-barrel
    │   │   │   ├── auth_tokens_dto.dart
    │   │   │   ├── sign_in_request.dart
    │   │   │   ├── sign_up_request.dart
    │   │   │   └── user_dto.dart
    │   │   └── repositories/
    │   │       ├── repositories.dart  # Sub-barrel
    │   │       └── auth_repository_impl.dart
    │   │
    │   └── presentation/
    │       ├── presentation.dart       # Layer barrel → exports sub-barrels
    │       ├── controllers/
    │       │   ├── controllers.dart    # Sub-barrel
    │       │   ├── auth_providers.dart  # DI wiring providers
    │       │   ├── auth_state_controller.dart
    │       │   ├── sign_in_controller.dart
    │       │   ├── sign_up_controller.dart
    │       │   └── password_recovery_controller.dart
    │       ├── pages/
    │       │   ├── pages.dart          # Sub-barrel
    │       │   ├── sign_in_page.dart
    │       │   ├── sign_up_page.dart
    │       │   └── password_recovery_page.dart
    │       └── widgets/
    │           ├── widgets.dart        # Sub-barrel
    │           └── auth_form_field.dart
    │
    └── home/
        ├── domain/
        │   ├── domain.dart            # Layer barrel → exports sub-barrels
        │   ├── entities/
        │   │   ├── entities.dart      # Sub-barrel
        │   │   └── post.dart
        │   └── repositories/
        │       ├── repositories.dart  # Sub-barrel
        │       └── home_repository.dart
        ├── data/
        │   ├── data.dart              # Layer barrel → exports sub-barrels
        │   ├── datasources/
        │   │   ├── datasources.dart   # Sub-barrel
        │   │   └── home_remote_datasource.dart
        │   ├── models/
        │   │   ├── models.dart        # Sub-barrel
        │   │   └── post_dto.dart
        │   └── repositories/
        │       ├── repositories.dart  # Sub-barrel
        │       └── home_repository_impl.dart
        └── presentation/
            ├── presentation.dart      # Layer barrel → exports sub-barrels
            ├── controllers/
            │   ├── controllers.dart   # Sub-barrel
            │   └── home_controller.dart
            ├── pages/
            │   ├── pages.dart         # Sub-barrel
            │   └── home_page.dart
            └── widgets/
                ├── widgets.dart       # Sub-barrel
                └── post_card.dart
```

---

## Naming Conventions

| Artefact | Pattern | Example |
|----------|---------|---------|
| Feature folder | `snake_case` noun | `auth`, `home`, `user_profile` |
| Domain entity | `snake_case.dart`, class PascalCase | `user.dart` -> `User` |
| DTO | `<entity>_dto.dart` | `user_dto.dart` -> `UserDto` |
| Request model | `<action>_request.dart` | `sign_in_request.dart` -> `SignInRequest` |
| Repository interface | `<feature>_repository.dart` | `auth_repository.dart` -> `AuthRepository` |
| Repository impl | `<feature>_repository_impl.dart` | `auth_repository_impl.dart` -> `AuthRepositoryImpl` |
| Data source | `<feature>_remote_datasource.dart` | `auth_remote_datasource.dart` |
| Controller | `<action>_controller.dart` | `sign_in_controller.dart` -> `SignInController` |
| Controller state | Declared in same file as controller | `SignInState` in `sign_in_controller.dart` |
| Page | `<name>_page.dart` | `sign_in_page.dart` -> `SignInPage` |
| Widget | `<name>.dart` (descriptive) | `post_card.dart` -> `PostCard` |
| Provider file | `<feature>_providers.dart` | `auth_providers.dart` |
| Layer barrel | `<layer>.dart` | `domain.dart`, `data.dart`, `presentation.dart` |
| Sub-barrel | `<folder_name>.dart` | `entities.dart`, `models.dart`, `controllers.dart` |
| Core barrel | `<folder_name>.dart` | `network.dart`, `theme.dart` |
| Generated files | `*.g.dart`, `*.freezed.dart`, `*.drift.dart` | auto-generated, never edited |

---

## Decision Tree: Where Does a New File Go?

```
Is it shared across multiple features?
├── YES -> lib/core/<subfolder>/
│   Is it a widget?     -> core/widgets/
│   Is it a constant?   -> core/constants/
│   Is it a theme file? -> core/theme/
│   Is it networking?   -> core/network/
│   Is it storage?      -> core/storage/
│   Is it a helper?     -> core/extensions/
│   Is it routing?      -> core/router/
│
└── NO -> lib/features/<feature>/
    Is it a business entity or repo contract?
    ├── YES -> domain/entities/ or domain/repositories/
    │
    Is it a DTO, request model, data source, or repo impl?
    ├── YES -> data/models/, data/datasources/, or data/repositories/
    │
    Is it a controller, page, or widget?
    └── YES -> presentation/controllers/, pages/, or widgets/
```

After placing the file, immediately add it to the corresponding barrel file. See [barrel-files.md](../conventions/barrel-files.md).

---

## Core Module Catalog

### constants

API path strings (`ApiEndpoints`) and duration constants (`AppDurations`) used for network timeouts and UI animations. Centralizes all magic numbers so they can be tuned in one place.

### environment

Build-time configuration that determines runtime behavior. `AppConfig.useMock` is the global toggle that switches every repository between real and mock implementations. `secrets.dart` holds generated API base URLs and keys injected via `--dart-define` during CI builds.

### extensions

`BuildContext` helpers (`context_ext.dart`) that provide shortcuts for accessing theme data, screen dimensions, localizations, and showing snackbars without boilerplate. `string_ext.dart` adds common String utilities such as capitalization and email validation helpers.

### inspector

MadInspector debug panel initialization (`inspector_initializer.dart`) bootstraps the in-app debug overlay used during development. `server_config.dart` defines the server selection configuration that lets developers switch between staging and production endpoints at runtime through the inspector UI.

### translations

Localization powered by the slang package. Source strings live in `en.i18n.json` and `ru.i18n.json` as nested JSON grouped by feature (`common.*`, `auth.*`, `home.*`). Running `make translations` generates type-safe Dart translation classes in the `generated/` subfolder, accessed at runtime via `context.t.group.key`.

### network

Dio HTTP client provider (`dio_provider.dart`) configured as a `keepAlive` Riverpod provider with base URL, timeouts, and serialization settings. `api_interceptor.dart` injects the current auth token into every request header and triggers token refresh on 401 responses. `api_exception.dart` defines a sealed `ApiException` hierarchy (network error, timeout, unauthorized, server error, unknown) used across all data sources for consistent error handling.

### router

GoRouter configuration (`app_router.dart`) provided via Riverpod codegen. `app_route.dart` is an enum that maps every screen to its URL path, keeping route strings type-safe. The router includes auth-guard redirect logic that checks the current authentication state and redirects unauthenticated users to the sign-in page while preventing authenticated users from accessing auth screens.

### storage

Persistence layer with three backends. Drift SQLite database (`app_database.dart`) handles structured local data with type-safe queries and migrations. `FlutterSecureStorage` (`secure_storage_provider.dart`) stores sensitive data like auth tokens using platform keychain/keystore. `SharedPreferences` (`shared_prefs_provider.dart`) persists lightweight settings such as theme mode and onboarding flags.

### theme

Material 3 theming system. `ThemeColors` defines 14 semantic color tokens (primary, secondary, error, surface variants, etc.) that adapt between `light_theme.dart` and `dark_theme.dart`. `PrimaryThemeFonts` specifies 16 text styles (headline, title, body, label at multiple sizes) using the project's font family. `theme_context_extension.dart` adds `context.colors` and `context.fonts` shortcuts so widgets never access raw `Theme.of(context)` directly.

### widgets

Shared UI components reused across features. `AppButton` is the standard elevated/outlined button with loading state support. `AppTextField` wraps Material's `TextField` with consistent styling, validation display, and obscure-text toggle for passwords. `LoadingOverlay` renders a semi-transparent barrier with a centered spinner, used during async form submissions. `ReloadableWidget` provides pull-to-refresh and error-retry patterns for list screens.

---

## Feature Anatomy

### auth — Authentication flows

Sign in, sign up, and password recovery flows with form validation and token management.

#### domain

| File | Purpose |
|------|---------|
| `user.dart` | `@freezed User` entity with `id`, `email`, `name` fields. Pure domain model with no serialization logic. |
| `auth_tokens.dart` | `@freezed AuthTokens` entity holding `accessToken` and `refreshToken` pair. |
| `auth_repository.dart` | Abstract `AuthRepository` interface declaring `signIn`, `signUp`, `recoverPassword`, `logout`, and an `authStateStream` for reactive auth observation. |

#### data

| File | Purpose |
|------|---------|
| `user_dto.dart` | `@freezed UserDto` with `fromJson` factory and `toDomain()` method that maps to the `User` entity. |
| `auth_tokens_dto.dart` | `@freezed AuthTokensDto` with `fromJson` and `toDomain()` mapping to `AuthTokens`. |
| `sign_in_request.dart` | `@freezed SignInRequest` with `toJson()` — carries `email` and `password` for the sign-in API call. |
| `sign_up_request.dart` | `@freezed SignUpRequest` with `toJson()` — carries `email`, `password`, and `name` for the sign-up API call. |
| `auth_remote_datasource.dart` | `AuthRemoteDataSource` — ApiClient-based HTTP client that calls auth endpoints (`/auth/sign-in`, `/auth/sign-up`, `/auth/recover-password`). Returns DTOs. |
| `auth_repository_impl.dart` | `AuthRepositoryImpl` — implements `AuthRepository`. Orchestrates the datasource, persists tokens to `FlutterSecureStorage`, and broadcasts auth state changes through a `StreamController`. Handles token refresh and logout cleanup. |

#### presentation

| File | Purpose |
|------|---------|
| `sign_in_controller.dart` | Riverpod codegen controller managing sign-in form state (email, password, validation errors, loading). Calls `AuthRepository.signIn` on submit. |
| `sign_up_controller.dart` | Riverpod codegen controller managing sign-up form state (email, password, name, validation errors, loading). Calls `AuthRepository.signUp` on submit. |
| `password_recovery_controller.dart` | Riverpod codegen controller managing password recovery form state (email, validation, loading). Calls `AuthRepository.recoverPassword` on submit. |
| `auth_state_controller.dart` | `@Riverpod(keepAlive: true)` global controller that exposes the current auth state (`authenticated` / `unauthenticated`). Listens to the repository's `authStateStream` and drives router redirects. |
| `auth_providers.dart` | DI wiring file that provides `AuthRepository` and `AuthRemoteDataSource` via Riverpod codegen. Reads `AppConfig.useMock` to switch between `AuthRepositoryImpl` and a mock implementation. |
| `sign_in_page.dart` | Sign-in screen with email/password fields, submit button, and navigation links to sign-up and password recovery. Uses `ref.listen` for navigation side-effects on success. |
| `sign_up_page.dart` | Sign-up screen with name/email/password fields and submit button. Navigates to home on successful registration. |
| `password_recovery_page.dart` | Password recovery screen with email field. Shows a success message and navigates back to sign-in on completion. |
| `auth_form_field.dart` | `AuthFormField` widget — a styled wrapper around `AppTextField` configured for auth forms with consistent padding, label placement, and error display. |

---

### home — Posts CRUD

Displays a list of posts fetched from the API with pull-to-refresh and error handling.

#### domain

| File | Purpose |
|------|---------|
| `post.dart` | `@freezed Post` entity with `id`, `title`, `body` fields. Pure domain model. |
| `home_repository.dart` | Abstract `HomeRepository` interface declaring `getPosts` and individual post CRUD methods. |

#### data

| File | Purpose |
|------|---------|
| `post_dto.dart` | `@freezed PostDto` with `fromJson` factory and `toDomain()` mapping to the `Post` entity. |
| `home_remote_datasource.dart` | `HomeRemoteDataSource` — ApiClient-based HTTP client that calls posts endpoints. Returns `PostDto` lists. |
| `home_repository_impl.dart` | `HomeRepositoryImpl` — implements `HomeRepository`. Delegates to the datasource and maps DTOs to domain entities. |

#### presentation

| File | Purpose |
|------|---------|
| `home_controller.dart` | Riverpod codegen async controller that fetches the post list via `HomeRepository`. Exposes `AsyncValue<List<Post>>` state. Co-locates DI provider wiring for `HomeRepository` and `HomeRemoteDataSource` in the same file, keeping the home feature self-contained. |
| `home_page.dart` | Home screen that renders the post list using `AsyncValue.when` — showing a loading spinner, error state with retry, or the scrollable list of `PostCard` widgets. Uses `Consumer` with `.select()` for selective rebuilds. |
| `post_card.dart` | `PostCard` widget — a Material card displaying a single post's title and body excerpt. Stateless, receives `Post` as a constructor parameter. |
