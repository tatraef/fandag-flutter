# Translations Patterns

Type-safe translations with slang. JSON source files, generated Dart code, `context.t` access.

---

## JSON File Structure

Source files live in `lib/core/translations/`:

- `en.i18n.json` -- English strings
- `ru.i18n.json` -- Russian strings

Both files must have **identical key structures**. Keys are nested by feature:

```json
{
  "common": {
    "appTitle": "Flutter Template v3",
    "errorOccurred": "An error occurred",
    "retry": "Retry",
    "loading": "Loading..."
  },
  "auth": {
    "signIn": "Sign In",
    "signUp": "Sign Up",
    "email": "Email",
    "password": "Password",
    "emailRequired": "Email is required",
    "passwordRequired": "Password is required"
  },
  "home": {
    "title": "Home",
    "posts": "Posts",
    "noPosts": "No posts yet"
  }
}
```

### Key Naming Rules

- Group keys by feature name matching the feature folder (`auth`, `home`, `common`)
- Use camelCase for keys (`signIn`, `emailRequired`)
- Use nested groups for sub-sections: `auth.signIn`, `auth.signUp`
- `common` group for shared strings (app title, generic buttons, error messages)

---

## Adding New Strings

1. Add key to `lib/core/translations/en.i18n.json`:
```json
{
  "featureName": {
    "newKey": "English text"
  }
}
```

2. Add the same key to `lib/core/translations/ru.i18n.json`:
```json
{
  "featureName": {
    "newKey": "Русский текст"
  }
}
```

3. Regenerate:
```bash
make translations
```

4. Access in code:
```dart
context.t.featureName.newKey
```

---

## Usage in Widgets

```dart
import 'package:flutter_template_v3/core/translations/generated/translations.g.dart';

// In build():
Text(context.t.auth.signIn)
Text(context.t.common.appTitle)
Text(context.t.home.noPosts)
```

### Real Example from Auth Feature

```dart
// sign_in_page.dart
AppButton(
  text: context.t.auth.signIn,
  onPressed: ref.read(signInControllerProvider.notifier).submit,
)

// Validation error messages
AuthFormField(
  labelText: context.t.auth.email,
  errorText: emailError,
)
```

---

## Generated Code

Running `make translations` generates `lib/core/translations/generated/translations.g.dart`. This file:

- Provides `context.t` extension for accessing translations
- Provides `TranslationProvider` widget for locale management
- Provides `LocaleSettings.useDeviceLocale()` for auto-detection
- Provides `AppLocaleUtils.supportedLocales` for MaterialApp

---

## Anti-Patterns

### WRONG: Hardcoded strings in UI

```dart
// WRONG
Text('Sign In')

// CORRECT
Text(context.t.auth.signIn)
```

### WRONG: Missing keys in one language

Both `en.i18n.json` and `ru.i18n.json` must have identical key structures. Missing keys will cause compile-time errors.

### WRONG: Mismatched key structure

```json
// en.i18n.json -- has nested group
{ "auth": { "errors": { "emailRequired": "..." } } }

// ru.i18n.json -- missing nesting
{ "auth": { "emailRequired": "..." } }
// WRONG -- structures must match exactly
```

### WRONG: Using l10n instead of translations

The folder was renamed from `l10n` to `translations`. Use:
- Folder: `lib/core/translations/`
- Command: `make translations`

---

## References

- `lib/core/translations/en.i18n.json` -- English source
- `lib/core/translations/ru.i18n.json` -- Russian source
- `lib/core/translations/generated/translations.g.dart` -- Generated code
- `docs/fundamentals/development-workflow.md` -- Translations workflow section
- `slang.yaml` -- Slang configuration
