# Error Handling

How errors flow through the architecture: from HTTP responses to UI feedback.

---

## When to Catch vs Rethrow

| Layer | Catches | Throws | Updates State |
|-------|---------|--------|---------------|
| ApiClient | Any error | `ApiException` (via errorInterceptor) | N/A |
| Interceptor | Errors (401 only) | Retries or forwards | N/A |
| Datasource | Nothing | `ApiException` (from ApiClient) | N/A |
| Repository | Nothing (or `ApiException` to rethrow) | `ApiException` | N/A |
| Controller | `Exception` | Nothing (updates state) | Yes |
| Page | Nothing | Nothing | N/A (reads state) |

## Layer Responsibilities

- **ApiClient**: Wraps Dio, converts ALL errors to `ApiException` via `errorInterceptor`
- **Datasource**: Uses `ApiClient`, NO error handling -- `ApiException` already thrown
- **Repository**: NO error handling -- `ApiException` already thrown by datasource
- **Controller**: catch `Exception`, update state -- NEVER rethrow
- **Page**: NEVER catch -- display error state from controller

---

## Anti-Patterns

### WRONG: Using Dio directly in datasource

```dart
// WRONG -- bypasses automatic error conversion
class BadDataSource {
  BadDataSource({required Dio dio}) : _dio = dio;
  final Dio _dio;
}

// CORRECT -- use ApiClient, which converts errors to ApiException
class GoodDataSource {
  GoodDataSource({required ApiClient apiClient}) : _apiClient = apiClient;
  final ApiClient _apiClient;
}
```

### WRONG: try/catch in datasource or repository

```dart
// WRONG -- ApiClient already converts to ApiException
Future<List<Post>> getPosts() async {
  try {
    final response = await _apiClient.get(...);
    return ...;
  } on ApiException {
    rethrow;  // Pointless try-catch
  }
}

// CORRECT -- no try-catch needed
Future<List<Post>> getPosts() async {
  final response = await _apiClient.get(...);
  return ...;
}
```

### WRONG: Rethrowing in controller

```dart
// WRONG -- controllers should never rethrow
} on Exception catch (e) {
  state = state.copyWith(isLoading: false);
  rethrow; // WRONG
}

// CORRECT -- update state with typed error
} on Exception catch (e) {
  state = state.copyWith(isLoading: false, error: e);
}
```

### WRONG: try/catch in page

```dart
// WRONG -- pages should not handle exceptions
try {
  final List<Post> posts = await ref.read(homeControllerProvider.notifier).getPosts();
} on Exception catch (e) {
  showDialog(...);
}

// CORRECT -- read error from state and localize in page
final Exception? error = ref.watch(
  signInControllerProvider.select((SignInState s) => s.error),
);
if (error != null) {
  Text(context.localizedErrorMessage(error));
}
```

### WRONG: Catching `Error` (not `Exception`)

```dart
// WRONG -- Error is for programming bugs, not expected failures
} on Error catch (e) { ... }

// CORRECT -- catch Exception for expected failures
} on Exception catch (e) { ... }
```

---

## Exception Hierarchy

```
Exception (dart:core)
  └── AppException (abstract)
        └── ApiException (sealed)
              ├── NetworkException       -- No internet connection
              ├── UnauthorizedException  -- 401
              ├── BadRequestException    -- 400
              ├── NotFoundException      -- 404
              ├── ServerException        -- 500+
              └── TimeoutException       -- Connection/send/receive timeout
```

### AppException (base)

```dart
// lib/core/exceptions/app_exception.dart
abstract class AppException implements Exception {
  const AppException({this.message});
  final String? message;
}
```

### ApiException (sealed)

```dart
// lib/core/network/api_exception.dart
sealed class ApiException extends AppException {
  const ApiException({super.message, this.statusCode, this.errorCode});
  final int? statusCode;
  final String? errorCode;  // Server error code: "USER_EXISTS", "INVALID_CREDENTIALS", etc.
}

class NetworkException extends ApiException {
  const NetworkException({super.message = 'No internet connection'});
}
class UnauthorizedException extends ApiException {
  const UnauthorizedException({super.message = 'Unauthorized', super.statusCode = 401});
}
class ServerException extends ApiException {
  const ServerException({super.message = 'Server error', super.statusCode = 500});
}
class TimeoutException extends ApiException {
  const TimeoutException({super.message = 'Request timeout'});
}
class BadRequestException extends ApiException {
  const BadRequestException({super.message = 'Bad request', super.statusCode = 400});
}
class NotFoundException extends ApiException {
  const NotFoundException({super.message = 'Not found', super.statusCode = 404});
}
```

See full: `lib/core/network/api_exception.dart`

---

## ApiClient and Centralized Error Mapping

### ApiClient — HTTP client with automatic error conversion

```dart
// lib/core/network/api_client.dart
class ApiClient {
  ApiClient({required Dio dio, required this.errorInterceptor}) : _dio = dio;

  final Dio _dio;
  final ApiErrorInterceptor errorInterceptor;  // Object Function(Object)

  Future<Response<T>> request<T>(String path, ...) async {
    try {
      return await _dio.request<T>(path, ...);
    } catch (err) {
      throw errorInterceptor(err);  // Convert ANY error to ApiException
    }
  }
}
```

**Key points:**
- Datasources use `ApiClient`, NOT `Dio` directly
- `ApiClient` catches ALL errors and passes them through `errorInterceptor`
- Error conversion happens automatically inside ApiClient

---

## Error Flow by Layer

### ApiClient provider

