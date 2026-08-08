# Testing Best Practices — Fandag

This document outlines testing conventions, patterns, and best practices for Fandag.

## General Principles

### 1. Test Pyramid

Follow the test pyramid ratio:
- **70% Unit Tests** - Fast, isolated, test business logic
- **20% Widget Tests** - Test UI components and interactions
- **10% Integration Tests** - Test critical user flows

### 2. AAA Pattern

Structure all tests with **Arrange-Act-Assert**:

```dart
test('description', () {
  // Arrange - Set up test data and mocks
  final data = TestData();
  when(() => mock.method()).thenReturn(data);

  // Act - Execute the code under test
  final result = systemUnderTest.method();

  // Assert - Verify the result
  expect(result, equals(expected));
});
```

### 3. One Concept Per Test

Each test should verify one behavior:

```dart
// ❌ Bad - tests multiple concepts
test('controller works correctly', () {
  expect(controller.state.isLoading, isFalse);
  expect(controller.state.data, isEmpty);
  expect(controller.state.error, isNull);
  controller.load();
  expect(controller.state.isLoading, isTrue);
});

// ✅ Good - focused tests
test('initial state should not be loading', () {
  expect(controller.state.isLoading, isFalse);
});

test('should set loading state when load is called', () {
  controller.load();
  expect(controller.state.isLoading, isTrue);
});
```

## Naming Conventions

### Test Files

- Mirror the source file structure
- Use `_test.dart` suffix
- Example: `home_controller.dart` → `home_controller_test.dart`

### Test Names

Use descriptive names that explain the scenario:

```dart
// ✅ Good - describes what and when
test('should return posts when API call succeeds', () { });
test('should throw NetworkException when connection fails', () { });
test('should validate email format on submit', () { });

// ❌ Bad - vague or unclear
test('test posts', () { });
test('error case', () { });
test('validation', () { });
```

### Pattern: "should [action] when [condition]"

```dart
test('should load posts when initialized', () { });
test('should show error when network fails', () { });
test('should validate email when form is submitted', () { });
```

## Test Organization

### Use Groups

Group related tests for better organization:

```dart
void main() {
  group('PostDto', () {
    group('fromJson', () {
      test('should parse valid JSON', () { });
      test('should handle missing fields', () { });
    });

    group('toDomain', () {
      test('should convert to entity', () { });
      test('should preserve all fields', () { });
    });
  });
}
```

### setUp and tearDown

Use for common initialization and cleanup:

```dart
void main() {
  late MockRepository mockRepository;
  late ProviderContainer container;

  setUp(() {
    mockRepository = MockRepository();
    container = createContainer(
      overrides: [
        repositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  // Tests...
}
```

## Mocking

### Use Mocktail

We use **mocktail** for mocking (not mockito):

```dart
import 'package:mocktail/mocktail.dart';

class MockRepository extends Mock implements HomeRepository {}

void main() {
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
  });

  test('should call repository', () {
    // Arrange
    when(() => mockRepository.getData()).thenAnswer((_) async => data);

    // Act
    final result = await service.getData();

    // Assert
    verify(() => mockRepository.getData()).called(1);
  });
}
```

### Register Fallback Values

For complex types, register fallbacks:

```dart
setUpAll(() {
  registerFallbackValue(RequestOptions(path: ''));
  registerFallbackValue(User(id: '', name: ''));
});
```

### Verify Interactions

```dart
// Verify method was called
verify(() => mock.method()).called(1);

// Verify method was not called
verifyNever(() => mock.method());

// Verify call order
verifyInOrder([
  () => mock.method1(),
  () => mock.method2(),
]);
```

## Testing Async Code

### Use async/await

```dart
test('should handle async operations', () async {
  // Arrange
  when(() => mock.getData()).thenAnswer((_) async => data);

  // Act
  final result = await service.getData();

  // Assert
  expect(result, data);
});
```

### Test Error Cases

