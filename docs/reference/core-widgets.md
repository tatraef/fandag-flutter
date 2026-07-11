# Core Widgets

API reference for reusable widgets in `lib/core/widgets/`.

---

## AppButton

Elevated button with loading state.

**File:** `lib/core/widgets/app_button.dart`

### Props

| Prop | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| `text` | `String` | Yes | — | Button label |
| `onPressed` | `VoidCallback?` | Yes | — | Tap handler (null = disabled) |
| `isLoading` | `bool` | No | `false` | Shows spinner, disables tap |
| `isEnabled` | `bool` | No | `true` | Disables tap when false |

### Source

```dart
class AppButton extends StatelessWidget {
  const AppButton({
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    super.key,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnabled && !isLoading ? onPressed : null,
      child: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  context.colors.textInverse,
                ),
              ),
            )
          : Text(text),
    );
  }
}
```

### Usage

```dart
Consumer(
  builder: (BuildContext context, WidgetRef ref, Widget? child) {
    final bool isLoading = ref.watch(
      signInControllerProvider.select((SignInState s) => s.isLoading),
    );

    return AppButton(
      text: context.t.auth.signIn,
      isLoading: isLoading,
      onPressed: ref.read(signInControllerProvider.notifier).submit,
    );
  },
)
```

---

## AppTextField

Text field with label, hint, error text, and configurable keyboard/input action.

**File:** `lib/core/widgets/app_text_field.dart`

### Props

| Prop | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| `controller` | `TextEditingController` | Yes | — | Text controller |
| `label` | `String?` | No | `null` | Floating label |
| `hint` | `String?` | No | `null` | Placeholder text |
| `errorText` | `String?` | No | `null` | Error message (null = no error) |
| `obscureText` | `bool` | No | `false` | Password mode |
| `keyboardType` | `TextInputType?` | No | `null` | Keyboard type |
| `textInputAction` | `TextInputAction?` | No | `null` | Action button (next, done) |
| `onChanged` | `ValueChanged<String>?` | No | `null` | Text change callback |
| `onSubmitted` | `ValueChanged<String>?` | No | `null` | Submit callback |
| `suffixIcon` | `Widget?` | No | `null` | Trailing icon |
| `enabled` | `bool` | No | `true` | Enables/disables the field |

### Source

```dart
class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.suffixIcon,
    this.enabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
```

### Usage

```dart
Consumer(
  builder: (BuildContext context, WidgetRef ref, Widget? child) {
    final String? emailError = ref.watch(
      signInControllerProvider.select((SignInState s) => s.emailError),
    );

    return AppTextField(
      controller: _emailController,
      label: context.t.auth.email,
      errorText: emailError,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: ref.read(signInControllerProvider.notifier).setEmail,
    );
  },
)
```

---

## LoadingOverlay

Semi-transparent overlay with centered spinner. Covers the `child` when `isLoading` is true.

**File:** `lib/core/widgets/loading_overlay.dart`

### Props

| Prop | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| `isLoading` | `bool` | Yes | — | Shows/hides the overlay |
| `child` | `Widget` | Yes | — | Content underneath |

### Source

```dart
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    required this.isLoading,
    required this.child,
    super.key,
  });

  final bool isLoading;
  final Widget child;

  static const double _overlayOpacity = 0.5;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        if (isLoading)
          Container(
            color: Colors.black.withValues(alpha: _overlayOpacity),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
```

### Usage

```dart
Consumer(
  builder: (BuildContext context, WidgetRef ref, Widget? child) {
    final bool isLoading = ref.watch(
      controllerProvider.select((State s) => s.isLoading),
    );

    return LoadingOverlay(
      isLoading: isLoading,
      child: /* page content */,
    );
  },
)
```

---

## ReloadableWidget

Wraps the app root. Forces a complete widget tree rebuild when triggered.

**File:** `lib/core/widgets/reloadable_widget.dart`

### Usage

```dart
// Trigger reload from anywhere
ReloadableWidget.reloadWidget(context);
// or via extension
context.reloadWidget();

// Safe across async gaps
final VoidCallback? reload = ReloadableWidget.captureReloadFunction(context);
await someAsyncOperation();
reload?.call();
```

Used in `main.dart` to wrap the entire `ProviderScope`. Triggered by debug menu actions (clear storage, switch server).

---

## When to Create a Core Widget

```
Is the widget used by 2+ features?
├── YES → lib/core/widgets/
│
Is it used only within one feature?
├── YES → lib/features/<feature>/presentation/widgets/
│
Is it a one-off layout helper?
└── YES → Private widget class in the same page file
```

After creating a core widget, add it to `lib/core/widgets/widgets.dart` barrel.
