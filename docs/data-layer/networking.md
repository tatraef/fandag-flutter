# Networking

Dio provider, API interceptor, endpoint conventions, and datasource patterns.

---

## Rules

### Datasource Rules

- Plain class with `ApiClient` constructor parameter (stored as `_apiClient`)
- Methods return DTOs (never domain entities)
- GET list: `response.data ?? <dynamic>[]` then `.cast<Map<String, dynamic>>().map(XDto.fromJson).toList()`
- GET single: null-check `response.data`, then `XDto.fromJson(data)`
- POST with body: `_apiClient.post<Map<String, dynamic>>(endpoint, data: request.toJson())`
- POST without body: `_apiClient.post<void>(endpoint)`
- DELETE: `_apiClient.delete<void>('$endpoint/$id')`
- **No error handling** -- `ApiClient` automatically converts all errors to `ApiException`
- Use explicit generic types on ApiClient methods: `get<List<dynamic>>`, `post<Map<String, dynamic>>`, `delete<void>`

### ApiClient Key Points

- `ApiClient` wraps `Dio` and provides automatic error conversion to `ApiException`
- `@Riverpod(keepAlive: true)` -- ApiClient is a singleton, never disposed
- `baseUrl` from `ServerConfig` -- supports multiple environments (dev/stage/prod)
- Timeouts from `AppDurations` constants (30 seconds each)
- Three interceptors on underlying Dio: auth token injection, debug inspector, logging

### Endpoint Conventions

- `abstract class ApiEndpoints` -- cannot be instantiated
- `static const String` -- compile-time constants
- Paths are relative to `baseUrl` (no leading domain)
- Kebab-case path segments

---

## Anti-Patterns

### WRONG: Datasource returning domain entity

```dart
// WRONG -- datasource must return DTO, not entity
Future<User> getCurrentUser() async {
  final response = await _apiClient.get<Map<String, dynamic>>(ApiEndpoints.currentUser);

  return User.fromJson(response.data!); // WRONG
}

// CORRECT -- return DTO with null-safe access
Future<UserDto> getCurrentUser() async {
  final Response<Map<String, dynamic>> response = await _apiClient
      .get<Map<String, dynamic>>(ApiEndpoints.currentUser);
  final Map<String, dynamic>? data = response.data;
  if (data == null) {
    throw StateError('Response body is null');
  }

  return UserDto.fromJson(data);
}
```

### WRONG: Catching errors in datasource

```dart
// WRONG -- datasource should NOT handle errors (ApiClient does it automatically)
Future<List<PostDto>> getPosts() async {
  try {
    final response = await _apiClient.get<List<dynamic>>(ApiEndpoints.posts);
    return response.data!.cast<Map<String, dynamic>>().map(PostDto.fromJson).toList();
  } catch (e) {
    // WRONG -- error handling belongs in ApiClient
    throw ApiException();
  }
}

// CORRECT -- no error handling, ApiClient handles it
Future<List<PostDto>> getPosts() async {
  final Response<List<dynamic>> response = await _apiClient.get<List<dynamic>>(
    ApiEndpoints.posts,
  );
  final List<dynamic> data = response.data ?? <dynamic>[];

  return data.cast<Map<String, dynamic>>().map(PostDto.fromJson).toList();
}
```

### WRONG: Missing generic type on ApiClient call

```dart
// WRONG -- no generic type, response.data is dynamic
final response = await _apiClient.get(ApiEndpoints.posts);

// CORRECT -- explicit generic type
final Response<List<dynamic>> response = await _apiClient.get<List<dynamic>>(
  ApiEndpoints.posts,
);
```

### WRONG: Hardcoded URL

```dart
// WRONG -- URL hardcoded in datasource
await _apiClient.get<Map<String, dynamic>>('/api/v1/posts');

// CORRECT -- use ApiEndpoints constant
await _apiClient.get<Map<String, dynamic>>(ApiEndpoints.posts);
```

---

## API Endpoints

```dart
// lib/core/constants/api_endpoints.dart
abstract class ApiEndpoints {
  static const String signIn = '/auth/sign-in';
  static const String signUp = '/auth/sign-up';
  static const String signOut = '/auth/sign-out';
  static const String recoverPassword = '/auth/recover-password';
  static const String refreshToken = '/auth/refresh-token';
  static const String currentUser = '/auth/me';
  static const String posts = '/posts';
}
```