```dart
test('should throw exception on error', () async {
  // Arrange
  when(() => mock.getData()).thenThrow(Exception('Error'));

  // Act & Assert
  expect(
    () => service.getData(),
    throwsA(isA<Exception>()),
  );
});
```

## Testing Riverpod Providers

### Override Providers

```dart
test('should read provider value', () {
  final container = createContainer(
    overrides: [
      myProvider.overrideWithValue(mockValue),
    ],
  );

  final value = container.read(myProvider);

  expect(value, mockValue);
});
```

### Test Provider Dependencies

```dart
test('should depend on other providers', () {
  final container = createContainer(
    overrides: [
      dioProvider.overrideWithValue(mockDio),
    ],
  );

  final dataSource = container.read(dataSourceProvider);

  expect(dataSource, isA<DataSource>());
});
```

## Test Data

### Use Const Constructors

```dart
// ✅ Good
const testPost = Post(
  id: '1',
  title: 'Test',
  body: 'Body',
  authorId: 'author',
  createdAt: DateTime(2024),
);

// ❌ Bad
final testPost = Post(
  id: '1',
  title: 'Test',
  body: 'Body',
  authorId: 'author',
  createdAt: DateTime(2024),
);
```

### Factory Functions

For complex setup, use factory functions:

```dart
Post createTestPost({
  String id = '1',
  String title = 'Test Post',
  String body = 'Test Body',
}) {
  return Post(
    id: id,
    title: title,
    body: body,
    authorId: 'author-1',
    createdAt: DateTime(2024),
  );
}

// Usage
test('should process post', () {
  final post = createTestPost(title: 'Custom Title');
  // ...
});
```

## Code Coverage

### Target Coverage

Aim for:
- **80%+ overall**
- **90%+ domain layer**
- **85%+ data layer**
- **70%+ presentation layer**

### Generate Coverage Report

```bash
make test-coverage
# or
fvm flutter test --coverage
```

View coverage:
```bash
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Don't Chase 100%

Some code is not worth testing:
- Generated files (`*.g.dart`, `*.freezed.dart`)
- Simple getters/setters
- UI layout code
- Main entry points

## Common Matchers

```dart
// Equality
expect(value, equals(expected));
expect(value, isNot(equals(other)));

// Type checking
expect(value, isA<MyType>());
expect(value, isNotA<OtherType>());

// Booleans
expect(value, isTrue);
expect(value, isFalse);

// Null checking
expect(value, isNull);
expect(value, isNotNull);

// Collections
expect(list, isEmpty);
expect(list, isNotEmpty);
expect(list, hasLength(3));
expect(list, contains(item));
expect(list, containsAll([item1, item2]));

// Ranges
expect(value, greaterThan(10));
expect(value, lessThan(100));
expect(value, inRange(10, 100));

// Strings
expect(text, startsWith('Hello'));
expect(text, endsWith('World'));
expect(text, contains('middle'));

// Exceptions
expect(() => fn(), throwsException);
expect(() => fn(), throwsA(isA<MyException>()));
```

## Widget Test Best Practices

### 1. Test User-Visible Behavior

```dart
// ✅ Good - tests what user sees
expect(find.text('Welcome'), findsOneWidget);
expect(find.byIcon(Icons.add), findsOneWidget);

// ❌ Bad - tests implementation
expect(find.byType(Column), findsOneWidget);
expect(find.byType(Container), findsWidgets);
```

### 2. Use Semantic Finders

```dart
// ✅ Good - semantic and maintainable
expect(find.text('Submit'), findsOneWidget);
expect(find.byIcon(Icons.check), findsOneWidget);

// ❌ Bad - fragile
expect(find.byKey(const Key('button-3')), findsOneWidget);
```

### 3. Always Pump After Actions

```dart
// ✅ Good
await tester.tap(find.text('Button'));
await tester.pumpAndSettle();
expect(find.text('Success'), findsOneWidget);

