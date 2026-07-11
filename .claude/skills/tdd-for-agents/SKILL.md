---
name: tdd-for-agents
description: TDD workflow protocol for AI agents. Auto-loads when writing tests or discussing test-driven development.
user-invocable: false
---

# TDD for Agents

Test-driven development workflow adapted for AI agents. Tests are **recommended but not blocking** — write them when time permits.

## RED → GREEN → REFACTOR Cycle

1. **RED** — Write a failing test first
2. **GREEN** — Write minimal code to make it pass
3. **REFACTOR** — Clean up while tests pass

This cycle is optional — agents may write implementation first, then tests. The key is that tests exist.

## Test File Structure

```
test/
├── features/
│   ├── auth/
│   │   ├── domain/
│   │   │   └── entities/
│   │   │       └── user_test.dart
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── user_dto_test.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl_test.dart
│   │   └── presentation/
│   │       └── controllers/
│   │           └── sign_in_controller_test.dart
│   └── home/
│       └── ...
└── core/
    └── network/
        └── dio_provider_test.dart
```

Mirrored structure: `test/` mirrors `lib/`.

## Running Tests

Use the test hook:

```bash
.claude/hooks/test-agent.sh <path>
```

Or directly with fvm:

```bash
fvm flutter test test/features/<feature>/
fvm flutter test test/features/<feature>/domain/
fvm flutter test test/features/<feature>/presentation/controllers/sign_in_controller_test.dart
```

Or use Makefile:

```bash
make test  # Run all tests
```

## Test Templates by Layer

### Entity Tests

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_template_v3/features/<feature>/domain/domain.dart';

void main() {
  group('EntityName', () {
    test('should create with required fields', () {
      final EntityName entity = EntityName(
        id: '1',
        name: 'Test',
      );

      expect(entity.id, '1');
      expect(entity.name, 'Test');
    });

    test('should support equality', () {
      final EntityName entity1 = EntityName(id: '1', name: 'Test');
      final EntityName entity2 = EntityName(id: '1', name: 'Test');

      expect(entity1, equals(entity2));
    });

    test('should support copyWith', () {
      final EntityName original = EntityName(id: '1', name: 'Original');
      final EntityName updated = original.copyWith(name: 'Updated');

      expect(updated.name, 'Updated');
      expect(updated.id, '1');
    });

    test('should handle optional fields', () {
      final EntityName entity = EntityName(
        id: '1',
        name: 'Test',
        // optionalField not provided
      );

      expect(entity.optionalField, isNull);
    });
  });
}
```

### Real Example — Post Entity Test

```dart
// test/features/home/presentation/controllers/home_controller_test.dart
void main() {
  group('Post entity', () {
    test('should create Post with required fields', () {
      final Post post = Post(
        id: '1',
        title: 'Test Post',
        body: 'Test body',
        authorId: 'author-1',
        createdAt: DateTime(2024),
      );

      expect(post.id, '1');
      expect(post.title, 'Test Post');
      expect(post.body, 'Test body');
      expect(post.authorId, 'author-1');
    });

    test('should support copyWith', () {
      final Post post = Post(
        id: '1',
        title: 'Original',
        body: 'Body',
        authorId: 'author-1',
        createdAt: DateTime(2024),
      );
      final Post updated = post.copyWith(title: 'Updated');

      expect(updated.title, 'Updated');
      expect(updated.id, '1');
    });

    test('should support equality', () {
      final DateTime now = DateTime(2024);
      final Post post1 = Post(
        id: '1',
        title: 'Title',
        body: 'Body',
        authorId: 'a',
        createdAt: now,
      );
      final Post post2 = Post(
        id: '1',
        title: 'Title',
        body: 'Body',
        authorId: 'a',
        createdAt: now,
      );

      expect(post1, equals(post2));
    });
  });
}
```

### DTO Tests (fromJson + toDomain)

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_template_v3/features/<feature>/data/data.dart';
import 'package:flutter_template_v3/features/<feature>/domain/domain.dart';

void main() {
  group('EntityDto', () {
    test('should parse from JSON', () {
      final Map<String, dynamic> json = <String, dynamic>{
        'id': '1',
        'name': 'Test',
      };

      final EntityDto dto = EntityDto.fromJson(json);

      expect(dto.id, '1');
      expect(dto.name, 'Test');
    });

    test('should handle @JsonKey field mapping', () {
      final Map<String, dynamic> json = <String, dynamic>{
        'id': '1',
        'full_name': 'John Doe',  // server uses snake_case
      };

      final EntityDto dto = EntityDto.fromJson(json);

      expect(dto.fullName, 'John Doe');
    });

    test('should convert to domain entity', () {
      const EntityDto dto = EntityDto(id: '1', name: 'Test');

      final Entity entity = dto.toDomain();

      expect(entity, isA<Entity>());
      expect(entity.id, '1');
      expect(entity.name, 'Test');
    });

    test('should handle nullable fields in toDomain', () {
      const EntityDto dto = EntityDto(
        id: '1',
        name: 'Test',
        // optionalField not provided
      );

      final Entity entity = dto.toDomain();

      expect(entity.optionalField, isNull);
    });
  });
}
```

### Repository Implementation Tests (mock datasource)

