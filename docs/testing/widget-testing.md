# Widget Testing — Flutter Template v3

Widget tests verify UI components and user interactions. They test the widget tree and user interactions without running the full app.

## General Principles

1. **Test user-visible behavior** - Not implementation details
2. **Use WidgetTester helpers** - `pumpApp()`, `pumpProviderScope()`
3. **Test interactions** - Taps, scrolls, text input
4. **Verify visual output** - Text, icons, widget presence
5. **Mock providers** - Override Riverpod providers with test data

## Widget Test Anatomy

```dart
import 'package:flutter_test/flutter_test.dart';
import '../../../../helpers/helpers.dart';

void main() {
  group('MyWidget', () {
    testWidgets('should display text', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpApp(const MyWidget());

      // Assert
      expect(find.text('Hello'), findsOneWidget);
    });
  });
}
```

## Testing Pure Widgets

Pure widgets are stateless/stateful widgets that don't use Riverpod.

### Example: PostCard Widget

**What to test:**
- Displays all required data
- Handles optional properties
- Responds to user interactions
- No layout overflow errors

```dart
import 'package:flutter/material.dart';
import 'package:flutter_template_v3/features/home/domain/entities/entities.dart';
import 'package:flutter_template_v3/features/home/presentation/widgets/post_card.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('PostCard', () {
    late Post testPost;

    setUp(() {
      testPost = Post(
        id: '1',
        title: 'Test Post Title',
        body: 'Test post body',
        authorId: 'author-1',
        createdAt: DateTime(2024),
      );
    });

    testWidgets('should display post title and body',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpMaterialApp(PostCard(post: testPost));

      // Assert
      expect(find.text('Test Post Title'), findsOneWidget);
      expect(find.text('Test post body'), findsOneWidget);
    });

    testWidgets('should display delete button when onDelete is provided',
        (WidgetTester tester) async {
      // Arrange
      bool deleteCalled = false;

      // Act
      await tester.pumpMaterialApp(
        PostCard(
          post: testPost,
          onDelete: () => deleteCalled = true,
        ),
      );

      // Assert
      final Finder deleteButton = find.byIcon(Icons.delete_outline);
      expect(deleteButton, findsOneWidget);

      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      expect(deleteCalled, isTrue);
    });

    testWidgets('should not display delete button when onDelete is null',
        (WidgetTester tester) async {
      // Act
      await tester.pumpMaterialApp(PostCard(post: testPost));

      // Assert
      expect(find.byIcon(Icons.delete_outline), findsNothing);
    });
  });
}
```

## Testing Widgets with Riverpod

Widgets that use Riverpod need `ProviderScope` and provider overrides.

### Example: Page with Providers