// ❌ Bad - state not updated
await tester.tap(find.text('Button'));
expect(find.text('Success'), findsOneWidget); // Might fail
```

## Integration Test Best Practices

### 1. Test Critical Flows Only

Integration tests are slow and brittle. Test only:
- Sign-in/sign-up
- Checkout/payment
- Core features

### 2. Use Helper Functions

```dart
Future<void> signIn(WidgetTester tester) async {
  await tester.enterText(find.byKey(emailKey), 'test@example.com');
  await tester.enterText(find.byKey(passwordKey), 'password');
  await tester.tap(find.text('Sign In'));
  await tester.pumpAndSettle();
}
```

### 3. Mock External Dependencies

Don't rely on real APIs in integration tests.

## Performance

### 1. Keep Tests Fast

- Unit tests: < 100ms each
- Widget tests: < 500ms each
- Integration tests: < 5s each

### 2. Avoid Unnecessary setUp

```dart
// ❌ Bad - recreates data for every test
setUp(() {
  heavyTestData = createHeavyData();
});

// ✅ Good - creates once
setUpAll(() {
  heavyTestData = createHeavyData();
});
```

### 3. Use setUpAll for Expensive Operations

```dart
setUpAll(() {
  // Runs once before all tests
  setupMockFallbacks();
  registerFallbackValue(...);
});

setUp(() {
  // Runs before each test
  mockRepository = MockRepository();
});
```

## Code Style in Tests

### Always Specify Types

The project uses `always_specify_types` lint rule. **All variables in tests must have explicit types:**

```dart
// ✅ Good - explicit types
final List<Post> posts = <Post>[createTestPost()];
final ProviderContainer container = createContainer();
final MockRepository mockRepository = MockRepository();

// ❌ Bad - implicit types
final posts = [createTestPost()];
final container = createContainer();
var mockRepository = MockRepository();
```

### JSON Field Naming

Generated DTOs use **snake_case** for JSON serialization:

```dart
// ✅ Good - snake_case keys
final Map<String, dynamic> json = <String, dynamic>{
  'author_id': 'author-1',
  'created_at': '2024-01-01T10:00:00.000Z',
  'avatar_url': 'https://example.com/avatar.jpg',
};

// ❌ Bad - camelCase keys (will fail)
final json = {
  'authorId': 'author-1',
  'createdAt': '2024-01-01T10:00:00.000Z',
  'avatarUrl': 'https://example.com/avatar.jpg',
};
```

**Check generated `*.g.dart` files** to see actual JSON field names used by `json_serializable`.

### Import Order

Follow Dart conventions:

```dart
// 1. Dart SDK imports
import 'package:flutter/material.dart';

// 2. Third-party package imports
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

// 3. Project imports
import 'package:fandag/core/network/network.dart';
import 'package:fandag/features/home/domain/domain.dart';

// 4. Test helper imports (relative imports OK in tests)
import '../../../helpers/helpers.dart';
```

## Helper Files and Analyzer

### Known Analyzer Limitations

Test helper files that use Riverpod types (`Override`, `ProviderListenable`) may show false-positive analyzer errors when analyzed in isolation, even though they compile and work correctly.

**Solution:** Add `// ignore_for_file` comments at the top:

```dart
// ignore_for_file: non_type_as_type_argument, undefined_class

import 'package:flutter_riverpod/flutter_riverpod.dart';

ProviderContainer createContainer({
  List<Override> overrides = const <Override>[],
  // ...
}) {
  // ...
}
```

### Theme Imports in Tests

**Use functions, not classes:**

```dart
// ✅ Good - import theme functions
import 'package:fandag/core/theme/theme.dart';

await tester.pumpWidget(
  MaterialApp(
    theme: lightTheme(),  // Function call
    // ...
  ),
);

// ❌ Bad - AppTheme class doesn't exist
theme: AppTheme.lightTheme,  // Will fail
```

The `theme.dart` barrel exports:
- `lightTheme()` - returns `ThemeData`
- `darkTheme()` - returns `ThemeData`
- `AppThemeData` - theme configuration class