```dart
@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) {
  final Dio dio = ref.watch(dioProvider);
  return ApiClient(
    dio: dio,
    errorInterceptor: ApiExceptionConverter.convert,
  );
}
```

### Datasource — use ApiClient, no error handling

```dart
class HomeRemoteDataSource {
  HomeRemoteDataSource({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;  // NOT Dio!

  Future<List<PostDto>> getPosts() async {
    final Response<List<dynamic>> response = await _apiClient.get(ApiEndpoints.posts);
    // ApiClient already threw ApiException if error occurred
    return (response.data ?? []).map(PostDto.fromJson).toList();
  }
}
```

### Repository — no error handling

```dart
@override
Future<List<Post>> getPosts() async {
  final List<PostDto> dtos = await _remoteDataSource.getPosts();
  // ApiException already thrown by datasource → ApiClient → errorInterceptor
  return dtos.map((PostDto dto) => dto.toDomain()).toList();
}
```

**Special case — signOut:** catches `ApiException` to ignore API errors:

```dart
@override
Future<void> signOut() async {
  try {
    await _remoteDataSource.signOut();
  } on ApiException {
    // Ignore API errors on sign out (server unavailable, etc.)
  } finally {
    await _clearTokens();
    _authStateController.add(false);
  }
}
```

**Why `ApiException` not `Exception`:** Datasource throws `ApiException` for network errors. Catching only `ApiException` ensures other exceptions (e.g., `StateError` from datasource bugs) are not silently ignored.

### Controller -- catch Exception, update state

**Form controller:**

```dart
Future<void> submit() async {
  if (!_validate()) {
    return;
  }
  state = state.copyWith(isLoading: true, error: null);
  try {
    await ref.read(authRepositoryProvider).signIn(
      email: state.email, password: state.password,
    );
  } on Exception catch (e) {
    state = state.copyWith(isLoading: false, error: e);
  }
}
```

**Async list controller:**

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

### Error Localization in Pages (not Controllers)

Controllers store the raw `Exception` object in state -- they never produce user-facing strings. The page maps the exception to a localized message using `context.localizedErrorMessage()`.

**Controller stores typed error:**

```dart
// In controller state — Exception?, not String?
@freezed
abstract class SignInState with _$SignInState {
  const factory SignInState({
    // ...
    Exception? error,      // typed exception, NOT String? errorMessage
  }) = _SignInState;
}

// In controller submit()
try {
  await ref.read(authRepositoryProvider).signIn(...);
} on Exception catch (e) {
  state = state.copyWith(isLoading: false, error: e);  // store raw exception
}
```

**Page maps to localized string:**

```dart
Consumer(
  builder: (BuildContext context, WidgetRef ref, Widget? child) {
    final Exception? error = ref.watch(
      signInControllerProvider.select((SignInState s) => s.error),
    );

    if (error == null) {
      return const SizedBox.shrink();
    }

    return Text(
      context.localizedErrorMessage(error),  // localized here
      style: TextStyle(color: context.theme.colorScheme.error),
    );
  },
),
```

**`context.localizedErrorMessage()`** is defined in `core/extensions/context_ext.dart` and uses `switch` on the `ApiException` sealed class to pick the right translation key from `context.t.common.errors.*`:

| Exception Type | Translation Key |
|---|---|
| `NetworkException` | `common.errors.network` |
| `UnauthorizedException` | `common.errors.unauthorized` |
| `TimeoutException` | `common.errors.timeout` |
| `ServerException` | `common.errors.server` |
| `ApiException` (other) | `e.message` or `common.errors.unknown` |
| `Exception` (fallback) | `common.errors.unknown` |

**Why:** Controllers should not know about UI, localization, or Flutter context. Keeping error mapping in the page layer ensures controllers remain pure business logic and all user-facing strings go through the translation system.

### Page -- reads error from state (never catches)

Form pages read `s.error` via `Consumer` + `.select()` and map to localized text with `context.localizedErrorMessage()`. Async pages use `postsAsync.when(error: ...)`.

See full examples: `lib/features/auth/presentation/pages/sign_in_page.dart`, `lib/features/home/presentation/pages/home_page.dart`

---

## Interceptor-Level Error Handling

The `ApiInterceptor` handles 401 at the Dio level: attempts token refresh, retries request if successful, otherwise forwards errors to `ApiClient`.

`ApiClient` then converts errors to `ApiException` via `ApiExceptionConverter`.

See full: `lib/core/network/api_interceptor.dart`

---

## Adding a New Exception Type

1. Add a new class extending `ApiException` in `lib/core/network/api_exception.dart`
2. Add the mapping case in `ApiExceptionConverter` (see implementation in `lib/core/network/api_exception_converter.dart`)
3. No code generation needed -- `ApiException` is a `sealed class`, not Freezed

**Example:**

```dart
// 1. Add exception class
class ForbiddenException extends ApiException {
  const ForbiddenException({
    super.message = 'Forbidden',
    super.statusCode = 403,
    super.errorCode,
  });
}

// 2. Add mapping in ApiExceptionConverter
// Update the status code handling in ApiExceptionConverter
// to return ForbiddenException for 403 status codes
```

---

## Cross-References

- [Networking](../data-layer/networking.md) -- ApiClient, ApiExceptionConverter, and exception classes
- [Repository Pattern](../data-layer/repository-pattern.md) -- Repository implementations (no error handling needed)
- [Controllers](../presentation/controllers.md) -- Error handling in controller patterns
- [Pages & Widgets](../presentation/pages-and-widgets.md) -- Displaying errors in UI