**What to test:**
- Loading state displays correctly
- Error state with retry button
- Data state renders list
- User interactions trigger provider methods

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template_v3/features/home/domain/entities/entities.dart';
import 'package:flutter_template_v3/features/home/presentation/controllers/home_controller.dart';
import 'package:flutter_template_v3/features/home/presentation/pages/home_page.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('HomePage', () {
    testWidgets('should display loading indicator when loading',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpApp(
        const HomePage(),
        overrides: [
          homeControllerProvider.overrideWith(
            () => MockHomeController(const AsyncValue.loading()),
          ),
        ],
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display error message when error occurs',
        (WidgetTester tester) async {
      // Arrange
      final errorState = AsyncValue<List<Post>>.error(
        Exception('Failed'),
        StackTrace.current,
      );

      await tester.pumpApp(
        const HomePage(),
        overrides: [
          homeControllerProvider.overrideWith(
            () => MockHomeController(errorState),
          ),
        ],
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('An error occurred'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('should display list of posts when data is loaded',
        (WidgetTester tester) async {
      // Arrange
      final posts = [
        Post(
          id: '1',
          title: 'Post 1',
          body: 'Body 1',
          authorId: 'author-1',
          createdAt: DateTime(2024),
        ),
      ];

      await tester.pumpApp(
        const HomePage(),
        overrides: [
          homeControllerProvider.overrideWith(
            () => MockHomeController(AsyncValue.data(posts)),
          ),
        ],
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Post 1'), findsOneWidget);
    });
  });
}
```

## Common Widget Testing Patterns

### Finding Widgets

```dart
// By text
expect(find.text('Hello'), findsOneWidget);

// By type
expect(find.byType(ElevatedButton), findsOneWidget);

// By icon
expect(find.byIcon(Icons.add), findsOneWidget);

// By key
expect(find.byKey(const Key('my-key')), findsOneWidget);

// Multiple widgets
expect(find.byType(ListTile), findsNWidgets(3));

// Widget not present
expect(find.text('Not There'), findsNothing);
```

### User Interactions

#### Tap

```dart
await tester.tap(find.byType(ElevatedButton));
await tester.pumpAndSettle();
```

#### Enter Text

```dart
await tester.enterText(find.byType(TextField), 'Hello');
await tester.pumpAndSettle();
```

#### Scroll

```dart
await tester.drag(
  find.byType(ListView),
  const Offset(0, -300), // Scroll up by 300 pixels
);
await tester.pumpAndSettle();
```

#### Long Press

```dart
await tester.longPress(find.byType(ListTile));
await tester.pumpAndSettle();
```

### Waiting for Animations

```dart
// Wait for all animations to complete
await tester.pumpAndSettle();

// Wait for specific duration
await tester.pump(const Duration(milliseconds: 500));

// Multiple pumps
await tester.pump();
await tester.pump();
```

### Accessing Widget Properties

```dart
// Get widget instance
final Text textWidget = tester.widget<Text>(find.text('Hello'));
expect(textWidget.style?.fontSize, 16);

// Get widget size/position
final RenderBox box = tester.renderObject(find.byType(Container));
expect(box.size.width, 100);
```

### Testing Forms

```dart
testWidgets('should validate form', (WidgetTester tester) async {
  // Arrange
  await tester.pumpApp(const MyForm());

  // Act - Submit empty form
  await tester.tap(find.text('Submit'));
  await tester.pumpAndSettle();

  // Assert
  expect(find.text('Field is required'), findsOneWidget);

  // Act - Fill form
  await tester.enterText(find.byType(TextField), 'Valid input');
  await tester.tap(find.text('Submit'));
  await tester.pumpAndSettle();

  // Assert
  expect(find.text('Field is required'), findsNothing);
});
```

## Test Helpers

### pumpApp

Use for full app context with MaterialApp + ProviderScope:

```dart
await tester.pumpApp(
  const MyWidget(),
  overrides: [
    myProvider.overrideWithValue(mockValue),
  ],
);
```

### pumpProviderScope

Use for widgets that only need ProviderScope:

```dart
await tester.pumpProviderScope(
  const MyWidget(),
  overrides: [
    myProvider.overrideWithValue(mockValue),
  ],
);
```

### pumpMaterialApp

Use for pure widgets (no Riverpod):

```dart
await tester.pumpMaterialApp(const MyWidget());
```

## Mocking Controllers

For complex controllers, create a mock implementation:

```dart
class MockHomeController extends AutoDisposeAsyncNotifier<List<Post>>
    implements HomeController {
  MockHomeController(this._state);

  AsyncValue<List<Post>> _state;

  @override
  Future<List<Post>> build() async {
    state = _state;
    return _state.requireValue;
  }

  @override
  Future<void> refresh() async {}

  @override
  Future<void> deletePost(String id) async {}
}
```

Then use in overrides:

```dart
overrides: [
  homeControllerProvider.overrideWith(
    () => MockHomeController(AsyncValue.data(posts)),
  ),
]
```

## Testing Themes

```dart
testWidgets('should apply theme colors', (WidgetTester tester) async {
  // Arrange
  await tester.pumpApp(const MyWidget());

  // Act
  final Container container = tester.widget(find.byType(Container));

  // Assert
  expect(
    (container.decoration as BoxDecoration).color,
    ThemeColors.primary,
  );
});
```

## Best Practices

1. **Test user-visible behavior** - Don't test implementation details
2. **Use semantic finders** - Prefer `find.text()` over `find.byKey()`
3. **Wait for animations** - Always call `pumpAndSettle()` after interactions
4. **Test error states** - Loading, error, empty states
5. **Test accessibility** - Semantic labels, contrast ratios
6. **Keep tests focused** - One behavior per test
7. **Use setUp/tearDown** - Initialize common test data

## Common Pitfalls

### ❌ Don't: Test implementation details

```dart
// Bad - tests internal structure
expect(find.byType(Column), findsOneWidget);
expect(find.byType(Row), findsNWidgets(2));
```

```dart
// Good - tests user-visible output
expect(find.text('Title'), findsOneWidget);
expect(find.text('Subtitle'), findsOneWidget);
```

### ❌ Don't: Forget to pump

```dart
// Bad - state not updated
await tester.tap(find.text('Button'));
expect(find.text('Success'), findsOneWidget); // Might fail
```

```dart
// Good
await tester.tap(find.text('Button'));
await tester.pumpAndSettle();
expect(find.text('Success'), findsOneWidget);
```

### ❌ Don't: Use real providers

```dart
// Bad - uses real API
await tester.pumpApp(const HomePage());
```

```dart
// Good - mocks provider
await tester.pumpApp(
  const HomePage(),
  overrides: [
    homeRepositoryProvider.overrideWithValue(mockRepository),
  ],
);
```

## Running Widget Tests

```bash
# All widget tests
make test-widget

# Specific file
fvm flutter test test/features/home/presentation/widgets/post_card_test.dart

# With coverage
make test-coverage
```

## Debugging Widget Tests

```dart
// Print widget tree
debugDumpApp();

// Print render tree
debugDumpRenderTree();

// Print layer tree
debugDumpLayerTree();

// Print semantics tree
debugDumpSemanticsTree();
```

## Next Steps

- [Integration Testing](integration-testing.md) - E2E testing
- [Best Practices](best-practices.md) - Testing conventions
