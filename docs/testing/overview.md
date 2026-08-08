# Testing Overview — Fandag

This document provides an overview of the testing strategy and infrastructure in Fandag.

## Testing Philosophy

Our testing strategy follows the **testing pyramid**:

```
        /\
       /  \      Integration Tests (E2E)
      /____\     ← Few, test critical flows
     /      \
    /        \   Widget Tests
   /__________\  ← Some, test UI components
  /            \
 /              \ Unit Tests
/________________\ ← Many, test business logic
```

- **Unit Tests (70%)** - Test individual functions, classes, and business logic
- **Widget Tests (20%)** - Test UI components and user interactions
- **Integration Tests (10%)** - Test complete user flows end-to-end

## Test Organization

Tests mirror the `lib/` structure:

```
test/
├── helpers/                    # Test utilities
│   ├── helpers.dart           # Barrel file
│   ├── test_helpers.dart      # ProviderContainer utilities
│   ├── mocks.dart             # Mock classes
│   └── pump_app.dart          # Widget testing helpers
├── features/
│   └── home/
│       ├── domain/
│       │   └── entities/
│       │       └── post_test.dart
│       ├── data/
│       │   ├── models/
│       │   │   └── post_dto_test.dart
│       │   ├── datasources/
│       │   │   └── home_remote_datasource_test.dart
│       │   └── repositories/
│       │       └── home_repository_impl_test.dart
│       └── presentation/
│           ├── controllers/
│           │   └── home_controller_test.dart
│           ├── widgets/
│           │   └── post_card_test.dart
│           └── pages/
│               └── home_page_test.dart
└── core/
    └── network/
        └── dio_provider_test.dart

integration_test/
├── README.md
└── app_test.dart              # E2E tests
```

## Running Tests

### All tests

```bash
make test
# or
fvm flutter test
```

### Unit tests only

```bash
make test-unit
# or
fvm flutter test --exclude-tags widget,integration
```

### Widget tests only

```bash
make test-widget
# or
fvm flutter test --tags widget
```

### Integration tests

```bash
make test-integration
# or
fvm flutter test integration_test/
```

### With coverage

```bash
make test-coverage
# or
fvm flutter test --coverage
```

### Watch mode (re-run on changes)

```bash
make test-watch
# or
fvm flutter test --watch
```

## Test Types by Layer

| Layer | Test Type | What to Test | Example |
|-------|-----------|--------------|---------|
| **Domain** | Unit | Entities, business logic | `post_test.dart` |
| **Data** | Unit | DTOs, datasources, repositories | `post_dto_test.dart` |
| **Presentation** | Unit + Widget | Controllers, widgets, pages | `home_controller_test.dart` |
| **Core** | Unit | Utilities, providers, services | `dio_provider_test.dart` |

## Test Coverage Goals

- **Overall**: 80%+
- **Domain layer**: 90%+ (critical business logic)
- **Data layer**: 85%+ (data transformations and API calls)
- **Presentation layer**: 70%+ (UI is harder to test)
- **Core**: 80%+

## Dependencies

### Testing Packages

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  mocktail: 1.0.4
```

### Why Mocktail?

We use **mocktail** instead of mockito because:
- No code generation required
- Cleaner syntax
- Better type safety with Dart 3.x
- Easier to use with null safety

## Test Helpers

### Creating ProviderContainer

```dart
import 'package:test/helpers/helpers.dart';

final container = createContainer(
  overrides: [
    homeRepositoryProvider.overrideWithValue(mockRepository),
  ],
);
```

### Pumping Widgets

```dart
import 'package:test/helpers/helpers.dart';

await tester.pumpApp(
  const MyWidget(),
  overrides: [
    homeRepositoryProvider.overrideWithValue(mockRepository),
  ],
);
```

### Creating Mocks

```dart
import 'package:test/helpers/helpers.dart';

final mockRepository = MockHomeRepository();
when(() => mockRepository.getPosts()).thenAnswer((_) async => posts);
```

## Next Steps

- [What to Test](what-to-test.md) - Testing priorities and decision tree
- [Unit Testing](unit-testing.md) - Patterns for each layer
- [Widget Testing](widget-testing.md) - Testing UI components
- [Integration Testing](integration-testing.md) - E2E testing
- [Best Practices](best-practices.md) - Conventions and tips
- [Troubleshooting](troubleshooting.md) - Common issues and solutions

## Quick Reference

### Test File Naming

- Unit tests: `*_test.dart`
- Widget tests: `*_test.dart` (tagged with `@Tags(['widget'])`)
- Integration tests: `integration_test/*.dart`

### Import Order in Tests

```dart
// 1. Dart/Flutter packages
import 'package:flutter_test/flutter_test.dart';

// 2. Project packages
import 'package:fandag/features/home/domain/domain.dart';

// 3. Test helpers (relative imports OK in tests)
import '../../../helpers/helpers.dart';
```

### AAA Pattern

Always structure tests using **Arrange-Act-Assert**:

```dart
test('description', () {
  // Arrange - Set up test data and mocks
  final data = ...;

  // Act - Execute the code under test
  final result = ...;

  // Assert - Verify the result
  expect(result, expected);
});
```