When adding a new endpoint, add a new constant to this class.

---

## API Exceptions

```dart
// lib/core/network/api_exception.dart
sealed class ApiException extends AppException {
  const ApiException({super.message, this.statusCode});
  final int? statusCode;
}

class NetworkException extends ApiException { ... }
class UnauthorizedException extends ApiException { ... }
class ServerException extends ApiException { ... }
class TimeoutException extends ApiException { ... }
class BadRequestException extends ApiException { ... }
class NotFoundException extends ApiException { ... }
```

- `sealed class` -- Dart exhaustive pattern matching on exception types
- Extends `AppException` which implements `Exception`
- Each subclass has sensible defaults for `message` and `statusCode`
- `ApiClient` automatically converts all errors to the appropriate `ApiException` subclass
- Repositories simply propagate `ApiException` from datasources (no error handling needed)

See full: `lib/core/network/api_exception.dart`

---

## ApiClient Provider

The provider creates `ApiClient` with underlying `Dio` configured with base URL, timeouts, and interceptors:

```dart
// lib/core/network/dio_provider.dart
@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) {
  final Dio dio = ref.watch(dioProvider);

  return ApiClient(
    dio: dio,
    errorInterceptor: ApiExceptionConverter.convert,
  );
}
```

The underlying `Dio` is configured separately:

```dart
// lib/core/network/dio_provider.dart
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final FlutterSecureStorage secureStorage = ref.watch(secureStorageProvider);

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: ServerConfig.getCurrentServerUrl(),
      connectTimeout: AppDurations.connectionTimeout,
      receiveTimeout: AppDurations.receiveTimeout,
      sendTimeout: AppDurations.sendTimeout,
    ),
  );

  dio.interceptors.addAll(<Interceptor>[
    ApiInterceptor(secureStorage: secureStorage),
    if (isInspectorOnDebugMode) MadDioModule.interceptor,
    LogInterceptor(requestBody: true, responseBody: true),
  ]);

  return dio;
}
```

See full: `lib/core/network/api_client.dart`, `lib/core/network/dio_provider.dart`

---

## API Interceptor

Handles auth token injection and 401 token refresh:

1. `onRequest` -- reads access token from secure storage, adds `Authorization: Bearer <token>` header
2. `onError` -- on 401, attempts token refresh; if successful, retries the original request
3. `_refreshToken` -- reads refresh token from secure storage and calls the refresh endpoint

See full: `lib/core/network/api_interceptor.dart`

---

## Datasource Pattern

```dart
// lib/features/home/data/datasources/home_remote_datasource.dart
class HomeRemoteDataSource {
  HomeRemoteDataSource({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<List<PostDto>> getPosts() async {
    final Response<List<dynamic>> response = await _apiClient.get<List<dynamic>>(
      ApiEndpoints.posts,
    );
    final List<dynamic> data = response.data ?? <dynamic>[];

    return data.cast<Map<String, dynamic>>().map(PostDto.fromJson).toList();
  }

  Future<PostDto> getPost(String id) async {
    final Response<Map<String, dynamic>> response = await _apiClient
        .get<Map<String, dynamic>>('${ApiEndpoints.posts}/$id');
    final Map<String, dynamic>? data = response.data;
    if (data == null) {
      throw StateError('Response body is null');
    }

    return PostDto.fromJson(data);
  }
}
```

See full: `lib/features/home/data/datasources/home_remote_datasource.dart`, `lib/features/auth/data/datasources/auth_remote_datasource.dart`

---

## Adding a New API Call

1. Add endpoint to `ApiEndpoints` in `lib/core/constants/api_endpoints.dart`
2. Create request DTO if POST/PUT body needed (see [DTO Mapping](dto-mapping.md))
3. Add method to datasource class (using `ApiClient`)
4. Add method to repository interface (domain)
5. Implement in repository impl (data) — no error handling needed, just call datasource and map DTO to entity
6. Run `make gen` if new DTOs were added

---

## Cross-References

- [DTO Mapping](dto-mapping.md) -- Request/response DTO structure
- [Repository Pattern](repository-pattern.md) -- Error mapping in repository impl
- [Error Handling](../architecture/error-handling.md) -- Full exception hierarchy
- [Storage](storage.md) -- SecureStorage used by interceptor
