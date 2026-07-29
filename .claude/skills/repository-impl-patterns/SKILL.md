---
name: repository-impl-patterns
description: Repository implementation patterns with DTO to domain entity conversion. Auto-loads when implementing repositories or discussing data layer.
user-invocable: false
---

# Repository Implementation Patterns

Repository implementations live in the **data layer** and bridge datasources to domain contracts. They convert DTOs to domain entities. **No error handling** — `ApiException` is already thrown by datasource via `ApiClient`.

## Canonical Template

```dart
import 'package:fandag/features/<feature>/data/datasources/datasources.dart';
import 'package:fandag/features/<feature>/data/models/models.dart';
import 'package:fandag/features/<feature>/domain/domain.dart';

class FeatureRepositoryImpl implements FeatureRepository {
  FeatureRepositoryImpl({required FeatureRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final FeatureRemoteDataSource _remoteDataSource;

  @override
  Future<List<Entity>> getEntities() async {
    final List<EntityDto> dtos = await _remoteDataSource.getEntities();

    return dtos.map((EntityDto dto) => dto.toDomain()).toList();
  }

  @override
  Future<Entity> getEntityById(String id) async {
    final EntityDto dto = await _remoteDataSource.getEntityById(id);

    return dto.toDomain();
  }

  @override
  Future<void> deleteEntity(String id) async {
    await _remoteDataSource.deleteEntity(id);
  }
}
```

**Key points:**
- **No try-catch** — datasource already throws `ApiException` via `ApiClient`
- **No `_mapDioException`** — centralized in `ApiExceptionConverter`
- Clean, simple conversion: DTO → domain entity

## Rules

1. **`implements DomainRepository`** — from domain layer
2. **Constructor injection** — datasource(s) via named parameters, stored as private fields
3. **No try-catch** — `ApiException` already thrown by datasource
4. **`dto.toDomain()`** to convert DTOs to domain entities
5. **Explicit types** for all variables: `final List<EntityDto> dtos = ...`
6. **No imports** of `package:dio/dio.dart` or `core/network/network.dart` (unless using specific exceptions for special cases)

## Real Example — HomeRepositoryImpl

```dart
// lib/features/home/data/repositories/home_repository_impl.dart
import 'package:fandag/features/home/data/datasources/datasources.dart';
import 'package:fandag/features/home/data/models/models.dart';
import 'package:fandag/features/home/domain/domain.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({required HomeRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final HomeRemoteDataSource _remoteDataSource;

  @override
  Future<List<Post>> getPosts() async {
    final List<PostDto> dtos = await _remoteDataSource.getPosts();

    return dtos.map((PostDto dto) => dto.toDomain()).toList();
  }

  @override
  Future<Post> getPost(String id) async {
    final PostDto dto = await _remoteDataSource.getPost(id);

    return dto.toDomain();
  }

  @override
  Future<Post> createPost({required String title, required String body}) async {
    final PostDto dto = await _remoteDataSource.createPost(
      title: title,
      body: body,
    );

    return dto.toDomain();
  }

  @override
  Future<void> deletePost(String id) async {
    await _remoteDataSource.deletePost(id);
  }
}
```

**Notice:** No try-catch, no error handling. ApiException is thrown by datasource → ApiClient → ApiExceptionConverter.

## Special Cases

### Sign Out — Ignore API Errors

```dart
import 'package:fandag/core/network/network.dart';  // for ApiException

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

**Why `ApiException` not `Exception`:** Catching only `ApiException` ensures other exceptions (like `StateError` from datasource bugs) are not silently ignored.

### Multiple Datasources

```dart
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required FlutterSecureStorage secureStorage,
  }) : _remoteDataSource = remoteDataSource,
       _secureStorage = secureStorage;

  final AuthRemoteDataSource _remoteDataSource;
  final FlutterSecureStorage _secureStorage;
}
```

## Barrel File

Add to the sub-barrel `repositories/repositories.dart`:

```dart
// data/repositories/repositories.dart
export 'feature_repository_impl.dart';
```

## Anti-Patterns

```dart
// BAD: unnecessary try-catch
@override
Future<List<Post>> getPosts() async {
  try {
    final List<PostDto> dtos = await _remoteDataSource.getPosts();
    return dtos.map((PostDto dto) => dto.toDomain()).toList();
  } on ApiException {
    rethrow;  // WRONG — ApiException already thrown, no need for try-catch
  }
}

// CORRECT — no try-catch
@override
Future<List<Post>> getPosts() async {
  final List<PostDto> dtos = await _remoteDataSource.getPosts();
  return dtos.map((PostDto dto) => dto.toDomain()).toList();
}

// BAD: returning DTOs from repository
@override
Future<List<PostDto>> getPosts() async {  // WRONG — should be List<Post>
  return _remoteDataSource.getPosts();
}

// BAD: catching DioException (wrong layer)
@override
Future<List<Post>> getPosts() async {
  try {
    ...
  } on DioException catch (e) {  // WRONG — DioException never reaches repository
    throw _mapDioException(e);
  }
}
```
