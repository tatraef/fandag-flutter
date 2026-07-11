# Patterns Reference

Quick-lookup table mapping every architectural concept to its canonical file in the codebase.

---

## Domain Layer

| Concept | Canonical File | Description |
|---------|---------------|-------------|
| Entity (Freezed, no JSON) | `lib/features/auth/domain/entities/user.dart` | `@freezed abstract class User with _$User` — pure data, no serialization |
| Entity with DateTime | `lib/features/home/domain/entities/post.dart` | `@freezed abstract class Post with _$Post` — includes `DateTime createdAt` |
| Auth tokens entity | `lib/features/auth/domain/entities/auth_tokens.dart` | `@freezed abstract class AuthTokens with _$AuthTokens` |
| Repository interface (CRUD) | `lib/features/home/domain/repositories/home_repository.dart` | `abstract class HomeRepository` — `getPosts`, `getPost`, `createPost`, `deletePost` |
| Repository interface (auth) | `lib/features/auth/domain/repositories/auth_repository.dart` | `abstract class AuthRepository` — `signIn`, `signUp`, `signOut`, `getCurrentUser`, `getAuthState` |
| Sub-barrel (entities) | `lib/features/auth/domain/entities/entities.dart` | Exports: `auth_tokens.dart`, `user.dart` |
| Sub-barrel (repositories) | `lib/features/auth/domain/repositories/repositories.dart` | Exports: `auth_repository.dart` |
| Layer barrel (domain) | `lib/features/auth/domain/domain.dart` | Exports: `entities/entities.dart`, `repositories/repositories.dart` |

---

## Data Layer

| Concept | Canonical File | Description |
|---------|---------------|-------------|
| DTO (Freezed + JSON + toDomain) | `lib/features/auth/data/models/user_dto.dart` | `const UserDto._()` + `fromJson` + `toDomain()` |
| DTO with DateTime | `lib/features/home/data/models/post_dto.dart` | `PostDto` with `createdAt` field, `part 'gen/...'` for generated files |
| Request DTO (toJson only) | `lib/features/auth/data/models/sign_in_request.dart` | `SignInRequest` — `fromJson` generated but `toDomain()` not needed |
| Datasource (GET list) | `lib/features/home/data/datasources/home_remote_datasource.dart` | `final data = response.data ?? <dynamic>[]; data.cast<Map<String, dynamic>>().map(PostDto.fromJson).toList()` |
| Datasource (POST with body) | `lib/features/auth/data/datasources/auth_remote_datasource.dart` | `_apiClient.post<Map<String, dynamic>>(endpoint, data: request.toJson())` |
| Repository impl (simple) | `lib/features/home/data/repositories/home_repository_impl.dart` | Single datasource, DTO → domain mapping, no error mapping |
| Repository impl (complex) | `lib/features/auth/data/repositories/auth_repository_impl.dart` | Datasource + SecureStorage, token management, StreamController |
| Mock repository | `lib/features/auth/data/repositories/mock_auth_repository.dart` | `MockAuthRepository` — simulated delays, hardcoded responses |
| Sub-barrel (models) | `lib/features/auth/data/models/models.dart` | Exports all DTOs and request models |
| Sub-barrel (datasources) | `lib/features/auth/data/datasources/datasources.dart` | Exports datasource class |
| Sub-barrel (repositories) | `lib/features/auth/data/repositories/repositories.dart` | Exports impl and mock |
| Layer barrel (data) | `lib/features/auth/data/data.dart` | Exports: `datasources/`, `models/`, `repositories/` sub-barrels |

---

## Presentation Layer

