# Barrel File Conventions

> **📌 Single Source of Truth**: This document is the canonical reference for barrel file rules. `CLAUDE.md` and `MEMORY.md` contain only brief summaries with links here.

Barrel files re-export related Dart files through a single `export` file, reducing import noise and enforcing module boundaries.

---

## Rules

### 1. Two-level barrel hierarchy per feature

Each subfolder inside a layer has its own **sub-barrel** file named after the folder. The layer barrel re-exports only sub-barrels (never individual files).

```
features/auth/
  ├── domain/
  │   ├── domain.dart                # Layer barrel → exports sub-barrels
  │   ├── entities/
  │   │   ├── entities.dart          # Sub-barrel → exports auth_tokens.dart, user.dart
  │   │   ├── auth_tokens.dart
  │   │   └── user.dart
  │   └── repositories/
  │       ├── repositories.dart      # Sub-barrel → exports auth_repository.dart
  │       └── auth_repository.dart
  ├── data/
  │   ├── data.dart                  # Layer barrel → exports sub-barrels
  │   ├── datasources/
  │   │   ├── datasources.dart       # Sub-barrel
  │   │   └── auth_remote_datasource.dart
  │   ├── models/
  │   │   ├── models.dart            # Sub-barrel
  │   │   ├── auth_tokens_dto.dart
  │   │   └── ...
  │   └── repositories/
  │       ├── repositories.dart      # Sub-barrel
  │       └── auth_repository_impl.dart
  └── presentation/
      ├── presentation.dart          # Layer barrel → exports sub-barrels
      ├── controllers/
      │   ├── controllers.dart       # Sub-barrel
      │   └── ...
      ├── pages/
      │   ├── pages.dart             # Sub-barrel
      │   └── ...
      └── widgets/
          ├── widgets.dart           # Sub-barrel
          └── ...
```

**Example -- sub-barrel `entities/entities.dart`:**

```dart
export 'auth_tokens.dart';
export 'user.dart';
```

**Example -- layer barrel `domain.dart` (re-exports sub-barrels only):**

```dart
export 'entities/entities.dart';
export 'repositories/repositories.dart';
```

### 2. One barrel per core subfolder

Each subfolder inside `core/` has its own barrel file named after the folder:

```
core/
  ├── constants/
  │   └── constants.dart       # exports api_endpoints.dart, app_durations.dart
  ├── network/
  │   └── network.dart         # exports dio_provider.dart, api_interceptor.dart, api_exception.dart
  ├── storage/
  │   └── storage.dart         # exports database/, secure_storage, shared_prefs
  └── ...
```

**Exception -- Three-level hierarchy for deeply nested core subfolders:**

Some core subfolders contain nested subfolders with their own sub-barrels. In this case, use a three-level hierarchy:

```
core/widgets/
  ├── widgets.dart              # Core barrel → exports sub-barrels + individual files
  ├── app_button.dart           # Individual file
  ├── loading_overlay.dart      # Individual file
  └── text_fields/
      ├── text_fields.dart      # Sub-barrel → exports individual TextField widgets
      ├── email_text_field.dart
      ├── password_text_field.dart
      └── ...
```

**Example -- core barrel `widgets/widgets.dart`:**

```dart
export 'app_button.dart';           // Individual file at top level
export 'loading_overlay.dart';
export 'text_fields/text_fields.dart';  // Sub-barrel for nested subfolder
```

**Example -- sub-barrel `text_fields/text_fields.dart`:**

```dart
export 'email_text_field.dart';
export 'password_text_field.dart';
export 'text_field_validators.dart';
```

**When to use three-level hierarchy:**
- Core subfolder contains both individual files AND nested subfolders
- Nested subfolder has 3+ files (deserves its own sub-barrel)

**Decision rule:**
- **1-2 files** in nested subfolder → export individual files directly from core barrel
- **3+ files** in nested subfolder → create sub-barrel, export sub-barrel from core barrel

### 3. Aggregate `core.dart` barrel

The file `lib/core/core.dart` re-exports all core subfolder barrels and individual files for folders without a dedicated barrel:

```dart
export 'app/app_reloader.dart';
export 'constants/constants.dart';
export 'environment/app_config.dart';
export 'environment/secrets.dart';
export 'exceptions/app_exception.dart';
export 'extensions/extensions.dart';
export 'inspector/inspector.dart';
export 'network/network.dart';
export 'router/router.dart';
export 'storage/storage.dart';
export 'theme/theme.dart';
export 'utils/debug_print.dart';
export 'widgets/widgets.dart';
```

