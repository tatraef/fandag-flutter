# Testing Troubleshooting — Fandag

This guide covers common testing issues and their solutions.

## Analyzer Errors

### Error: "Type 'Override' not found"

**Problem:**
```
error • The name 'Override' isn't a type, so it can't be used as a type argument
```

**Cause:**
Analyzer cannot resolve Riverpod types in test helper files when analyzed in isolation.

**Solution:**
Add ignore comment at top of helper file:

```dart
// ignore_for_file: non_type_as_type_argument, undefined_class

import 'package:flutter_riverpod/flutter_riverpod.dart';

ProviderContainer createContainer({
  List<Override> overrides = const <Override>[],
  // ...
}) { }
```

**Note:** Tests will still compile and run correctly. This is a false-positive analyzer error.

---

### Error: "always_specify_types"

**Problem:**
```
info • Missing type annotation • test.dart:10:7 • always_specify_types
```

**Cause:**
Project requires explicit types for all variables.

**Solution:**
Add explicit type annotations:

```dart
// ❌ Before
final container = createContainer();
final posts = [];
var result = await getData();

// ✅ After
final ProviderContainer container = createContainer();
final List<Post> posts = <Post>[];
final List<Post> result = await getData();
```

---

### Error: "Undefined name 'AppTheme'"

**Problem:**
```
error • Undefined name 'AppTheme' • test/helpers/pump_app.dart:33:27
```

**Cause:**
`AppTheme` class doesn't exist. Theme is configured via functions.

**Solution:**
Use `lightTheme()` or `darkTheme()` functions:

```dart
// ❌ Wrong
import 'package:fandag/core/theme/theme.dart';
theme: AppTheme.lightTheme,

// ✅ Correct
import 'package:fandag/core/theme/theme.dart';
theme: lightTheme(),  // or darkTheme()
```

---

### Error: "directives_ordering"

**Problem:**
```
info • Sort directive sections alphabetically • test.dart:4:1 • directives_ordering
```

**Solution:**
Order imports: dart → third-party packages → project → test helpers:

```dart
// ✅ Correct order
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fandag/core/network/network.dart';
import 'package:fandag/features/home/domain/domain.dart';

import '../../../helpers/helpers.dart';
```

---

## Test Failures

### Error: "type 'Null' is not a subtype of type 'String' in type cast"

**Problem:**
```
type 'Null' is not a subtype of type 'String' in type cast
package:.../post_dto.g.dart 13:31  _$PostDtoFromJson
```

**Cause:**
JSON test data uses camelCase keys, but generated code expects snake_case.

**Solution:**
Check `*.g.dart` file for actual field names and use snake_case:

```dart
// ❌ Wrong - camelCase
final Map<String, dynamic> json = {
  'authorId': 'author-1',
  'createdAt': '2024-01-01T10:00:00.000Z',
};

// ✅ Correct - snake_case
final Map<String, dynamic> json = <String, dynamic>{
  'author_id': 'author-1',
  'created_at': '2024-01-01T10:00:00.000Z',
};
```

**How to check:**
1. Open `lib/features/.../models/gen/dto_name.g.dart`
2. Look at `fromJson` method to see actual JSON keys

Example from `post_dto.g.dart`:
```dart
_PostDto _$PostDtoFromJson(Map<String, dynamic> json) => _PostDto(
  id: json['id'] as String,
  authorId: json['author_id'] as String,  // ← snake_case!
  createdAt: DateTime.parse(json['created_at'] as String),  // ← snake_case!
);
```

---

### Error: Repository test expects wrong exception type

**Problem:**
Repository test throws wrong exception type from datasource.

**Cause:**
Misunderstanding of ApiClient architecture.

**Architecture:**
```
ApiClient (converts errors → ApiException)
    ↓
Datasource (throws ApiException)
    ↓
Repository (propagates ApiException)
```

**Solution:**
Mock datasource to throw ApiException:

```dart
// ✅ Correct - datasource throws ApiException
when(() => mockDataSource.getPosts()).thenThrow(
  const NetworkException(),
);
```

**Remember:** Test error conversion in **ApiClient tests**, not repository tests.

---

### Error: "MockDio is not a subtype of Dio"

**Problem:**
Mock created incorrectly or registered fallbacks missing.

**Solution:**
Register fallback values in `setUpAll`:

```dart
class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;

  setUpAll(() {
    // Register fallback values for mocktail
    registerFallbackValue(RequestOptions(path: ''));
    registerFallbackValue(Response<dynamic>(
      requestOptions: RequestOptions(path: ''),
    ));
  });

  setUp(() {
    mockDio = MockDio();
  });

  // Tests...
}
```

---

## Widget Test Issues

### Error: "Override not found" in widget test

**Problem:**
```
error • The name 'Override' isn't a type, so it can't be used as a type argument
```

**Cause:**
Widget test helper (`pump_app.dart`) analyzed in isolation.

**Solution:**
Already fixed with ignore comment in `pump_app.dart`. If creating new helper:

```dart
// ignore_for_file: non_type_as_type_argument

import 'package:flutter_riverpod/flutter_riverpod.dart';

extension WidgetTesterX on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    List<Override> overrides = const <Override>[],
    // ...
  }) async { }
}
```

