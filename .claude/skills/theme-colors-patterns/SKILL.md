---
name: theme-colors-patterns
description: ThemeColors patterns for adding semantic, theme-aware colors. Auto-loads when modifying theme colors.
user-invocable: false
---

# ThemeColors Patterns

## Overview

`ThemeColors` provides semantic, theme-aware colors that adapt between light and dark themes.

**Generated from:** `tools/template_scripts/config/theme_colors.yaml`
**Generated file:** `lib/core/theme/theme_colors.dart`

**Usage in widgets:**
```dart
final colors = context.colors;
Container(color: colors.surfacePrimary);
Text('Hello', style: TextStyle(color: colors.textPrimary));
```

---

## Two-Layer Color System

### Layer 1: AppColors - Raw Palette

**Config:** `tools/template_scripts/config/palette_colors.yaml`
**Generated:** `lib/core/theme/app_colors.dart`

Defines raw colors by **visual appearance**:
- `white`, `grey400`, `primary` - what the color IS
- Static constants, no theme logic
- Only edited via CLI (never manually)

### Layer 2: ThemeColors - Semantic Usage

**Config:** `tools/template_scripts/config/theme_colors.yaml`
**Generated:** `lib/core/theme/theme_colors.dart`

Maps palette colors to **semantic meanings**:
- `textPrimary`, `backgroundPrimary`, `accent` - where it's USED
- Theme-aware (adaptive or static)
- Uses `static const ThemeColors light` / `static const ThemeColors dark`
- Only edited via CLI (never manually)

**Example YAML:**
```yaml
colors:
  # Adaptive (different in light/dark)
  textPrimary:
    light: grey900
    dark: white
    doc: "Primary text color"

  # Static (same in both themes)
  success:
    value: success
    doc: "Success color"
```

---

## Adding Colors - CLI Commands

**IMPORTANT:** Never edit Dart or YAML files manually. Use CLI commands:

### Add Raw Color to Palette

```bash
fvm dart run tools/template_scripts/bin/template_scripts.dart add-palette-color \
  --name "coralSoft" \
  --hex "FFE07A7C" \
  --doc "Soft coral shade" \
  --section "Semantic"
```

**Parameters:**
- `--name` - camelCase (e.g., `coralSoft`, `grey50`)
- `--hex` - 8-digit hex with alpha (e.g., `FFFF0000`, `80FFFFFF`)
- `--doc` - Color description (visual, not usage)
- `--section` - Optional section (creates if not found)

### Add Semantic Color to ThemeColors

```bash
# Adaptive color (light/dark)
fvm dart run tools/template_scripts/bin/template_scripts.dart add-theme-color \
  --name "cardBackground" \
  --light "white" \
  --dark "grey800" \
  --doc "Card background - adapts to theme"

# Static color (same in both)
fvm dart run tools/template_scripts/bin/template_scripts.dart add-theme-color \
  --name "buttonPrimary" \
  --value "primary" \
  --doc "Primary button background"
```

**Parameters:**
- `--name` - camelCase semantic name (e.g., `buttonPrimary`, `cardBackground`)
- `--light` + `--dark` - AppColors names for adaptive (use BOTH)
- `--value` - AppColors name for static (use INSTEAD of light/dark)
- `--doc` - Semantic description

---

## Color Naming Convention

Use widget-prefixed semantic names in ThemeColors:

| Suffix | Purpose | Example |
|--------|---------|---------|
| `Background` | Main background fill | `cardBackground`, `inputBackground` |
| `Foreground` | Text/icon on background | `buttonForeground` |
| `Border` | Border/outline color | `inputBorder`, `cardBorder` |
| `Active` | Active/selected state | `tabActive` |
| `Inactive` | Inactive/disabled state | `buttonInactive` |
| `Text` | Specific text color | `hintText` |

---

## Existing Colors

Check YAML configs ONLY (never read generated Dart files):
- `tools/template_scripts/config/theme_colors.yaml` - semantic colors
- `tools/template_scripts/config/palette_colors.yaml` - raw palette colors

---

## Checklist

- [ ] Grepped `theme_colors.yaml` for existing semantic colors
- [ ] Grepped `palette_colors.yaml` for raw color
- [ ] If missing, added raw color with `add-palette-color`
- [ ] Added semantic color with `add-theme-color`
- [ ] Used widget prefix + semantic suffix for naming
- [ ] Chose adaptive (--light/--dark) or static (--value)
- [ ] Used `context.colors.x` in widget (not AppColors directly)
- [ ] **NEVER** read/grep generated Dart files for verification