Some small subfolders (`app/`, `environment/`, `exceptions/`, `utils/`) contain only 1–2 files and do not have a dedicated barrel — they are exported directly from `core.dart`. For these, import the specific file (e.g. `core/utils/debug_print.dart`).

Import `core.dart` when you need several core modules at once. Import a specific subfolder barrel (e.g. `network/network.dart`) when you need just one.

### 4. NO barrel for the entire feature

There is **no** `auth.dart` file that re-exports `domain.dart` + `data.dart` + `presentation.dart`. Each layer is imported separately. This prevents accidental coupling and circular dependencies.

### 5. New files added to barrel immediately

When you create a new file, add its `export` line to the corresponding barrel **in the same commit**. Do not leave dangling files outside a barrel.

### 6. Between features -- import only via domain barrel

When feature A needs something from feature B, it must import only from B's `domain.dart` barrel. Never import from another feature's `data.dart` or `presentation.dart`.

```dart
// CORRECT -- importing auth domain from home feature
import 'package:fandag/features/auth/domain/domain.dart';

// WRONG -- importing auth data layer from another feature
import 'package:fandag/features/auth/data/data.dart';
```

### 7. Translations are NOT in a barrel

The `core/translations/` directory contains JSON source files and auto-generated slang translations. These are **not** re-exported through any barrel. Import the generated file directly where needed:

```dart
import 'package:fandag/core/translations/generated/translations.g.dart';
```

This is because the generated translation code has its own import structure and should not be mixed into the `core.dart` aggregate.

---

## Quick Reference

| Scope | Barrel file | Exports |
|-------|-------------|---------|
| Feature sub-barrel | `features/<f>/<layer>/<subfolder>/<subfolder>.dart` | Individual files in that subfolder |
| Feature layer barrel | `features/<f>/domain/domain.dart` | Sub-barrels (entities, repositories) |
| Feature layer barrel | `features/<f>/data/data.dart` | Sub-barrels (datasources, models, repositories) |
| Feature layer barrel | `features/<f>/presentation/presentation.dart` | Sub-barrels (controllers, pages, widgets) |
| Core subfolder | `core/<subfolder>/<subfolder>.dart` | All files in that subfolder |
| Core aggregate | `core/core.dart` | All core subfolder barrels |
| Feature aggregate | **does not exist** | -- |
| Translations | **does not exist** | Import generated file directly |

---

## Checklist When Adding a File

1. Create the file in the correct directory.
2. Open the **sub-barrel** file for that subfolder (e.g. `models/models.dart`).
3. Add an `export '<file_name>.dart';` line to the sub-barrel **in alphabetical order** (see Export Sorting Rules below).
4. If this is a **new subfolder**, also create its sub-barrel and add it to the layer barrel (e.g. `data.dart`).
5. Commit the barrel changes together with the new file.

---

## Export Sorting Rules

**All exports in barrel files MUST be sorted alphabetically using these rules:**

1. **Sort by file name** (not by exported symbol)
2. **Case-insensitive ASCII sort** (treat 'A' and 'a' as same character)
3. **One export per line**
4. **No blank lines** between exports
5. **Sub-barrel exports** (e.g. `entities/entities.dart`) follow same alphabetical rules

**Examples:**

```dart
// ✅ CORRECT -- alphabetically sorted, case-insensitive
export 'auth_tokens.dart';      // 'a' comes first
export 'session.dart';           // 's' comes after 'a'
export 'user.dart';              // 'u' comes last
```

```dart
// ✅ CORRECT -- underscores treated as regular characters
export 'api_client.dart';        // 'api_' comes before 'auth_'
export 'auth_repository.dart';
```

```dart
// ✅ CORRECT -- longer names with same prefix
export 'user.dart';              // shorter name first
export 'user_profile.dart';      // longer name after
```

```dart
// ❌ WRONG -- not alphabetically sorted
export 'user.dart';
export 'auth_tokens.dart';       // Should be first!
export 'session.dart';
```

```dart
// ❌ WRONG -- blank lines between exports
export 'auth_tokens.dart';

export 'user.dart';              // Remove blank line
```

**Inserting new exports:**

When adding a new file to a barrel, insert its export in the correct alphabetical position (not at the end):

```dart
// BEFORE (existing barrel):
export 'auth_tokens.dart';
export 'user.dart';

// AFTER (adding session.dart):
export 'auth_tokens.dart';
export 'session.dart';      // ← inserted in alphabetical order
export 'user.dart';
```
