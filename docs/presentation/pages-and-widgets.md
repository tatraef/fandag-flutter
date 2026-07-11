# Pages & Widgets

Page types, selective rebuilds with Consumer+select(), AsyncValue.when, and widget rules.

---

## Rules

### Widget Rules

1. **No widget functions** -- only widget classes (`StatelessWidget`, `ConsumerWidget`, etc.)
2. **Constructors first, `build()` always last** in class body
3. **`const` constructors** wherever possible
4. **`final` for all fields**
5. **No magic numbers** -- extract to `static const` named constants
6. **`child` / `children` last** in widget constructor calls
7. **Explicit types everywhere** -- `always_specify_types` is enabled

### Class Member Order

```
1. Constructor(s)
2. Fields
3. Static constants
4. Private methods
5. build() -- always last
```

### Page Decision Tree

```
Does the page need TextEditingController, FocusNode, or AnimationController?
├── YES → ConsumerStatefulWidget
└── NO  → ConsumerWidget
```

### Selective Rebuild Rule

Page `build()` must NEVER call `ref.watch` on the entire controller state. Wrap each state-dependent part in `Consumer` with `.select()`.

---

## Anti-Patterns

### WRONG: Widget function instead of widget class

```dart
// WRONG -- functions don't have keys, can't be const, break framework optimizations
Widget _buildPostCard(Post post) {
  return Card(child: Text(post.title));
}

// CORRECT -- always use a widget class
class PostCard extends StatelessWidget {
  const PostCard({required this.post, super.key});
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Card(child: Text(post.title));
  }
}
```

### WRONG: `ref.watch` in callback

```dart
// WRONG -- ref.watch creates a subscription, not for callbacks
onPressed: () {
  ref.watch(signInControllerProvider.notifier).submit(); // WRONG
},

// CORRECT -- ref.read for one-shot calls in callbacks
onPressed: () {
  ref.read(signInControllerProvider.notifier).submit();
},
```

### WRONG: Forgetting Consumer for state-dependent widget

```dart
// WRONG -- entire page rebuilds on any state change
@override
Widget build(BuildContext context, WidgetRef ref) {
  final SignInState state = ref.watch(signInControllerProvider); // WRONG
  return Column(
    children: <Widget>[
      AuthFormField(errorText: state.emailError),
      AppButton(isLoading: state.isLoading),
    ],
  );
}
```

See the correct pattern in [Selective Rebuilds](#selective-rebuilds-critical) below.

---

## Selective Rebuilds (Critical!)

### BAD -- entire page rebuilds on any state change

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final SignInState state = ref.watch(signInControllerProvider);  // BAD

  return Column(
    children: <Widget>[
      AuthFormField(errorText: state.emailError, ...),
      AppButton(isLoading: state.isLoading, ...),
    ],
  );
}
```

### GOOD -- only affected subtrees rebuild

```dart
@override
Widget build(BuildContext context) {
  return Column(
    children: <Widget>[
      Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final String? emailError = ref.watch(
            signInControllerProvider.select(
              (SignInState s) => s.emailError,
            ),
          );

          return AuthFormField(errorText: emailError, ...);
        },
      ),
      Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final bool isLoading = ref.watch(
            signInControllerProvider.select(
              (SignInState s) => s.isLoading,
            ),
          );

          return AppButton(isLoading: isLoading, ...);
        },
      ),
    ],
  );
}
```

### Selecting from AsyncValue

When the controller returns `Future<T>` (state is `AsyncValue<T>`), the select callback receives `AsyncValue<T>`:

```dart
Consumer(
  builder: (BuildContext context, WidgetRef ref, Widget? child) {
    final User? user = ref.watch(
      authStateControllerProvider.select(
        (AsyncValue<AuthState> s) => s.value?.user,
      ),
    );

    if (user == null) {
      return const SizedBox.shrink();
    }

    return Center(child: Text(user.name));
  },
)
```

### Extract to ConsumerWidget

When `Consumer.builder` exceeds ~30 lines or the widget is reused in 2+ places, extract to a private `ConsumerWidget`:

```dart
class _SubmitButton extends ConsumerWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isLoading = ref.watch(
      signInControllerProvider.select((SignInState s) => s.isLoading),
    );

    return AppButton(
      text: context.t.auth.signIn,
      isLoading: isLoading,
      onPressed: ref.read(signInControllerProvider.notifier).submit,
    );
  }
}
```

---

## ref.read for Callbacks

`ref.read` is allowed anywhere -- it does not create subscriptions:

```dart
// OK at page level in ConsumerWidget.build
IconButton(
  icon: const Icon(Icons.logout),
  onPressed: () {
    ref.read(authStateControllerProvider.notifier).onSignedOut();
  },
)
```

---

## ref.listen for Side-Effects

Use `ref.listen` for navigation, snackbars, dialogs. Place at the top of `build()` before the widget tree:

```dart
@override
Widget build(BuildContext context) {
  ref.listen(
    signInControllerProvider.select((SignInState s) => s.error),
    (Exception? prev, Exception? next) {
      if (next != null) {
        // Use feature-specific error localization (e.g., context.localizedSignInError)
        // or global context.localizedErrorMessage() for generic errors
        context.showSnackBar(context.localizedSignInError(next));
      }
    },
  );

  return Scaffold(/* ... */);
}
```

---

## AsyncValue.when Pattern

For controllers that return `Future<T>`, the state is `AsyncValue<T>`. Use `.when` to handle all three states:

```dart
Consumer(
  builder: (BuildContext context, WidgetRef ref, Widget? child) {
    final AsyncValue<List<Post>> postsAsync = ref.watch(homeControllerProvider);

    return postsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (Object error, StackTrace stackTrace) => Center(
        child: Text(context.t.common.errorOccurred),
      ),
      data: (List<Post> posts) => ListView.builder(
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index) =>
            PostCard(post: posts[index]),
      ),
    );
  },
)
```

---

## Page Types

### ConsumerWidget

Use for pages without TextEditingControllers or animations. See full example: `lib/features/home/presentation/pages/home_page.dart`

### ConsumerStatefulWidget

Use for pages with TextEditingControllers, FocusNodes, or AnimationControllers. See full example: `lib/features/auth/presentation/pages/sign_in_page.dart`

Key pattern for stateful pages:

```dart
class _SignInPageState extends ConsumerState<SignInPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // No ref.watch here -- use Consumer widgets
    return Scaffold(/* Consumer wrappers for each field */);
  }
}
```

---

## Theme Access

```dart
// Semantic colors
context.colors.textPrimary
context.colors.error

