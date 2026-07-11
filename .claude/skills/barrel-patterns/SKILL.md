---
name: barrel-patterns
description: Two-level barrel file hierarchy for features. Auto-loads when creating barrel files, exports, or discussing file organization.
user-invocable: false
---

# Barrel File Patterns

This project uses a **two-level barrel hierarchy** for features: sub-barrels per subfolder, layer barrels that re-export only sub-barrels.

## The Two Levels

```
Layer barrel (domain.dart)     →  exports only sub-barrels
  └── Sub-barrel (entities.dart)  →  exports individual files
```

**Critical rule**: Layer barrels NEVER export individual files — only sub-barrels.

## Full Feature Barrel Structure

```
lib/features/<feature>/
├── domain/
│   ├── domain.dart                 # Layer barrel
│   ├── entities/
│   │   ├── entities.dart           # Sub-barrel
│   │   ├── user.dart
│   │   └── auth_tokens.dart
│   └── repositories/
│       ├── repositories.dart       # Sub-barrel
│       └── auth_repository.dart
├── data/
│   ├── data.dart                   # Layer barrel
│   ├── models/
│   │   ├── models.dart             # Sub-barrel
│   │   ├── user_dto.dart
│   │   └── sign_in_request.dart
│   ├── datasources/
│   │   ├── datasources.dart        # Sub-barrel
│   │   └── auth_remote_datasource.dart
│   └── repositories/
│       ├── repositories.dart       # Sub-barrel
│       ├── auth_repository_impl.dart
│       └── mock_auth_repository.dart
└── presentation/
    ├── presentation.dart           # Layer barrel
    ├── controllers/
    │   ├── controllers.dart        # Sub-barrel
    │   ├── auth_providers.dart
    │   └── sign_in_controller.dart
    ├── pages/
    │   ├── pages.dart              # Sub-barrel
    │   └── sign_in_page.dart
    └── widgets/
        ├── widgets.dart            # Sub-barrel
        └── auth_form_field.dart
```

## Sub-Barrel Template

Exports individual files within the subfolder:

```dart
// domain/entities/entities.dart
export 'user.dart';
export 'auth_tokens.dart';
```

```dart
// data/models/models.dart
export 'user_dto.dart';
export 'sign_in_request.dart';
export 'sign_up_request.dart';
```

```dart
// presentation/controllers/controllers.dart
export 'auth_providers.dart';
export 'auth_state_controller.dart';
export 'sign_in_controller.dart';
```

## Layer Barrel Template

Exports ONLY sub-barrels — never individual files:

```dart
// domain/domain.dart
export 'entities/entities.dart';
export 'repositories/repositories.dart';
```

```dart
// data/data.dart
export 'datasources/datasources.dart';
export 'models/models.dart';
export 'repositories/repositories.dart';
```

```dart
// presentation/presentation.dart
export 'controllers/controllers.dart';
export 'pages/pages.dart';
export 'widgets/widgets.dart';
```

## Real Examples

### Auth Feature — Domain Layer

```dart
// lib/features/auth/domain/entities/entities.dart
export 'auth_tokens.dart';
export 'user.dart';

// lib/features/auth/domain/repositories/repositories.dart
export 'auth_repository.dart';

// lib/features/auth/domain/domain.dart
export 'entities/entities.dart';
export 'repositories/repositories.dart';
```

### Home Feature — Full Stack

```dart
// lib/features/home/domain/entities/entities.dart
export 'post.dart';

// lib/features/home/domain/repositories/repositories.dart
export 'home_repository.dart';

// lib/features/home/domain/domain.dart
export 'entities/entities.dart';
export 'repositories/repositories.dart';

// lib/features/home/data/models/models.dart
export 'post_dto.dart';

// lib/features/home/data/datasources/datasources.dart
export 'home_remote_datasource.dart';

// lib/features/home/data/repositories/repositories.dart
export 'home_repository_impl.dart';

// lib/features/home/data/data.dart
export 'datasources/datasources.dart';
export 'models/models.dart';
export 'repositories/repositories.dart';

// lib/features/home/presentation/controllers/controllers.dart
export 'home_controller.dart';

// lib/features/home/presentation/pages/pages.dart
export 'home_page.dart';

// lib/features/home/presentation/widgets/widgets.dart
export 'post_card.dart';

// lib/features/home/presentation/presentation.dart
export 'controllers/controllers.dart';
export 'pages/pages.dart';
export 'widgets/widgets.dart';
```

## Core Barrels

Core uses a flat barrel per subfolder, all re-exported from `core.dart`:

```dart
// lib/core/network/network.dart
export 'api_exception.dart';
export 'api_interceptor.dart';
export 'dio_provider.dart';

// lib/core/core.dart
export 'app/app_reloader.dart';
export 'constants/constants.dart';
export 'environment/app_config.dart';
export 'exceptions/app_exception.dart';
export 'extensions/extensions.dart';
export 'network/network.dart';
export 'router/router.dart';
export 'storage/storage.dart';
export 'theme/theme.dart';
export 'widgets/widgets.dart';
```

## When Adding a New File

1. Create the file in the correct subfolder
2. Add `export 'file_name.dart';` to the **sub-barrel** of that subfolder
3. Do NOT touch the layer barrel

## When Creating a New Subfolder

1. Create the subfolder
2. Create a sub-barrel file inside it (e.g., `new_folder/new_folder.dart`)
3. Add `export 'new_folder/new_folder.dart';` to the **layer barrel**

## Cross-Feature Imports

Import other features only via their **domain barrel**:

```dart
// CORRECT — import via domain barrel
import 'package:flutter_template_v3/features/auth/domain/domain.dart';

// WRONG — importing individual files from another feature
import 'package:flutter_template_v3/features/auth/domain/entities/user.dart';

// WRONG — importing data layer from another feature
import 'package:flutter_template_v3/features/auth/data/data.dart';
```

## Anti-Patterns

```dart
// BAD: layer barrel exports individual files
// domain/domain.dart
export 'entities/user.dart';            // WRONG — should be entities/entities.dart
export 'repositories/auth_repository.dart';  // WRONG — should be repositories/repositories.dart

// BAD: relative imports
import '../entities/user.dart';  // WRONG
// CORRECT: import 'package:flutter_template_v3/features/auth/domain/domain.dart';

// BAD: missing sub-barrel — new file not exported
// Created user.dart but forgot to add to entities/entities.dart

// BAD: exporting data/presentation from cross-feature import
import 'package:flutter_template_v3/features/auth/data/data.dart';
// WRONG — cross-feature imports only via domain barrel
```