| Concept | Canonical File | Description |
|---------|---------------|-------------|
| Form controller (Freezed state) | `lib/features/auth/presentation/controllers/sign_in_controller.dart` | `SignInState` + `SignInController` — setters, `_validate()`, `submit()` |
| Async list controller | `lib/features/home/presentation/controllers/home_controller.dart` | `Future<List<Post>> build()` + `refresh()`, `createPost()`, `deletePost()` |
| Global state controller | `lib/features/auth/presentation/controllers/auth_state_controller.dart` | `@Riverpod(keepAlive: true)` + `AuthState` + `onSignedIn()`, `onSignedOut()` |
| DI provider wiring | `lib/features/auth/presentation/controllers/auth_providers.dart` | `authRemoteDataSourceProvider` + `authRepositoryProvider` with mock switching |
| DI + controller co-located | `lib/features/home/presentation/controllers/home_controller.dart` | DI providers and controller in same file |
| Page (ConsumerStatefulWidget) | `lib/features/auth/presentation/pages/sign_in_page.dart` | TextEditingControllers + Consumer + `.select()` pattern |
| Page (ConsumerWidget + AsyncValue) | `lib/features/home/presentation/pages/home_page.dart` | `AsyncValue.when(loading, error, data)` |
| Feature widget | `lib/features/home/presentation/widgets/post_card.dart` | `StatelessWidget` with domain entity prop |
| Auth form widget | `lib/features/auth/presentation/widgets/auth_form_field.dart` | Reusable form field wrapper |
| Sub-barrel (controllers) | `lib/features/auth/presentation/controllers/controllers.dart` | Exports all controllers and providers |
| Sub-barrel (pages) | `lib/features/auth/presentation/pages/pages.dart` | Exports all pages |
| Sub-barrel (widgets) | `lib/features/auth/presentation/widgets/widgets.dart` | Exports all widgets |
| Layer barrel (presentation) | `lib/features/auth/presentation/presentation.dart` | Exports: `controllers/`, `pages/`, `widgets/` sub-barrels |

---

## Core Infrastructure

| Concept | Canonical File | Description |
|---------|---------------|-------------|
| ApiClient provider | `lib/core/network/dio_provider.dart` | `@Riverpod(keepAlive: true) ApiClient apiClient(Ref ref)` — wraps Dio with auto error conversion |
| Dio provider | `lib/core/network/dio_provider.dart` | `@Riverpod(keepAlive: true) Dio dio(Ref ref)` — used by ApiClient |
| API interceptor | `lib/core/network/api_interceptor.dart` | Token injection + 401 refresh |
| API exceptions | `lib/core/network/api_exception.dart` | `sealed class ApiException` hierarchy |
| Base exception | `lib/core/exceptions/app_exception.dart` | `abstract class AppException implements Exception` |
| API endpoints | `lib/core/constants/api_endpoints.dart` | `abstract class ApiEndpoints` with `static const String` |
| App durations | `lib/core/constants/app_durations.dart` | Timeouts, animation durations |
| Routes enum | `lib/core/router/app_route.dart` | `enum AppRoute { signIn('/sign-in'), ... }` |
| Router setup | `lib/core/router/app_router.dart` | `@riverpod GoRouter appRouter(Ref ref)` with auth redirect |
| Drift database | `lib/core/storage/database/app_database.dart` | `CacheEntries` table + `AppDatabase` |
| Database provider | `lib/core/storage/database/app_database_provider.dart` | `@Riverpod(keepAlive: true)` with `ref.onDispose(db.close)` |
| Secure storage | `lib/core/storage/secure_storage_provider.dart` | `FlutterSecureStorage` singleton |
| SharedPreferences | `lib/core/storage/shared_prefs_provider.dart` | Throws by default, overridden in `main.dart` |
| Theme colors | `lib/core/theme/theme_colors.dart` | `ThemeExtension<ThemeColors>` — 14 semantic tokens |
| Font styles | `lib/core/theme/primary_fonts.dart` | `ThemeExtension<PrimaryThemeFonts>` — 16 variants |
| Theme builder | `lib/core/theme/light_theme.dart` | `ThemeData lightTheme()` with Material3 |
| Color palette | `lib/core/theme/app_colors.dart` | Raw color constants |
| Context extensions (theme) | `lib/core/theme/theme_context_extension.dart` | `context.colors`, `context.primaryFonts` |
| Context extensions (general) | `lib/core/extensions/context_ext.dart` | `context.theme`, `context.screenWidth`, `context.showSnackBar` |
| Core button | `lib/core/widgets/app_button.dart` | `AppButton` with loading state |
| Core text field | `lib/core/widgets/app_text_field.dart` | `AppTextField` with error display |
| Loading overlay | `lib/core/widgets/loading_overlay.dart` | `LoadingOverlay` stack with spinner |
| App config | `lib/core/environment/app_config.dart` | `AppConfig.useMock` for mock switching |
| Secrets | `lib/core/environment/secrets.dart` | Generated environment URLs |
| Core barrel | `lib/core/core.dart` | Aggregate — exports all core sub-barrels |

---

## App Root

| Concept | Canonical File | Description |
|---------|---------------|-------------|
| Entry point | `lib/main.dart` | `runZonedGuarded` + init + `ProviderScope` |
| Root widget | `lib/app.dart` | `MaterialApp.router` with themes, translations, GoRouter |
| Widget reloader | `lib/core/widgets/reloadable_widget.dart` | Force full rebuild via `UniqueKey` |
