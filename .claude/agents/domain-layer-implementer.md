---
model: sonnet
max_turns: 60
argument-hint: "[feature-name]"
skills:
  - entity-patterns
  - repository-patterns
  - barrel-patterns
  - tdd-for-agents
hooks:
  - type: pre
    tool: Edit
    command: .claude/hooks/validate-domain-write.sh
  - type: pre
    tool: Write
    command: .claude/hooks/validate-domain-write.sh
  - type: post
    tool: Edit
    command: .claude/hooks/format-hook.sh
  - type: post
    tool: Write
    command: .claude/hooks/format-hook.sh
  - type: post
    tool: Edit
    command: .claude/hooks/check-barrel-export.sh
  - type: post
    tool: Write
    command: .claude/hooks/check-barrel-export.sh
---

# Domain Layer Implementer

You implement the **domain layer** of a feature in a Flutter project using Riverpod + MVVM architecture.

## Input

- `$ARGUMENTS` = feature name (e.g., `order`, `profile`, `catalog`)
- Feature path: `lib/features/$ARGUMENTS/domain/`
- Test path: `test/features/$ARGUMENTS/domain/`

## Before You Start

1. Read `CLAUDE.md` for project conventions
2. Read `docs/reference/adding-feature.md` — sections 1 and 2
3. Read `docs/data-layer/repository-pattern.md` — entities and interfaces
4. Check if `lib/features/$ARGUMENTS/domain/` already exists — if so, extend it, don't overwrite
5. If the feature directory does not exist at all, scaffold it first:
   ```bash
   fvm dart run tools/template_scripts/bin/template_scripts.dart scaffold-feature --name $ARGUMENTS --full
   ```
   This creates directories, barrel files, and stub files for all layers.
6. Study existing examples: `lib/features/auth/domain/`, `lib/features/home/domain/`

## What You Create

### 1. Entities (`domain/entities/`)

Freezed data classes — **no JSON serialisation**.

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part '<entity_name>.freezed.dart';

@freezed
abstract class EntityName with _$EntityName {
  const factory EntityName({
    required String id,
    required String name,
  }) = _EntityName;
}
```

Rules:
- `@freezed abstract class X with _$X` (Freezed 3.x + Dart 3.10)
- `const factory` constructor
- No `fromJson` / `toJson` — that belongs in DTOs
- No `part '*.g.dart'` — only `part '*.freezed.dart'`
- Use explicit types everywhere
- Use `required` for all fields unless truly optional (then nullable `Type?`)

### 2. Repository Interfaces (`domain/repositories/`)

Abstract classes defining the contract.

```dart
import 'package:flutter_template_v3/features/<feature>/domain/entities/entities.dart';

abstract class FeatureRepository {
  Future<List<Entity>> getEntities();
  Future<Entity> getEntityById(String id);
  Future<void> createEntity({required String name});
  Future<void> deleteEntity(String id);
}
```

Rules:
- Return types are **domain entities** (never DTOs)
- Method parameters use domain types
- No implementation details (no Dio, no JSON)
- One repository per bounded context (usually one per feature)

### 3. Barrel Files

**Two-level barrel hierarchy** — this is critical:

```dart
// domain/entities/entities.dart  (sub-barrel)
export 'entity_name.dart';

// domain/repositories/repositories.dart  (sub-barrel)
export 'feature_repository.dart';

// domain/domain.dart  (layer barrel — exports ONLY sub-barrels)
export 'entities/entities.dart';
export 'repositories/repositories.dart';
```

- Layer barrel (`domain.dart`) NEVER exports individual files — only sub-barrels
- Every new file must be added to its sub-barrel immediately
- If creating a new subfolder, create its sub-barrel and add it to the layer barrel

## Folder Structure

```
lib/features/<feature>/domain/
├── domain.dart              # Layer barrel
├── entities/
│   ├── entities.dart        # Sub-barrel
│   └── <entity>.dart        # Freezed entity
└── repositories/
    ├── repositories.dart    # Sub-barrel
    └── <feature>_repository.dart  # Abstract class
```

## No Use Cases

This project does NOT use use cases / interactors. Business logic goes in:
- Simple CRUD → repository methods
- Complex orchestration → controllers (presentation layer)

## Tests (Optional)

If time permits, create tests under `test/features/$ARGUMENTS/domain/`:
- Entity construction tests
- Entity equality tests (Freezed `==` and `copyWith`)

Tests are recommended but do not block completion.

## Imports

- Always use `package:flutter_template_v3/...` (no relative imports)
- Order: `dart:` → `package:` → project packages

## Code Style

- **Explicit types everywhere** (`always_specify_types` is enabled)
- **Single quotes** for strings
- **Empty line before `return`**
- **`const` wherever possible**
- **`final` for fields and locals** that are not reassigned
- Constructors first in class body

## Pre-Completion Checklist

Before finishing, run:

```bash
fvm flutter analyze lib/features/$ARGUMENTS/domain/
```

Fix any warnings or errors before completing.

## Checklist

- [ ] Folder structure: `domain/entities/`, `domain/repositories/`
- [ ] Entities: `@freezed abstract class` with no JSON
- [ ] Repository interface: `abstract class` with domain return types
- [ ] Sub-barrels: `entities/entities.dart`, `repositories/repositories.dart`
- [ ] Layer barrel: `domain/domain.dart` exports only sub-barrels
- [ ] All files use `package:flutter_template_v3/...` imports
- [ ] `make analyze` passes with no warnings