```dart
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_template_v3/core/network/network.dart';
import 'package:flutter_template_v3/features/<feature>/data/data.dart';
import 'package:flutter_template_v3/features/<feature>/domain/domain.dart';

/// Simple manual mock — no mockito dependency needed
class MockFeatureRemoteDataSource implements FeatureRemoteDataSource {
  List<EntityDto> getEntitiesResult = <EntityDto>[];
  Exception? getEntitiesError;

  @override
  Future<List<EntityDto>> getEntities() async {
    final Exception? error = getEntitiesError;
    if (error != null) throw error;

    return getEntitiesResult;
  }
}

void main() {
  group('FeatureRepositoryImpl', () {
    late MockFeatureRemoteDataSource mockDataSource;
    late FeatureRepositoryImpl repository;

    setUp(() {
      mockDataSource = MockFeatureRemoteDataSource();
      repository = FeatureRepositoryImpl(remoteDataSource: mockDataSource);
    });

    test('should return domain entities from datasource DTOs', () async {
      mockDataSource.getEntitiesResult = <EntityDto>[
        const EntityDto(id: '1', name: 'Test'),
      ];

      final List<Entity> result = await repository.getEntities();

      expect(result, hasLength(1));
      expect(result.first, isA<Entity>());
      expect(result.first.id, '1');
    });

    test('should map DioException to TimeoutException', () async {
      mockDataSource.getEntitiesError = DioException(
        type: DioExceptionType.connectionTimeout,
        requestOptions: RequestOptions(),
      );

      expect(
        () => repository.getEntities(),
        throwsA(isA<TimeoutException>()),
      );
    });

    test('should map DioException to NetworkException', () async {
      mockDataSource.getEntitiesError = DioException(
        type: DioExceptionType.connectionError,
        requestOptions: RequestOptions(),
      );

      expect(
        () => repository.getEntities(),
        throwsA(isA<NetworkException>()),
      );
    });

    test('should map 401 to UnauthorizedException', () async {
      mockDataSource.getEntitiesError = DioException(
        type: DioExceptionType.badResponse,
        response: Response<dynamic>(
          statusCode: 401,
          requestOptions: RequestOptions(),
        ),
        requestOptions: RequestOptions(),
      );

      expect(
        () => repository.getEntities(),
        throwsA(isA<UnauthorizedException>()),
      );
    });
  });
}
```

### Controller Tests (Form)

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_template_v3/features/<feature>/presentation/presentation.dart';

void main() {
  group('XController', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state should have empty fields', () {
      final XState state = container.read(xControllerProvider);

      expect(state.field, isEmpty);
      expect(state.isLoading, isFalse);
      expect(state.error, isNull);
    });

    test('setField should update field', () {
      container.read(xControllerProvider.notifier).setField('value');

      final XState state = container.read(xControllerProvider);

      expect(state.field, 'value');
    });

    test('submit with empty fields should set validation errors', () async {
      await container.read(xControllerProvider.notifier).submit();

      final XState state = container.read(xControllerProvider);

      expect(state.fieldError, isNotNull);
    });
  });
}
```

### Real Example — SignInController Test

```dart
// test/features/auth/presentation/controllers/sign_in_controller_test.dart
void main() {
  group('SignInController', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state should have empty fields', () {
      final SignInState state = container.read(signInControllerProvider);

      expect(state.email, isEmpty);
      expect(state.password, isEmpty);
      expect(state.isLoading, isFalse);
      expect(state.error, isNull);
      expect(state.emailError, isNull);
      expect(state.passwordError, isNull);
    });

    test('setEmail should update email', () {
      container
          .read(signInControllerProvider.notifier)
          .setEmail('test@example.com');

      final SignInState state = container.read(signInControllerProvider);

      expect(state.email, 'test@example.com');
    });

    test('submit with empty fields should set validation errors', () async {
      await container.read(signInControllerProvider.notifier).submit();

      final SignInState state = container.read(signInControllerProvider);

      expect(state.emailError, isNotNull);
      expect(state.passwordError, isNotNull);
    });

    test('submit with invalid email should set email error', () async {
      container
          .read(signInControllerProvider.notifier)
          .setEmail('invalid-email');
      container
          .read(signInControllerProvider.notifier)
          .setPassword('password123');

      await container.read(signInControllerProvider.notifier).submit();

      final SignInState state = container.read(signInControllerProvider);

      expect(state.emailError, isNotNull);
      expect(state.passwordError, isNull);
    });
  });
}
```

## Testing Conventions

1. **File naming**: `*_test.dart`
2. **Group by class/feature**: `group('ClassName', () { ... })`
3. **Descriptive test names**: `'should create with required fields'`
4. **`setUp` / `tearDown`** for container lifecycle
5. **Explicit types** on all variables
6. **`package:flutter_template_v3/...`** imports (no relative)
7. **Import from barrels**: `domain.dart`, `presentation.dart`

## What to Test

| Layer | What to Test |
|---|---|
| Entity | Construction, equality, copyWith, optional fields |
| DTO | fromJson, toDomain mapping, @JsonKey handling |
| Repository | Mock datasource → verify toDomain, error mapping |
| Controller | Initial state, setters, validation, submit flow |