// Text styles
context.primaryFonts.semibold16
context.primaryFonts.regular14

// Combining styles with colors
Text(
  post.body,
  style: context.primaryFonts.regular14.copyWith(
    color: context.colors.textSecondary,
  ),
)

// Context utilities
context.screenWidth
context.showSnackBar('Message');

// Translations
context.t.auth.signIn
context.t.common.errorOccurred
```

See full reference: [Theming](theming.md)

---

## Form TextField Widgets

### Overview

Specialized TextField widgets with built-in validation live in `lib/core/widgets/text_fields/`:

- `EmailTextField` — email validation with proper keyboard type
- `PasswordTextField` — password validation with visibility toggle
- `NameTextField` — name validation (length + special chars)
- `ConfirmPasswordTextField` — password matching validation

**Key principle:** Validation logic lives in widgets, NOT in controllers. Controllers only store validity flags.

### Architecture

```
┌─────────────────────────────────────┐
│ TextField Widget                     │
│ ┌─────────────────────────────────┐ │
│ │ MultiValidator                   │ │
│ │ - ZeroLengthValidator           │ │
│ │ - EmailTextInputValidator       │ │
│ └─────────────────────────────────┘ │
│              │                       │
│              │ onValidate callback  │
│              ▼                       │
│   widget.onChanged(text, isValid)  │
└─────────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│ Controller                           │
│ setEmail(String value,              │
│          {required bool isValid})   │
│                                      │
│ State:                               │
│   email: 'user@example.com'        │
│   isEmailValid: true  ← bool flag!  │
└─────────────────────────────────────┘
```

### Usage Example

```dart
class _SignInPageState extends ConsumerState<SignInPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        EmailTextField(
          controller: _emailController,
          onChanged: ref.read(signInControllerProvider.notifier).setEmail,
          // Widget calls: setEmail('user@example.com', isValid: true)
        ),
      ],
    );
  }
}
```

### Controller Pattern

Controllers receive `isValid` flag and store it:

```dart
@freezed
abstract class SignInState with _$SignInState {
  const factory SignInState({
    @Default('') String email,
    @Default(false) bool isEmailValid,  // NOT String? emailError!
    // ...
  }) = _SignInState;
}

@riverpod
class SignInController extends _$SignInController {
  void setEmail(String value, {required bool isValid}) {
    state = state.copyWith(
      email: value,
      isEmailValid: isValid,  // Store flag from widget
      error: null,
    );
  }

