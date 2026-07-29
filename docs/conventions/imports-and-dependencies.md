# Imports & Dependencies

Import ordering, no relative imports, fixed dependency versions, and cross-feature rules.

---

## Import Order

Imports must follow this order, separated by blank lines:

```dart
// 1. dart: imports
import 'dart:async';
import 'dart:io';

// 2. package: imports (third-party)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// 3. project imports
import 'package:fandag/core/core.dart';
import 'package:fandag/features/auth/domain/domain.dart';
```

Within each group, imports are sorted alphabetically.

---

## No Relative Imports

Always use `package:fandag/...` — never relative paths.

```dart
// WRONG — relative import
import '../domain/entities/user.dart';
import '../../core/network/network.dart';

// CORRECT — package import
import 'package:fandag/features/auth/domain/domain.dart';
import 'package:fandag/core/network/network.dart';
```

Enforced by the `always_use_package_imports` lint rule.

---

## Import via Barrels (Strict Rules)

### Feature Imports — ALWAYS use layer barrels

```dart
// ✅ CORRECT — import via layer barrel
import 'package:fandag/features/auth/domain/domain.dart';
import 'package:fandag/features/home/presentation/presentation.dart';

// ❌ WRONG — skip barrel and import individual file
import 'package:fandag/features/auth/domain/entities/user.dart';
```

**Rule:** Features always use barrel imports. Never import individual files from features.

---

### Core Imports — Decision Table

Core modules are split into two categories:

**1. Core folders WITH dedicated barrel** (use barrel import):

| Folder | Barrel File | Import Path |
|--------|-------------|-------------|
| `constants/` | `constants.dart` | `package:fandag/core/constants/constants.dart` |
| `extensions/` | `extensions.dart` | `package:fandag/core/extensions/extensions.dart` |
| `network/` | `network.dart` | `package:fandag/core/network/network.dart` |
| `router/` | `router.dart` | `package:fandag/core/router/router.dart` |
| `storage/` | `storage.dart` | `package:fandag/core/storage/storage.dart` |
| `theme/` | `theme.dart` | `package:fandag/core/theme/theme.dart` |
| `widgets/` | `widgets.dart` | `package:fandag/core/widgets/widgets.dart` |

**Example:**

```dart
// ✅ CORRECT — use barrel
import 'package:fandag/core/network/network.dart';
import 'package:fandag/core/theme/theme.dart';

// ❌ WRONG — skip barrel
import 'package:fandag/core/network/api_client.dart';
import 'package:fandag/core/theme/app_theme.dart';
```

---

**2. Core folders WITHOUT dedicated barrel** (import specific file):

| Folder | Import Directly |
|--------|----------------|
| `app/` | `package:fandag/core/app/app_reloader.dart` |
| `environment/` | `package:fandag/core/environment/app_config.dart` |
| | `package:fandag/core/environment/secrets.dart` |
| `exceptions/` | `package:fandag/core/exceptions/app_exception.dart` |
| `inspector/` | `package:fandag/core/inspector/inspector.dart` |
| `utils/` | `package:fandag/core/utils/debug_print.dart` |

**Example:**

```dart
// ✅ CORRECT — import specific file (no barrel exists)
import 'package:fandag/core/utils/debug_print.dart';
import 'package:fandag/core/environment/app_config.dart';

// ❌ WRONG — these barrels don't exist
import 'package:fandag/core/utils/utils.dart';  // No such file!
import 'package:fandag/core/environment/environment.dart';  // No such file!
```

---

**3. Aggregate `core/core.dart` — when to use:**

```dart
// ✅ CORRECT — importing 3+ core modules
import 'package:fandag/core/core.dart';
// Provides: constants, extensions, network, router, storage, theme, widgets, exceptions, etc.

// ❌ AVOID — using aggregate for single module
import 'package:fandag/core/core.dart';  // Just to get ApiClient
// Better: import 'package:fandag/core/network/network.dart';
```

**Decision rule:**
- **1-2 core imports** → Use specific barrels/files
- **3+ core imports** → Use `core/core.dart` aggregate

---

### Special Case: Translations

```dart
// ✅ CORRECT — import generated translations directly
import 'package:fandag/core/translations/generated/translations.g.dart';

// ❌ WRONG — no barrel exists for translations
import 'package:fandag/core/translations/translations.dart';  // Doesn't exist
```

---

## Cross-Feature Imports

When feature A needs something from feature B, import **only** B's domain barrel:

```dart
// CORRECT — import domain barrel of another feature
import 'package:fandag/features/auth/domain/domain.dart';

// WRONG — importing data layer of another feature
import 'package:fandag/features/auth/data/data.dart';

// WRONG — importing presentation layer of another feature
import 'package:fandag/features/auth/presentation/presentation.dart';
```

**Exception:** `app_router.dart` imports presentation barrels to reference page widgets for route builders. This is the only legitimate cross-feature presentation import.

---

## Fixed Dependency Versions

All dependency versions in `pubspec.yaml` are **pinned** — no `^` prefix:

```yaml
# CORRECT — pinned version
dependencies:
  flutter_riverpod: 3.1.0
  go_router: 17.1.0
  dio: 5.9.2

# WRONG — caret version
dependencies:
  flutter_riverpod: ^3.1.0
```

Updates are manual and intentional. This prevents unexpected breaking changes from automatic version resolution.

---

## Part Directives

`part` and `part of` directives go after all imports:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in_controller.freezed.dart';
part 'sign_in_controller.g.dart';
```

**Order of parts:**
1. `.freezed.dart` first
2. `.g.dart` second

---

## What Each Layer Can Import

| Layer | Can Import | Cannot Import |
|-------|-----------|---------------|
| **domain** | `freezed_annotation` only | Flutter, Dio, data layer, presentation layer |
| **data** | Own domain barrel, `core/` modules, `dio`, `freezed_annotation`, `json_annotation` | Presentation layer, other features' data |
| **presentation** | Own domain barrel, own data barrel (via providers file), `core/` modules, `flutter`, `flutter_riverpod`, `riverpod_annotation`, `go_router` | Other features' data/presentation |
| **core** | `dart:`, third-party packages | Feature code |
