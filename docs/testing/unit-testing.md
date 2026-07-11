# Unit Testing — Flutter Template v3

Unit tests verify individual functions, classes, and business logic in isolation. This is the foundation of our testing pyramid.

## General Principles

1. **Test in isolation** - Mock all dependencies
2. **One concept per test** - Each test should verify one thing
3. **AAA pattern** - Arrange, Act, Assert
4. **Descriptive names** - Test names should describe the scenario
5. **Fast execution** - Unit tests should be fast (< 100ms each)

## Testing by Layer

### 1. Domain Layer Tests

Domain entities are the simplest to test since they have no external dependencies.

#### Entity Tests

**What to test:**
- Creation with all fields
- Freezed features (copyWith, equality, toString)
- Immutability
- Edge cases (empty values, special characters)

**Example:**

```dart
import 'package:flutter_template_v3/features/home/domain/entities/post.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Post entity', () {
    test('should create Post with all required fields', () {
      // Arrange & Act
      final Post post = Post(
        id: '1',
        title: 'Test Post',
        body: 'Test body',
        authorId: 'author-1',
        createdAt: DateTime(2024),
      );

      // Assert
      expect(post.id, '1');
      expect(post.title, 'Test Post');
    });

    test('should support copyWith', () {
      // Arrange
      final Post post = Post(
        id: '1',
        title: 'Original',
        body: 'Body',
        authorId: 'author-1',
        createdAt: DateTime(2024),
      );

      // Act
      final Post updated = post.copyWith(title: 'Updated');

      // Assert
      expect(updated.title, 'Updated');
      expect(updated.id, post.id);
    });

    test('should support equality', () {
      // Arrange
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

      // Assert
      expect(post1, equals(post2));
    });
  });
}
```

**File:** `test/features/home/domain/entities/post_test.dart`

### 2. Data Layer Tests

Data layer tests verify DTOs, datasources, and repositories.

#### DTO Tests

**What to test:**
- JSON serialization (fromJson, toJson)
- Domain conversion (toDomain)
- All fields are mapped correctly
- Edge cases (null values, missing fields)

**Example:**

```dart
import 'package:flutter_template_v3/features/home/data/models/models.dart';
import 'package:flutter_template_v3/features/home/domain/entities/entities.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PostDto', () {
    test('should create PostDto from valid JSON', () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        'id': '1',
        'title': 'Test Post',
        'body': 'Test body',
        'authorId': 'author-123',
        'createdAt': '2024-01-01T10:00:00.000Z',
      };

      // Act
      final PostDto dto = PostDto.fromJson(json);

      // Assert
      expect(dto.id, '1');
      expect(dto.title, 'Test Post');
    });

    test('should convert PostDto to Post entity', () {
      // Arrange
      final PostDto dto = PostDto(
        id: '1',
        title: 'Test',
        body: 'Body',
        authorId: 'author',
        createdAt: DateTime(2024),
      );

      // Act
      final Post entity = dto.toDomain();

      // Assert
      expect(entity, isA<Post>());
      expect(entity.id, dto.id);
      expect(entity.title, dto.title);
    });
  });
}
```

**File:** `test/features/home/data/models/post_dto_test.dart`

#### Datasource Tests

**What to test:**
- Successful API calls return correct DTOs
- Error handling (network errors, timeouts)
- Correct HTTP methods and endpoints
- Request body/headers are correct

**Setup:**

```dart
import 'package:flutter_template_v3/core/constants/constants.dart';
import 'package:flutter_template_v3/core/network/network.dart';
import 'package:flutter_template_v3/features/home/data/datasources/home_remote_datasource.dart';
import 'package:flutter_template_v3/features/home/data/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late HomeRemoteDataSource dataSource;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = HomeRemoteDataSource(apiClient: mockApiClient);
  });

  // Tests...
}
```

**Example:**

```dart
test('should return list of PostDto when API call succeeds', () async {
  // Arrange
  final List<Map<String, dynamic>> responseData = [
    {
      'id': '1',
      'title': 'Post 1',
      'body': 'Body 1',
      'author_id': 'author-1',
      'created_at': '2024-01-01T10:00:00.000Z',
    },
  ];

  when(() => mockApiClient.get<List<dynamic>>(ApiEndpoints.posts))
      .thenAnswer((_) async => Response<List<dynamic>>(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ApiEndpoints.posts),
          ));

  // Act
  final List<PostDto> result = await dataSource.getPosts();

  // Assert
  expect(result, hasLength(1));
  expect(result[0].id, '1');
  verify(() => mockApiClient.get<List<dynamic>>(ApiEndpoints.posts)).called(1);
});
```

**File:** `test/features/home/data/datasources/home_remote_datasource_test.dart`

#### Repository Implementation Tests

**What to test:**
- Calls datasource correctly
- Maps DTOs to entities
- Propagates `ApiException` from datasource
- All repository methods

