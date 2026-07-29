# Code Style

Rules enforced by `analysis_options.yaml`, custom lints, and code review conventions.

---

## Widget Rules

### Widget functions are banned -- only widget classes

Every piece of UI must be a class: `StatelessWidget`, `StatefulWidget`, `ConsumerWidget`, or `ConsumerStatefulWidget`. Never extract UI into a function that returns `Widget`.

```dart
// WRONG -- widget function
Widget _buildHeader(String title) {
  return Text(title);
}

// CORRECT -- widget class
class Header extends StatelessWidget {
  const Header({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title);
  }
}
```

**Why:** Widget classes participate in the Flutter framework's lifecycle (keys, element tree, const constructors, `didUpdateWidget`). Functions bypass all of this and can cause subtle rebuild bugs.

---

## Selective Rebuilds

Page `build()` must never call `ref.watch`. Wrap state-dependent widgets in
`Consumer` + `.select()`. See full rules, examples, and patterns in
[Pages & Widgets -- Selective Rebuilds](../presentation/pages-and-widgets.md#selective-rebuilds-critical).

---

## Formatting

### Empty line before `return`

Enforced by the `newline_before_return` custom lint rule. Always leave a blank line before `return` statements when there is preceding code.

```dart
// WRONG
final String name = user.name;
return name;

// CORRECT
final String name = user.name;

return name;
```

Single-expression functions where `return` is the only statement do not need a blank line.

---

## No Magic Numbers

All numeric literals used for layout, timing, or business logic must be extracted into named constants.

```dart
// WRONG
padding: EdgeInsets.all(16),

// CORRECT
static const double _contentPadding = 16;
// ...
padding: EdgeInsets.all(_contentPadding),
```

Acceptable exceptions: `0`, `1`, `2` in trivial arithmetic, and `0.0`/`1.0` for opacity.

---

## Typing

### `always_specify_types`

Every variable, parameter, and return type must have an explicit type annotation. No `var`, no `final x = ...` without a type.

```dart
// WRONG
final items = repository.getItems();
var count = 0;

// CORRECT
final List<Item> items = repository.getItems();
int count = 0;
```

### `type_annotate_public_apis`

All public methods, fields, and top-level declarations must have explicit type annotations.

---

## Field Naming Conventions

| Convention | Pattern | Example |
|------------|---------|---------|
| Dart fields | camelCase | `userId`, `createdAt` |
| JSON conversion | Auto snake_case via `build.yaml` | `userId` -> `user_id` |
| Override JSON name | `@JsonKey(name: 'x')` | When server differs from snake_case |
| Boolean fields | `is`/`has`/`can` prefix | `isActive`, `hasAvatar`, `canEdit` |
| DateTime fields | `At` suffix | `createdAt`, `updatedAt`, `deletedAt` |
| Primary key | `id` | `required String id` |
| Foreign keys | `<entity>Id` | `userId`, `postId`, `orderId` |
| Optional fields | Nullable `Type?` | `String? avatarUrl` |
| Required fields | `required Type` | `required String name` |

---

## String Style

### `prefer_single_quotes`

Use single quotes for all strings except when the string contains a single quote.

```dart
// CORRECT
final String greeting = 'Hello, world';
final String message = "It's a test";
```

---

## Class Member Ordering (Strict)

All class members must follow this exact order:

1. **Constructor(s)** (enforced by `sort_constructors_first`)
2. **Static constants** (`static const`)
3. **Static fields** (`static final`, `static`)
4. **Instance fields** (`final`, non-final)
5. **Lifecycle methods** (for StatefulWidget: `initState`, `didChangeDependencies`, `dispose`, etc.) — alphabetically by name
6. **Public methods** — alphabetically by name
7. **Private methods** — alphabetically by name
8. **`build()` method** — ALWAYS LAST (only for widget classes)

### Complete Example

```dart
class UserProfileWidget extends StatefulWidget {
  // 1. Constructor
  const UserProfileWidget({super.key, required this.userId});

  // 2. Static constants
  static const double _avatarSize = 64;
  static const double _padding = 16;

  // 3. Static fields
  static final Logger _logger = Logger('UserProfileWidget');

  // 4. Instance fields
  final String userId;

  @override
  State<UserProfileWidget> createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  // 1. Constructor (implicit)

  // 2. Static constants
  static const int _maxRetries = 3;

  // 3. Static fields (none in this example)

  // 4. Instance fields
  late final TextEditingController _nameController;
  bool _isLoading = false;

  // 5. Lifecycle methods (alphabetically)
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ...
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  // 6. Public methods (alphabetically)
  void refresh() {
    setState(() => _isLoading = true);
  }

  void submitForm() {
    if (_validateForm()) {
      _saveData();
    }
  }

  // 7. Private methods (alphabetically)
  void _saveData() {
    // ...
  }

  bool _validateForm() {
    return _nameController.text.isNotEmpty;
  }

  // 8. build() ALWAYS LAST
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(widget.userId)),
    );
  }
}
```

### Non-Widget Classes

For non-widget classes (controllers, repositories, services), follow steps 1-7 but skip step 8 (`build()` doesn't apply):

```dart
@riverpod
class SignInController extends _$SignInController {
  // 1. build() method FIRST (for Riverpod controllers, this replaces constructor)
  @override
  SignInState build() => const SignInState();

  // 2. Setters (alphabetically)
  void setEmail(String value, {required bool isValid}) { ... }
  void setPassword(String value, {required bool isValid}) { ... }

  // 3. Actions (alphabetically)
  Future<void> submit() async { ... }

  // 4. Private methods (alphabetically)
  bool _validateForm() { ... }
}
```

**Note:** For Riverpod controllers, the `build()` method is analogous to a constructor and comes FIRST, not last.

### `sort_child_properties_last`

The `child` / `children` property should be the last named argument in widget constructors.

```dart
// CORRECT
Padding(
  padding: EdgeInsets.all(_padding),
  child: Text('Hello'),                // child last
)
```

---

## Immutability

The following rules are enabled:

- `prefer_const_constructors` -- use `const` wherever possible.
- `prefer_const_declarations` -- use `const` for top-level and static declarations.
- `prefer_const_literals_to_create_immutables` -- use `const` in list/map/set literals.
- `prefer_final_fields` -- non-reassigned fields should be `final`.
- `prefer_final_locals` -- non-reassigned local variables should be `final`.
- `prefer_final_in_for_each` -- loop variables should be `final`.

---

## Import Style

### `always_use_package_imports`

Always use `package:fandag/...` imports. Never use relative imports (`../`).

```dart
// WRONG -- relative import
import '../domain/entities/user.dart';

// WRONG -- direct file import (use barrel)
import 'package:fandag/features/auth/domain/entities/user.dart';

// CORRECT -- package import via barrel
import 'package:fandag/features/auth/domain/domain.dart';
```

### `directives_ordering`

Imports must be sorted: `dart:` first, then `package:`, then relative (though relative imports are banned).

---

## Riverpod Provider Conventions

### Use codegen annotations

Always use `@riverpod` (auto-dispose) or `@Riverpod(keepAlive: true)` (kept alive). Never write providers manually with `final myProvider = Provider(...)`.

```dart
// Auto-dispose provider (default, most common)
@riverpod
class SignInController extends _$SignInController {
  @override
  SignInState build() => const SignInState();
}

// Keep-alive provider (for singletons: Dio, repos, data sources)
@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    secureStorage: ref.watch(secureStorageProvider),
  );
}
```

### Provider naming

Generated provider names follow the pattern `<functionOrClassName>Provider`:
- Function `dio(Ref ref)` generates `dioProvider`
- Class `SignInController` generates `signInControllerProvider`

### `ref.watch` vs `ref.read`

- Use `ref.watch` in `build()` methods -- rebuilds when dependency changes.
- Use `ref.read` in callbacks, event handlers, and one-shot calls.

---

## Strict Analysis Mode

The project enables all three strict flags:

```yaml
analyzer:
  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true
```

This means:
- No implicit casts (e.g. `dynamic` to `String`).
- No missing type inference where it cannot be determined.
- No raw generic types (e.g. `List` instead of `List<String>`).

---

## Safety Rules

| Rule | Purpose |
|------|---------|
| `avoid_print` | Use `debugPrint` or a logger instead |
| `cancel_subscriptions` | Stream subscriptions must be cancelled |
| `close_sinks` | StreamControllers must be closed |
| `avoid_catching_errors` | Catch `Exception`, not `Error` |
| `unawaited_futures` | All futures must be awaited or explicitly marked with `unawaited()` |
| `use_build_context_synchronously` | Do not use `BuildContext` after async gaps |

---

## Summary Table

| Rule | Enforcement |
|------|-------------|
| No widget functions | Code review |
| Empty line before return | `custom_lint: newline_before_return` |
| No magic numbers | Code review |
| Explicit types everywhere | `always_specify_types` |
| Single quotes | `prefer_single_quotes` |
| Constructors first | `sort_constructors_first` |
| Const where possible | `prefer_const_constructors` |
| Package imports only | `always_use_package_imports` |
| Codegen providers only | `riverpod_lint` + code review |
| Selective rebuilds (`Consumer` + `.select()`) | Code review |
| Strict casts/inference | `strict-casts`, `strict-inference`, `strict-raw-types` |
