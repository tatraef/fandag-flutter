# Integration Testing — Flutter Template v3

Integration tests (also called E2E tests) verify complete user flows in a running app on a real device or simulator.

## When to Use Integration Tests

Use integration tests for:
- Critical user journeys (sign-up, checkout, core features)
- Multi-step workflows
- Navigation flows
- Real device/platform behavior
- Performance testing

**Don't overuse integration tests** - they are slow and brittle. Most testing should be at unit/widget level.

## Setup

Integration tests live in the `integration_test/` directory (separate from `test/`).

### Dependencies

```yaml
dev_dependencies:
  integration_test:
    sdk: flutter
```

### File Structure

```
integration_test/
├── README.md
└── app_test.dart
```

## Basic Integration Test

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_template_v3/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    testWidgets('should complete sign-in flow', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Verify initial state
      expect(find.text('Sign In'), findsOneWidget);

      // Enter credentials
      final emailField = find.byType(TextField).first;
      await tester.enterText(emailField, 'test@example.com');

      final passwordField = find.byType(TextField).last;
      await tester.enterText(passwordField, 'password123');
      await tester.pumpAndSettle();

      // Submit form
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify navigation
      expect(find.text('Home'), findsOneWidget);
    });
  });
}
```

## Running Integration Tests

### On a Device/Simulator

```bash
# Run all integration tests
fvm flutter test integration_test/

# Run specific test
fvm flutter test integration_test/app_test.dart

# Run on specific device
fvm flutter test integration_test/ -d iPhone
fvm flutter test integration_test/ -d emulator-5554
```

### Using Makefile

```bash
make test-integration
```

## Common Patterns

### 1. Authentication Flow

```dart
testWidgets('should complete authentication flow', (tester) async {
  app.main();
  await tester.pumpAndSettle();

  // Step 1: Sign in
  await _signIn(tester, 'test@example.com', 'password123');
  expect(find.text('Home'), findsOneWidget);

  // Step 2: Navigate to profile
  await tester.tap(find.byIcon(Icons.person));
  await tester.pumpAndSettle();
  expect(find.text('Profile'), findsOneWidget);

  // Step 3: Sign out
  await tester.tap(find.text('Sign Out'));
  await tester.pumpAndSettle();
  expect(find.text('Sign In'), findsOneWidget);
});

Future<void> _signIn(WidgetTester tester, String email, String password) async {
  await tester.enterText(find.byType(TextField).first, email);
  await tester.enterText(find.byType(TextField).last, password);
  await tester.tap(find.text('Sign In'));
  await tester.pumpAndSettle(const Duration(seconds: 3));
}
```

### 2. CRUD Operations

```dart
testWidgets('should create, view, and delete post', (tester) async {
  app.main();
  await tester.pumpAndSettle();

  // Sign in first
  await _signIn(tester, 'test@example.com', 'password123');

  // Create post
  await tester.tap(find.byIcon(Icons.add));
  await tester.pumpAndSettle();

  await tester.enterText(find.byType(TextField).first, 'Test Post');
  await tester.enterText(find.byType(TextField).last, 'Test Body');
  await tester.tap(find.text('Create'));
  await tester.pumpAndSettle();

  // Verify post appears
  expect(find.text('Test Post'), findsOneWidget);

  // Delete post
  await tester.tap(find.byIcon(Icons.delete));
  await tester.pumpAndSettle();

  await tester.tap(find.text('Confirm'));
  await tester.pumpAndSettle();

  // Verify post removed
  expect(find.text('Test Post'), findsNothing);
});
```

### 3. Navigation Flow

```dart
testWidgets('should navigate through app', (tester) async {
  app.main();
  await tester.pumpAndSettle();

  // Navigate to tab 1
  await tester.tap(find.byIcon(Icons.home));
  await tester.pumpAndSettle();
  expect(find.text('Home'), findsOneWidget);

  // Navigate to tab 2
  await tester.tap(find.byIcon(Icons.search));
  await tester.pumpAndSettle();
  expect(find.text('Search'), findsOneWidget);

  // Navigate to tab 3
  await tester.tap(find.byIcon(Icons.settings));
  await tester.pumpAndSettle();
  expect(find.text('Settings'), findsOneWidget);

  // Go back
  await tester.tap(find.byIcon(Icons.arrow_back));
  await tester.pumpAndSettle();
});
```

### 4. Form Validation

```dart
testWidgets('should validate form fields', (tester) async {
  app.main();
  await tester.pumpAndSettle();

  // Test 1: Empty form
  await tester.tap(find.text('Submit'));
  await tester.pumpAndSettle();
  expect(find.text('Required'), findsWidgets);

  // Test 2: Invalid email
  await tester.enterText(find.byType(TextField).first, 'invalid');
  await tester.tap(find.text('Submit'));
  await tester.pumpAndSettle();
  expect(find.text('Invalid email'), findsOneWidget);

  // Test 3: Valid form
  await tester.enterText(find.byType(TextField).first, 'test@example.com');
  await tester.enterText(find.byType(TextField).last, 'password123');
  await tester.tap(find.text('Submit'));
  await tester.pumpAndSettle();
  expect(find.text('Success'), findsOneWidget);
});
```

### 5. Scrolling

```dart
testWidgets('should scroll through list', (tester) async {
  app.main();
  await tester.pumpAndSettle();

  // Scroll down
  await tester.drag(
    find.byType(ListView),
    const Offset(0, -500),
  );
  await tester.pumpAndSettle();

  // Verify item at bottom is visible
  expect(find.text('Item 20'), findsOneWidget);

  // Scroll back up
  await tester.drag(
    find.byType(ListView),
    const Offset(0, 500),
  );
  await tester.pumpAndSettle();

  // Verify item at top is visible
  expect(find.text('Item 1'), findsOneWidget);
});
```

## Waiting for Async Operations

### Wait for animations

```dart
await tester.pumpAndSettle();
```

### Wait for specific duration

```dart
await tester.pumpAndSettle(const Duration(seconds: 3));
```

### Wait for condition

```dart
// Wait for loading indicator to disappear
while (find.byType(CircularProgressIndicator).evaluate().isNotEmpty) {
  await tester.pump(const Duration(milliseconds: 100));
}
```

### Poll until condition

```dart
Future<void> waitFor(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  final end = DateTime.now().add(timeout);

  while (DateTime.now().isBefore(end)) {
    if (finder.evaluate().isNotEmpty) {
      return;
    }
    await tester.pump(const Duration(milliseconds: 100));
  }

  throw TimeoutException('Widget not found');
}
```

## Using Keys for Finding Widgets

Add keys to widgets that are hard to find:

```dart
// In your widget
TextField(
  key: const Key('email-field'),
  // ...
)