---

## Running Tests

### All tests fail with compilation errors

**Problem:**
Helper files have compilation errors.

**Solution:**
1. Ensure `flutter_riverpod` is in `pubspec.yaml` dependencies (not just dev_dependencies)
2. Run `flutter pub get`
3. Verify imports:
   ```dart
   import 'package:flutter_riverpod/flutter_riverpod.dart';
   ```
4. Check that types exist in your Flutter/Riverpod version

---

### Tests pass but analyzer fails

**Problem:**
`make test` passes, but `make analyze` shows errors.

**Cause:**
Tests run in flutter test context (has access to all dependencies), but analyzer may run in isolation.

**Solution:**
Add ignore comments to helper files (see "Type 'Override' not found" above).

**Verify:**
```bash
make analyze  # Should show "No issues found!"
make test     # Should show "All tests passed!"
```

Both must pass before committing.

---

## Performance Issues

### Tests are slow (> 1 second per test)

**Problem:**
Tests take too long to run.

**Common causes:**
1. Heavy `setUp` that runs before each test
2. Not using `setUpAll` for expensive operations
3. Creating real objects instead of mocks

**Solution:**

```dart
// ❌ Bad - runs before EACH test
setUp(() {
  heavyObject = createHeavyObject();  // Slow!
});

// ✅ Good - runs ONCE before all tests
setUpAll(() {
  heavyObject = createHeavyObject();
  registerFallbackValue(...);
});

// ✅ Even better - use mocks
late MockRepository mockRepository;

setUp(() {
  mockRepository = MockRepository();  // Fast!
});
```

---

## Flaky Tests

### Test sometimes passes, sometimes fails

**Problem:**
Non-deterministic test results.

**Common causes:**
1. Time-dependent logic without fixed time
2. Async operations without proper awaiting
3. Test order dependencies
4. Shared mutable state

**Solutions:**

**1. Fix time-dependent tests:**
```dart
// ❌ Bad - depends on current time
test('should be recent', () {
  final user = User(createdAt: DateTime.now());
  expect(user.isRecent, isTrue);  // May fail if slow
});

// ✅ Good - explicit fixed time
test('should be recent when within 1 hour', () {
  final createdAt = DateTime(2024, 1, 1, 12, 0);
  final now = DateTime(2024, 1, 1, 12, 30);
  final user = User(createdAt: createdAt);
  expect(user.isRecentAt(now), isTrue);
});
```

**2. Properly await async:**
```dart
// ❌ Bad - not awaiting
test('async test', () async {
  controller.load();  // Missing await!
  expect(controller.state.hasValue, isTrue);
});

// ✅ Good - awaiting
test('async test', () async {
  await controller.load();
  expect(controller.state.hasValue, isTrue);
});
```

**3. Make tests independent:**
```dart
// ❌ Bad - tests depend on order
var userId = '';
test('create user', () {
  userId = createUser();
});
test('update user', () {
  updateUser(userId);  // Depends on previous test!
});

// ✅ Good - independent
test('should update user', () {
  final userId = createUser();
  updateUser(userId);
  expect(getUser(userId).isUpdated, isTrue);
});
```

---

## Coverage Issues

### Coverage report shows 0% coverage

**Problem:**
Coverage data not generated.

**Solution:**
```bash
# Generate coverage
fvm flutter test --coverage

# Check that file exists
ls -la coverage/lcov.info

# View coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

### Coverage is lower than expected

**Problem:**
Important code not covered by tests.

**Solution:**
1. Check what's not covered:
	   ```bash
	   fvm flutter test --coverage
	   genhtml coverage/lcov.info -o coverage/html
	   open coverage/html/index.html
	   ```

2. Focus on Tier 1 priorities (see [what-to-test.md](what-to-test.md)):
   - Business logic
   - Error handling
   - Data transformations
   - Input validation

3. Don't worry about:
   - Generated code (`*.g.dart`, `*.freezed.dart`)
   - Simple getters/setters
   - UI layout code

---

## Getting Help

If you encounter an issue not covered here:

1. **Check documentation:**
   - [Overview](overview.md) - Testing strategy
   - [Best Practices](best-practices.md) - Conventions
   - [What to Test](what-to-test.md) - Testing priorities

2. **Run diagnostics:**
   ```bash
   make analyze   # Check for errors
   make test      # Run tests
   flutter doctor # Check Flutter setup
   ```

3. **Check generated files:**
   - Look at `*.g.dart` for JSON field names
   - Look at `*.freezed.dart` for available methods

4. **Common fixes:**
   - Clean and rebuild: `flutter clean && flutter pub get`
   - Restart IDE/analyzer
   - Check Flutter version matches project requirements

---

## Quick Reference

### Before committing:
```bash
make analyze  # Must pass
make test     # Must pass
```

### Common patterns:
```dart
// Explicit types
final List<Post> posts = <Post>[];

// JSON snake_case
'author_id': 'value'

// Theme import
theme: lightTheme()

// Repository test
when(() => mockDataSource.getPosts()).thenThrow(
  const NetworkException(),
);
```