**Setup:**

```dart
import 'package:flutter_template_v3/core/network/network.dart';
import 'package:flutter_template_v3/features/home/data/datasources/home_remote_datasource.dart';
import 'package:flutter_template_v3/features/home/data/models/models.dart';
import 'package:flutter_template_v3/features/home/data/repositories/home_repository_impl.dart';
import 'package:flutter_template_v3/features/home/domain/entities/entities.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeRemoteDataSource extends Mock implements HomeRemoteDataSource {}

void main() {
  late MockHomeRemoteDataSource mockDataSource;
  late HomeRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockHomeRemoteDataSource();
    repository = HomeRepositoryImpl(remoteDataSource: mockDataSource);
  });

  // Tests...
}
```

**Example:**

```dart
test('should return list of Post entities from datasource', () async {
  // Arrange
  final List<PostDto> dtos = [
    PostDto(
      id: '1',
      title: 'Post 1',
      body: 'Body 1',
      authorId: 'author-1',
      createdAt: DateTime(2024),
    ),
  ];

  when(() => mockDataSource.getPosts()).thenAnswer((_) async => dtos);

  // Act
  final List<Post> result = await repository.getPosts();

  // Assert
  expect(result, hasLength(1));
  expect(result[0], isA<Post>());
  expect(result[0].id, '1');
  verify(() => mockDataSource.getPosts()).called(1);
});

test('should propagate NetworkException from datasource', () async {
  // Arrange
  when(() => mockDataSource.getPosts()).thenThrow(
    const NetworkException(),
  );

  // Act & Assert
  expect(
    () => repository.getPosts(),
    throwsA(isA<NetworkException>()),
  );
});
```

**File:** `test/features/home/data/repositories/home_repository_impl_test.dart`

### 3. Presentation Layer Tests

#### Controller Tests

**What to test:**
- Initial state
- State updates on actions
- Error handling
- Calls repository correctly

**Setup:**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/helpers.dart';

void main() {
  late MockHomeRepository mockRepository;
  late ProviderContainer container;

  setUp(() {
    mockRepository = MockHomeRepository();
    container = createContainer(
      overrides: [
        homeRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  // Tests...
}
```

**Example:**

```dart
test('should load posts on initialization', () async {
  // Arrange
  final List<Post> expectedPosts = [
    Post(
      id: '1',
      title: 'Post 1',
      body: 'Body 1',
      authorId: 'author-1',
      createdAt: DateTime(2024),
    ),
  ];

  when(() => mockRepository.getPosts())
      .thenAnswer((_) async => expectedPosts);

  // Act
  final AsyncValue<List<Post>> state =
      await container.read(homeControllerProvider.future);

  // Assert
  expect(state, expectedPosts);
  verify(() => mockRepository.getPosts()).called(1);
});
```

**File:** `test/features/home/presentation/controllers/home_controller_test.dart`

## Common Patterns

### Testing Async Code

```dart
test('should handle async operations', () async {
  // Arrange
  when(() => mockRepository.getData()).thenAnswer(
    (_) async => Future<Data>.delayed(
      const Duration(milliseconds: 100),
      () => testData,
    ),
  );

  // Act
  final result = await repository.getData();

  // Assert
  expect(result, testData);
});
```

### Testing Errors

```dart
test('should throw exception on error', () async {
  // Arrange
  when(() => mockRepository.getData()).thenThrow(Exception('Error'));

  // Act & Assert
  expect(
    () => repository.getData(),
    throwsA(isA<Exception>()),
  );
});
```

### Testing Void Methods

```dart
test('should call method successfully', () async {
  // Arrange
  when(() => mockRepository.deleteData('1'))
      .thenAnswer((_) async => Future<void>.value());

  // Act
  await repository.deleteData('1');

  // Assert
  verify(() => mockRepository.deleteData('1')).called(1);
});
```

## Best Practices

1. **Use descriptive test names** - `should return posts when API call succeeds`
2. **One assertion per test** - Focus on one behavior
3. **Mock all dependencies** - Don't let tests depend on external systems
4. **Use const constructors** - For immutable test data
5. **Group related tests** - Use `group()` for organization
6. **Clean up resources** - Use `setUp()` and `tearDown()`
7. **Test edge cases** - Empty lists, null values, errors

## Common Matchers

```dart
expect(value, isTrue);
expect(value, isFalse);
expect(value, isNull);
expect(value, isNotNull);
expect(value, isEmpty);
expect(value, isNotEmpty);
expect(value, equals(expected));
expect(value, isA<Type>());
expect(list, hasLength(3));
expect(list, contains(item));
expect(() => fn(), throwsA(isA<Exception>()));
```

## Running Unit Tests

```bash
# All unit tests
make test-unit

# Specific file
fvm flutter test test/features/home/domain/entities/post_test.dart

# With coverage
make test-coverage
```