// In your test
await tester.enterText(
  find.byKey(const Key('email-field')),
  'test@example.com',
);
```

## Test Helpers

Create helper functions for common operations:

```dart
// integration_test/helpers.dart
import 'package:flutter_test/flutter_test.dart';

Future<void> signIn(
  WidgetTester tester,
  String email,
  String password,
) async {
  await tester.enterText(find.byKey(const Key('email')), email);
  await tester.enterText(find.byKey(const Key('password')), password);
  await tester.tap(find.text('Sign In'));
  await tester.pumpAndSettle(const Duration(seconds: 3));
}

Future<void> signOut(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.logout));
  await tester.pumpAndSettle();
}

Future<void> waitForText(
  WidgetTester tester,
  String text, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  final end = DateTime.now().add(timeout);

  while (DateTime.now().isBefore(end)) {
    if (find.text(text).evaluate().isNotEmpty) {
      return;
    }
    await tester.pump(const Duration(milliseconds: 100));
  }

  throw TimeoutException('Text "$text" not found');
}
```

## Mocking Backend

For reliable integration tests, mock the backend:

### Option 1: Use mock flag

```dart
// main.dart
void main() {
  final useMock = const bool.fromEnvironment('USE_MOCK', defaultValue: false);

  runApp(
    ProviderScope(
      overrides: useMock ? mockOverrides : [],
      child: const App(),
    ),
  );
}

// integration_test/app_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('test with mock', (tester) async {
    // Pass --dart-define=USE_MOCK=true when running
  });
}
```

### Option 2: Override providers in test

```dart
testWidgets('test with mocked provider', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        homeRepositoryProvider.overrideWithValue(mockRepository),
      ],
      child: const App(),
    ),
  );

  await tester.pumpAndSettle();
  // ...
});
```

## Performance Testing

Integration tests can measure performance:

```dart
import 'package:flutter_driver/driver_extension.dart';

void main() {
  enableFlutterDriverExtension();

  testWidgets('measure scroll performance', (tester) async {
    // Record timeline
    await tester.binding.traceAction(() async {
      // Perform scrolling
      await tester.drag(find.byType(ListView), const Offset(0, -1000));
      await tester.pumpAndSettle();
    });
  });
}
```

## Best Practices

1. **Test critical flows only** - Integration tests are expensive
2. **Use test helpers** - Reduce duplication with helper functions
3. **Mock external dependencies** - Don't rely on real APIs
4. **Add explicit waits** - Network/animation delays need time
5. **Use keys for flaky selectors** - When `find.text()` isn't reliable
6. **Test on multiple devices** - iOS and Android may behave differently
7. **Keep tests independent** - Each test should set up and tear down its state
8. **Skip flaky tests** - Use `skip: true` until fixed

## Common Pitfalls

### ❌ Don't: Rely on exact timing

```dart
// Bad - brittle
await tester.pump(const Duration(seconds: 2));
expect(find.text('Loaded'), findsOneWidget);
```

```dart
// Good - wait for condition
await tester.pumpAndSettle();
await waitForText(tester, 'Loaded');
```

### ❌ Don't: Test too much in one test

```dart
// Bad - tests entire app in one test
testWidgets('test everything', (tester) async {
  // 100+ lines of test code...
});
```

```dart
// Good - focused tests
testWidgets('test sign in', (tester) async { /* ... */ });
testWidgets('test navigation', (tester) async { /* ... */ });
testWidgets('test CRUD', (tester) async { /* ... */ });
```

### ❌ Don't: Use real backend without mocks

```dart
// Bad - flaky, slow, requires network
testWidgets('test with real API', (tester) async {
  // Makes real HTTP calls...
});
```

```dart
// Good - mocked backend
testWidgets('test with mock API', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [repositoryProvider.overrideWithValue(mock)],
      child: const App(),
    ),
  );
});
```

## Debugging Integration Tests

```dart
// Take screenshot
await tester.binding.takeScreenshot('screenshot-name');

// Print widget tree
debugDumpApp();

// Print to console
print('Current state: ${find.text("Home").evaluate()}');

// Add breakpoint
debugger(); // Requires 'dart:developer'
```

## Running Tests in CI/CD

```yaml
# .github/workflows/test.yml
- name: Run Integration Tests
  run: |
    fvm flutter test integration_test/ \
      --dart-define=USE_MOCK=true \
      --coverage
```

## Next Steps

- [Best Practices](best-practices.md) - Testing conventions
- [Overview](overview.md) - Testing strategy