  Future<void> submit() async {
    if (!state.isEmailValid) {
      return;  // Don't submit if invalid
    }
    // ...
  }
}
```

### Available Widgets

#### EmailTextField

```dart
EmailTextField(
  controller: _emailController,
  onChanged: (String text, {required bool isValid}) {
    // Called on every text change with validation result
  },
  textInputAction: TextInputAction.next,  // Optional
  isOptional: false,  // Allow empty field
)
```

**Validates:**
- Required (unless `isOptional: true`)
- Email format via regex

#### PasswordTextField

```dart
PasswordTextField(
  controller: _passwordController,
  onChanged: (String text, {required bool isValid}) { },
  textInputAction: TextInputAction.done,  // Optional
  validateOnUpdate: true,  // Enable/disable auto-validation
)
```

**Features:**
- Required validation
- Minimum length (6 chars) + must contain letters AND numbers
- Visibility toggle button (eye icon)
- Obscured by default

#### NameTextField

```dart
NameTextField(
  controller: _nameController,
  onChanged: (String text, {required bool isValid}) { },
  onSubmitted: (String text) { },  // Optional
)
```

**Validates:**
- Required
- Min length (2 chars)
- Max length (256 chars)
- Only letters, numbers, and `._+-` allowed
- Auto-capitalizes words

#### ConfirmPasswordTextField

```dart
ConfirmPasswordTextField(
  controller: _confirmPasswordController,
  passwordMatches: () => _passwordController.text == _confirmPasswordController.text,
  onChanged: (String text, {required bool isValid}) { },
)
```

**Validates:**
- Required
- Matches password via callback function
- Visibility toggle button

### Validators (lib/core/widgets/text_fields/text_field_validators.dart)

All validators extend `TextFieldValidator`:

```dart
// Single validator
ZeroLengthValidator(context.t.common.validation.fieldRequired)
EmailTextInputValidator(context.t.common.validation.invalidEmail)
PasswordValidator(context.t.common.validation.passwordWeak, minLength)
MinLengthValidator(2, 'Minimum length - 2')
MaxLengthValidator(256, 'Maximum length - 256')
SpecialSymbolsValidator(context.t.common.validation.specialSymbols)
PasswordRepeatValidator(() => password == confirmPassword, errorText)

// Combine multiple validators
MultiValidator(
  <TextFieldValidator>[
    ZeroLengthValidator(context.t.common.validation.fieldRequired),
    EmailTextInputValidator(context.t.common.validation.invalidEmail),
  ],
  onValidate: (bool isValid) {
    widget.onChanged?.call(text, isValid: isValid);
  },
  allowEmptyValidator: false,  // Skip validation if empty
).call  // ← Explicit .call tearoff to avoid lint warning
```

### Translations (common.validation)

Add error messages to `lib/core/translations/en.i18n.json`:

```json
{
  "common": {
    "validation": {
      "fieldRequired": "This field is required",
      "invalidEmail": "Please enter a valid email",
      "minLength": "Minimum length",
      "maxLength": "Maximum length",
      "specialSymbols": "Only letters, numbers and . _ + - are allowed",
      "passwordWeak": "Password must contain letters and numbers"
    }
  }
}
```

### Creating Custom TextField Widget

1. **Create widget** in `lib/core/widgets/text_fields/`:

```dart
class CustomTextField extends StatefulWidget {
  const CustomTextField({
    this.controller,
    this.onChanged,
    super.key,
  });

  final TextEditingController? controller;
  final void Function(String text, {required bool isValid})? onChanged;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField>
    with NullableTextEditingControllerMixin<CustomTextField> {

  TextEditingController get _effectiveController =>
      widget.controller ?? (controller ??= TextEditingController());

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      TextFormField(
        controller: _effectiveController,
        decoration: InputDecoration(
          labelText: 'Custom Field',
          border: const OutlineInputBorder(),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: MultiValidator(
          <TextFieldValidator>[
            ZeroLengthValidator(context.t.common.validation.fieldRequired),
            // Add custom validators here
          ],
          onValidate: (bool isValid) =>
              widget.onChanged?.call(_effectiveController.text, isValid: isValid),
        ).call,  // ← Don't forget .call
      ),
    );
  }
}
```

2. **Add to barrel** `lib/core/widgets/text_fields/text_fields.dart`:

```dart
export 'custom_text_field.dart';
```

3. **Use in page:**

```dart
CustomTextField(
  controller: _customController,
  onChanged: (String text, {required bool isValid}) {
    // Handle validation result
  },
)
```

### Important Notes

- **Never store error messages in controllers** — only `bool isValid` flags
- **Always use `.call` tearoff** on MultiValidator to avoid `implicit_call_tearoffs` lint warning
- **Validators are reusable** — combine them differently for different fields
- **Error messages from translations** — never hardcode strings in validators
- **TextField widgets in core** — NOT in feature folders, they're reusable across features

---

## Cross-References

- [Controllers](controllers.md) -- Controller patterns consumed by pages
- [Theming](theming.md) -- Full color and font token reference
- [Riverpod Providers](../architecture/riverpod-providers.md) -- `ref.watch`/`ref.read`/`ref.listen` rules
- [Code Style](../conventions/code-style.md) -- Linting and formatting rules
