---
name: datasource-patterns
description: Remote datasource patterns with ApiClient (automatic error conversion). Auto-loads when creating datasources, API calls, or discussing networking.
user-invocable: false
---

# Datasource Patterns

Remote datasources are **plain classes** with ApiClient injection. They return DTOs and do NOT handle errors (ApiClient automatically converts DioException to ApiException).

## Canonical Template

```dart
import 'package:dio/dio.dart';
import 'package:fandag/core/constants/constants.dart';
import 'package:fandag/core/network/network.dart';
import 'package:fandag/features/<feature>/data/models/models.dart';

class FeatureRemoteDataSource {
  FeatureRemoteDataSource({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  /// GET list
  Future<List<EntityDto>> getEntities() async {
    final Response<List<dynamic>> response = await _apiClient.get<List<dynamic>>(
      ApiEndpoints.entities,
    );
    final List<dynamic> data = response.data ?? <dynamic>[];

    return data
        .cast<Map<String, dynamic>>()
        .map(EntityDto.fromJson)
        .toList();
  }

  /// GET single
  Future<EntityDto> getEntity(String id) async {
    final Response<Map<String, dynamic>> response = await _apiClient
        .get<Map<String, dynamic>>('${ApiEndpoints.entities}/$id');
    final Map<String, dynamic>? data = response.data;
    if (data == null) {
      throw StateError('Response body is null');
    }

    return EntityDto.fromJson(data);
  }

  /// POST with request DTO
  Future<EntityDto> createEntity(CreateEntityRequest request) async {
    final Response<Map<String, dynamic>> response = await _apiClient
        .post<Map<String, dynamic>>(
          ApiEndpoints.entities,
          data: request.toJson(),
        );
    final Map<String, dynamic>? data = response.data;
    if (data == null) {
      throw StateError('Response body is null');
    }

    return EntityDto.fromJson(data);
  }

  /// POST with inline data
  Future<EntityDto> createEntity({
    required String title,
    required String body,
  }) async {
    final Response<Map<String, dynamic>> response = await _apiClient
        .post<Map<String, dynamic>>(
          ApiEndpoints.entities,
          data: <String, dynamic>{'title': title, 'body': body},
        );
    final Map<String, dynamic>? data = response.data;
    if (data == null) {
      throw StateError('Response body is null');
    }

    return EntityDto.fromJson(data);
  }

  /// DELETE
  Future<void> deleteEntity(String id) async {
    await _apiClient.delete<void>('${ApiEndpoints.entities}/$id');
  }

  /// POST void (no response body)
  Future<void> doAction({required String email}) async {
    await _apiClient.post<void>(
      ApiEndpoints.action,
      data: <String, dynamic>{'email': email},
    );
  }
}
```

## Rules

1. **Plain class** — no annotations, no code generation
2. **Constructor**: `{required ApiClient apiClient}` → stored as `final ApiClient _apiClient`
3. **Return DTOs** — never domain entities
4. **Explicit generic types** on ApiClient calls: `get<List<dynamic>>`, `post<Map<String, dynamic>>`, `delete<void>`
5. **No error handling** — `ApiClient` automatically converts `DioException` to `ApiException`
6. **Use `ApiEndpoints`** constants — never hardcode URLs
7. **No `!` (bang operator)** — use null-safe access:
   - Lists: `response.data ?? <dynamic>[]`
   - Single objects: null-check + `throw StateError('Response body is null')`
8. **Import**: Always add `import 'package:fandag/core/network/network.dart';` for `ApiClient`

## HTTP Method Patterns

### GET List

```dart
Future<List<EntityDto>> getEntities() async {
  final Response<List<dynamic>> response = await _apiClient.get<List<dynamic>>(
    ApiEndpoints.entities,
  );
  final List<dynamic> data = response.data ?? <dynamic>[];

  return data
      .cast<Map<String, dynamic>>()
      .map(EntityDto.fromJson)
      .toList();
}
```

### GET Single

```dart
Future<EntityDto> getEntity(String id) async {
  final Response<Map<String, dynamic>> response = await _apiClient
      .get<Map<String, dynamic>>('${ApiEndpoints.entities}/$id');
  final Map<String, dynamic>? data = response.data;
  if (data == null) {
    throw StateError('Response body is null');
  }

  return EntityDto.fromJson(data);
}
```

