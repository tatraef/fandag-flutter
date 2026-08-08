---
name: repository-patterns
description: Repository interface patterns for domain layer. Auto-loads when creating repository interfaces or discussing domain contracts.
user-invocable: false
---

# Repository Interface Patterns

Repository interfaces define the **contract** between domain and data layers. They live in the domain layer and know nothing about implementation details.

## Canonical Template

```dart
import 'package:fandag/features/<feature>/domain/entities/entities.dart';

abstract class FeatureRepository {
  Future<List<Entity>> getEntities();

  Future<Entity> getEntityById(String id);

  Future<Entity> createEntity({required String name, required String description});

  Future<void> updateEntity({required String id, required String name});

  Future<void> deleteEntity(String id);
}
```

## Rules

1. **`abstract class`** — no implementation, no constructor
2. **Return domain entities** — never DTOs, never raw JSON
3. **No implementation details** — no Dio, no HTTP, no JSON
4. **No imports from data layer** — only domain imports
5. **Use named parameters** for methods with multiple arguments
6. **One repository per bounded context** — usually one per feature

## Real Examples

### AuthRepository

```dart
// lib/features/auth/domain/repositories/auth_repository.dart
abstract class AuthRepository {
  Future<AuthTokens> signIn({required String email, required String password});

  Future<AuthTokens> signUp({
    required String email,
    required String password,
    required String name,
  });

  Future<void> signOut();

  Future<void> recoverPassword({required String email});

  Future<User> getCurrentUser();

  Stream<bool> getAuthState();
}
```

### HomeRepository

```dart
// lib/features/home/domain/repositories/home_repository.dart
abstract class HomeRepository {
  Future<List<Post>> getPosts();

  Future<Post> getPost(String id);

  Future<Post> createPost({required String title, required String body});

  Future<void> deletePost(String id);
}
```

## Stream Support

Use `Stream<T>` for reactive data (auth state, real-time updates):

```dart
abstract class AuthRepository {
  Stream<bool> getAuthState();
  // ...
}
```

## Barrel File

Add to the sub-barrel `repositories/repositories.dart`:

```dart
// domain/repositories/repositories.dart
export 'feature_repository.dart';
```

## Anti-Patterns

```dart
// BAD: returning DTOs — repository interface uses only domain types
abstract class FeatureRepository {
  Future<List<PostDto>> getPosts();  // WRONG — should be List<Post>
}

// BAD: including implementation details
import 'package:dio/dio.dart';  // WRONG — no Dio in domain

abstract class FeatureRepository {
  Future<Response> getPosts();  // WRONG — no Dio types
}

// BAD: too many repositories per feature
// Usually one repository per feature is enough
// Split only when there are clearly separate bounded contexts
```
