---
name: primary-fonts-patterns
description: PrimaryThemeFonts patterns for adding typography styles. Auto-loads when modifying theme fonts.
user-invocable: false
---

# PrimaryThemeFonts Patterns

## Overview

`PrimaryThemeFonts` provides consistent typography styles as a ThemeExtension.

**Generated from:** `tools/template_scripts/config/fonts.yaml`
**Generated file:** `lib/core/theme/primary_fonts.dart`

**Usage in widgets:**
```dart
Text('Title', style: context.primaryFonts.semibold24);
Text('Body', style: context.primaryFonts.regular14);

// Override color
Text('Error', style: context.primaryFonts.regular14.copyWith(color: context.colors.error));
```

---

## CRITICAL: Never Use Inline TextStyle

**FORBIDDEN:**
```dart
// NEVER do this
Text('Hello', style: TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w600,
  color: colors.textPrimary,
))
```

**REQUIRED:**
```dart
// Use PrimaryThemeFonts
Text('Hello', style: context.primaryFonts.semibold14)

// Override only color
Text('Hello', style: context.primaryFonts.semibold14.copyWith(color: colors.error))
```

---

## Font Naming Convention

Format: `<weight><size>`

| Weight | FontWeight | Examples |
|--------|------------|----------|
| `regular` | w400 | `regular12`, `regular14`, `regular16` |
| `medium` | w500 | `medium12`, `medium14`, `medium16` |
| `semibold` | w600 | `semibold14`, `semibold16`, `semibold18`, `semibold20`, `semibold24` |
| `bold` | w700 | `bold16`, `bold20`, `bold24`, `bold28`, `bold32` |

---

## Adding New Font Style - CLI Command

**IMPORTANT:** Never edit Dart or YAML files manually. Use CLI:

```bash
fvm dart run tools/template_scripts/bin/template_scripts.dart add-font \
  --name "semibold28" \
  --size 28 \
  --weight 600 \
  --doc "Subheadings, section titles"
```

**Parameters:**
- `--name` - camelCase style name (format: `<weight><size>`)
- `--size` - Font size in pixels (e.g., `28`)
- `--weight` - Font weight: `400` (regular), `500` (medium), `600` (semibold), `700` (bold)
- `--doc` - Use case description

**Result:** Updates `fonts.yaml` + regenerates `primary_fonts.dart`

---

## Complete Example

```bash
# 1. Check if style exists in tools/template_scripts/config/fonts.yaml
# 2. Add font style
fvm dart run tools/template_scripts/bin/template_scripts.dart add-font \
  --name "semibold28" --size 28 --weight 600 --doc "Section titles"
# 3. Use in widget
Text('Section Title', style: context.primaryFonts.semibold28)
```

---

## Existing Font Styles

Check `tools/template_scripts/config/fonts.yaml` for all available styles and their weights/sizes.

---

## Checklist

- [ ] **NO inline `TextStyle()` in widget** - must use `context.primaryFonts.*`
- [ ] Checked `fonts.yaml` for existing styles
- [ ] Added with CLI command `add-font`
- [ ] Named as `<weight><size>` (e.g., `semibold20`)
- [ ] Used correct weight: 400, 500, 600, or 700
- [ ] For color override only - used `.copyWith(color: ...)` on existing style