### POST with Request DTO

```dart
Future<AuthTokensDto> signIn(SignInRequest request) async {
  final Response<Map<String, dynamic>> response = await _apiClient
      .post<Map<String, dynamic>>(
        ApiEndpoints.signIn,
        data: request.toJson(),
      );
  final Map<String, dynamic>? data = response.data;
  if (data == null) {
    throw StateError('Response body is null');
  }

  return AuthTokensDto.fromJson(data);
}
```

### POST void

```dart
Future<void> signOut() async {
  await _apiClient.post<void>(ApiEndpoints.signOut);
}
```

### DELETE

```dart
Future<void> deleteEntity(String id) async {
  await _apiClient.delete<void>('${ApiEndpoints.entities}/$id');
}
```

## Real Examples

### AuthRemoteDataSource

```dart
// lib/features/auth/data/datasources/auth_remote_datasource.dart
class AuthRemoteDataSource {
  AuthRemoteDataSource({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<AuthTokensDto> signIn(SignInRequest request) async {
    final Response<Map<String, dynamic>> response = await _apiClient
        .post<Map<String, dynamic>>(
          ApiEndpoints.signIn,
          data: request.toJson(),
        );
    final Map<String, dynamic>? data = response.data;
    if (data == null) {
      throw StateError('Response body is null');
    }

    return AuthTokensDto.fromJson(data);
  }

  Future<void> signOut() async {
    await _apiClient.post<void>(ApiEndpoints.signOut);
  }

  Future<UserDto> getCurrentUser() async {
    final Response<Map<String, dynamic>> response = await _apiClient
        .get<Map<String, dynamic>>(ApiEndpoints.currentUser);
    final Map<String, dynamic>? data = response.data;
    if (data == null) {
      throw StateError('Response body is null');
    }

    return UserDto.fromJson(data);
  }
}
```

### HomeRemoteDataSource

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

  Future<PostDto> createPost({
    required String title,
    required String body,
  }) async {
    final Response<Map<String, dynamic>> response = await _apiClient
        .post<Map<String, dynamic>>(
          ApiEndpoints.posts,
          data: <String, dynamic>{'title': title, 'body': body},
        );
    final Map<String, dynamic>? data = response.data;
    if (data == null) {
      throw StateError('Response body is null');
    }

    return PostDto.fromJson(data);
  }

  Future<void> deletePost(String id) async {
    await _apiClient.delete<void>('${ApiEndpoints.posts}/$id');
  }
}
```

## API Endpoints

Add new endpoints to `lib/core/constants/api_endpoints.dart`:

```dart
abstract class ApiEndpoints {
  static const String signIn = '/auth/sign-in';
  static const String posts = '/posts';
  // Add new endpoints here
}
```

## Barrel File

Add to the sub-barrel `datasources/datasources.dart`:

```dart
// data/datasources/datasources.dart
export 'feature_remote_datasource.dart';
```

## Anti-Patterns

```dart
// BAD: error handling in datasource — ApiClient already converts errors
Future<List<PostDto>> getPosts() async {
  try {
    final response = await _apiClient.get(...);
    return ...;
  } on DioException catch (e) {  // WRONG — ApiClient automatically converts to ApiException
    throw ApiExceptionConverter.convert(e);  // WRONG — mapping belongs in ApiClient
  }
}

// BAD: returning domain entities
Future<List<Post>> getPosts() async {  // WRONG — should be List<PostDto>
  ...
}

// BAD: missing explicit generic types
final response = await _apiClient.get(ApiEndpoints.posts);  // WRONG — no generic type
// CORRECT: await _apiClient.get<List<dynamic>>(...)

// BAD: hardcoded URLs
await _apiClient.get('/api/v1/posts');  // WRONG — use ApiEndpoints.posts

// BAD: using Retrofit annotations
@GET('/posts')  // WRONG — this project uses plain ApiClient (wraps Dio)
Future<List<PostDto>> getPosts();

// BAD: bang operator on response.data
return EntityDto.fromJson(response.data!);  // WRONG — use null-check
// CORRECT:
// final Map<String, dynamic>? data = response.data;
// if (data == null) throw StateError('Response body is null');
// return EntityDto.fromJson(data);
```