### Explicit Type Arguments

Always provide explicit type arguments for const collections:

```dart
// ✅ Good - explicit type argument
List<Override> overrides = const <Override>[]

// ❌ Bad - implicit type (analyzer error)
List<Override> overrides = const []
```

### Widget Test Helpers

When creating widget test helpers with `pumpApp()` or similar:

```dart
// ✅ Good - explicit types
extension WidgetTesterX on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    List<Override> overrides = const <Override>[],  // Explicit type argument
    ThemeData? theme,
    Locale locale = const Locale('en'),
  }) async {
    await pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: MaterialApp(
          theme: theme ?? lightTheme(),  // Use function
          // ...
        ),
      ),
    );
  }
}
```

## Analyzer Compliance

### Before Committing

Ensure all code passes analyzer:

```bash
# Run analyzer
make analyze

# Should output: "No issues found!"
```

### Common Analyzer Issues in Tests

1. **Missing type annotations** - Add explicit types everywhere
2. **JSON field naming** - Use snake_case (check `*.g.dart`)
3. **Import ordering** - dart → package → project → test helpers
4. **Const constructors** - Use `const` where possible
5. **Helper file errors** - Add `// ignore_for_file` if false positive

### Fixing Analyzer Errors

**Step 1:** Run analyzer on specific test:
```bash
fvm flutter analyze test/path/to/file_test.dart
```

**Step 2:** Fix issues:
- Add explicit types
- Fix JSON keys
- Reorder imports
- Add const where needed

**Step 3:** Verify all tests still pass:
```bash
make test
```

## Anti-Patterns

### ❌ Don't: Test Private Methods

```dart
// Bad - tests internal implementation
test('_privateMethod works', () {
  expect(myClass._privateMethod(), true);
});

// Good - test public API
test('publicMethod produces correct result', () {
  expect(myClass.publicMethod(), expected);
});
```

### ❌ Don't: Use Sleep

```dart
// Bad - brittle and slow
await Future.delayed(const Duration(seconds: 2));
expect(find.text('Loaded'), findsOneWidget);

// Good - wait for condition
await tester.pumpAndSettle();
```

### ❌ Don't: Depend on Test Order

```dart
// Bad - tests depend on each other
test('create user', () {
  userId = createUser();
});

test('update user', () {
  updateUser(userId); // Depends on previous test
});

// Good - independent tests
test('should update user', () {
  final userId = createUser();
  updateUser(userId);
  // ...
});
```

### ❌ Don't: Over-Mock

```dart
// Bad - mocks too much
final mockString = MockString();
when(() => mockString.isEmpty).thenReturn(true);

// Good - use real objects when simple
final string = '';
expect(string.isEmpty, isTrue);
```

## Test Checklist

Before committing code, ensure:

- [ ] All tests pass: `make test`
- [ ] Coverage is adequate: `make test-coverage`
- [ ] Tests follow AAA pattern
- [ ] Test names are descriptive
- [ ] No flaky tests (run multiple times)
- [ ] Tests are fast (< 100ms for unit tests)
- [ ] Tests are independent
- [ ] Mocks are used for external dependencies
- [ ] Edge cases are covered

## CI/CD Integration

Ensure tests run in CI:

```yaml
# .github/workflows/test.yml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.38.5'
      - run: make init
      - run: make test
      - run: make test-coverage
```

## Resources

- [Flutter Testing Guide](https://flutter.dev/docs/testing)
- [Effective Dart: Testing](https://dart.dev/guides/language/effective-dart/testing)
- [Mocktail Documentation](https://pub.dev/packages/mocktail)

## Next Steps

- [Overview](overview.md) - Testing strategy
- [Unit Testing](unit-testing.md) - Unit test patterns
- [Widget Testing](widget-testing.md) - Widget test patterns
- [Integration Testing](integration-testing.md) - E2E test patterns
