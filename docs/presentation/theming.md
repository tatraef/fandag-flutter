# Theming

ThemeColors, PrimaryThemeFonts, light/dark themes, and context extensions.

---

## Anti-Patterns

### WRONG: `Theme.of(context)` instead of context extension

```dart
// WRONG -- verbose, bypasses semantic color system
final Color errorColor = Theme.of(context).colorScheme.error;

// CORRECT -- use context extension for semantic colors
final Color errorColor = context.colors.error;
```

### WRONG: Hardcoded color values

```dart
// WRONG -- hardcoded color, won't adapt to dark mode
Text('Error', style: TextStyle(color: Color(0xFFB00020)));

// CORRECT -- use semantic color token
Text('Error', style: TextStyle(color: context.colors.error));
```

---

## Architecture

```
app_colors.dart              -> Raw color palette (static constants)
theme_colors.dart            -> ThemeExtension<ThemeColors> -- semantic color tokens (light + dark)
primary_fonts.dart           -> ThemeExtension<PrimaryThemeFonts> -- text style variants
app_theme_data.dart          -> Combines colors + fonts into extensions list
light_theme.dart             -> ThemeData for light mode
dark_theme.dart              -> ThemeData for dark mode
theme_context_extension.dart -> BuildContext extensions (context.colors, context.primaryFonts)
```

---

## ThemeColors

14 semantic color tokens that adapt to light/dark mode:

| Field | Purpose | Light | Dark |
|-------|---------|-------|------|
| `textPrimary` | Main text | grey900 | white |
| `textSecondary` | Secondary/subtitle text | grey600 | grey400 |
| `textTertiary` | Hints, placeholders | grey400 | grey600 |
| `textInverse` | Text on colored backgrounds | white | grey900 |
| `backgroundPrimary` | Page background | backgroundLight (#F5F5F5) | backgroundDark (#1E1E1E) |
| `backgroundSecondary` | Card/section background | white | surfaceDark (#121212) |
| `surfacePrimary` | AppBar, elevated surfaces | surfaceLight (white) | surfaceDark (#121212) |
| `surfaceSecondary` | Input fields, subtle surfaces | grey100 | grey800 |
| `border` | Input borders, dividers | grey300 | grey700 |
| `divider` | Thin separators | grey200 | grey800 |
| `accent` | Primary action color | primary (#2196F3) | primaryLight (#64B5F6) |
| `error` | Error states | error (#B00020) | errorLight (#EF5350) |
| `success` | Success states | success (#4CAF50) | success (#4CAF50) |
| `warning` | Warning states | warning (#FFC107) | warning (#FFC107) |

### Usage

```dart
// Access via context extension
context.colors.textPrimary
context.colors.accent
context.colors.error

// Example in widget (from post_card.dart)
Text(
  post.body,
  style: context.primaryFonts.regular14.copyWith(
    color: context.colors.textSecondary,
  ),
)

Icon(Icons.delete_outline, color: context.colors.error)
```

---

## PrimaryThemeFonts

16 text style variants organized by weight and size:

| Variant | Size | Weight |
|---------|------|--------|
| `regular12` | 12 | w400 (Regular) |
| `regular14` | 14 | w400 |
| `regular16` | 16 | w400 |
| `medium12` | 12 | w500 (Medium) |
| `medium14` | 14 | w500 |
| `medium16` | 16 | w500 |
| `semibold14` | 14 | w600 (SemiBold) |
| `semibold16` | 16 | w600 |
| `semibold18` | 18 | w600 |
| `semibold20` | 20 | w600 |
| `semibold24` | 24 | w600 |
| `bold16` | 16 | w700 (Bold) |
| `bold20` | 20 | w700 |
| `bold24` | 24 | w700 |
| `bold28` | 28 | w700 |
| `bold32` | 32 | w700 |

### Usage

```dart
// Access via context extension
context.primaryFonts.semibold16
context.primaryFonts.regular14
context.primaryFonts.bold24

// With color override (from post_card.dart)
Text(
  post.title,
  style: context.primaryFonts.semibold16,
)

Text(
  post.body,
  style: context.primaryFonts.regular14.copyWith(
    color: context.colors.textSecondary,
  ),
)
```

---

## Context Extensions

### Theme extensions (lib/core/theme/theme_context_extension.dart)

```dart
extension ThemeContextExtension on BuildContext {
  ThemeColors get colors => Theme.of(this).extension<ThemeColors>()!;

  PrimaryThemeFonts get primaryFonts =>
      Theme.of(this).extension<PrimaryThemeFonts>()!;
}
```

### General extensions (lib/core/extensions/context_ext.dart)

```dart
extension ContextExt on BuildContext {
  ThemeData get theme => Theme.of(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get screenSize => mediaQuery.size;

  double get screenWidth => screenSize.width;

  double get screenHeight => screenSize.height;

  EdgeInsets get viewPadding => mediaQuery.viewPadding;

  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(message)));
  }
}
```

### Quick Reference

| Extension | Access |
|-----------|--------|
| Semantic colors | `context.colors.fieldName` |
| Text styles | `context.primaryFonts.variantName` |
| Standard theme | `context.theme` |
| Screen width | `context.screenWidth` |
| Screen height | `context.screenHeight` |
| View padding (safe area) | `context.viewPadding` |
| Show snackbar | `context.showSnackBar('message')` |
| Translations | `context.t.group.key` |

---

## AppThemeData

Combines colors and fonts into a single configuration object:

```dart
// lib/core/theme/app_theme_data.dart
class AppThemeData {
  const AppThemeData({required this.colors, required this.fonts});

  final ThemeColors colors;
  final PrimaryThemeFonts fonts;

  static const AppThemeData light = AppThemeData(
    colors: ThemeColors.light,
    fonts: PrimaryThemeFonts.instance,
  );

  static const AppThemeData dark = AppThemeData(
    colors: ThemeColors.dark,
    fonts: PrimaryThemeFonts.instance,
  );

  List<ThemeExtension<dynamic>> get extensions => <ThemeExtension<dynamic>>[
    colors,
    fonts,
  ];
}
```

---

## Light/Dark Theme

### Light Theme (lib/core/theme/light_theme.dart)

```dart
ThemeData lightTheme() {
  const AppThemeData themeData = AppThemeData.light;

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: themeData.colors.backgroundPrimary,
    appBarTheme: AppBarTheme(
      backgroundColor: themeData.colors.surfacePrimary,
      foregroundColor: themeData.colors.textPrimary,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: themeData.colors.accent,
        foregroundColor: themeData.colors.textInverse,
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: themeData.colors.surfaceSecondary,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: themeData.colors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: themeData.colors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: themeData.colors.accent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: themeData.colors.error),
      ),
    ),
    extensions: themeData.extensions,
  );
}
```

### Dark Theme (lib/core/theme/dark_theme.dart)

The dark theme follows the same structure, using `AppThemeData.dark` and `Brightness.dark`.

### Theme Mode

Theme mode is set to `ThemeMode.system` in `app.dart` -- the app follows OS preference automatically:

```dart
MaterialApp.router(
  theme: lightTheme(),
  darkTheme: darkTheme(),
  themeMode: ThemeMode.system,
  // ...
)
```

---

## Adding New Colors

1. Add raw color to `AppColors` in `lib/core/theme/app_colors.dart`
2. Add semantic field to `ThemeColors` in `lib/core/theme/theme_colors.dart`:
   - Add field declaration
   - Add to constructor
   - Add to `ThemeColors.light` and `ThemeColors.dark`
   - Add to `copyWith()`
   - Add to `lerp()`
3. No code generation needed

## Adding New Font Styles

1. Add field to `PrimaryThemeFonts` in `lib/core/theme/primary_fonts.dart`:
   - Add field declaration
   - Add to constructor
   - Add to `PrimaryThemeFonts.instance` with size and weight
   - Add to `copyWith()`
   - Add to `lerp()`
2. No code generation needed

---

## Raw Color Palette

All raw colors are in `lib/core/theme/app_colors.dart`:

```dart
abstract class AppColors {
  // Primary
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryLight = Color(0xFF64B5F6);
  static const Color primaryDark = Color(0xFF1976D2);

  // Secondary
  static const Color secondary = Color(0xFF03DAC6);
  static const Color secondaryLight = Color(0xFF66FFF9);
  static const Color secondaryDark = Color(0xFF00A896);

  // Neutral
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Semantic
  static const Color error = Color(0xFFB00020);
  static const Color errorLight = Color(0xFFEF5350);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);

  // Surface
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF121212);
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF1E1E1E);
}
```
