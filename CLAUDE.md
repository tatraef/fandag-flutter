# CLAUDE.md — Fandag

Fandag — production-ready шаблон на **Riverpod-архитектуре** (feature-first, MVVM + Repository).

All docs: `docs/README.md`. New feature checklist: `docs/reference/adding-feature.md`.
Tech stack: `docs/fundamentals/tech-stack.md`. Project structure: `docs/fundamentals/project-structure.md`.

## Key Commands

`make init` (full setup) | `make gen` (codegen) | `make translations` (translations) | `make run` | `make test` | `make analyze`

## Architecture Conventions

### Layers (per feature)
- **domain/** — Entities (Freezed, no JSON), repository interfaces, barrel `domain.dart`
- **data/** — DTOs (Freezed + JSON + `toDomain()`), datasources, repository impls, barrel `data.dart`
- **presentation/** — Controllers (Riverpod codegen), pages, widgets, barrel `presentation.dart`

### Riverpod Providers
- Always use **codegen**: `@riverpod` (auto-dispose) or `@Riverpod(keepAlive: true)` (singletons)
- Never write manual `final myProvider = Provider(...)`
- Provider function signatures use `Ref` (not auto-generated types like `DioRef`)
- Use `ref.watch` in `build()`, `ref.read` in callbacks
- **Selective rebuilds**: page `build()` never calls `ref.watch` — wrap state-dependent widgets in `Consumer` + `.select()`
- **Side-effects**: use `ref.listen` (not `ref.watch`) for navigation, snackbars, dialogs

### Freezed Models
- Domain entities: `@freezed abstract class X with _$X` — no JSON
- DTOs: `@freezed abstract class XDto with _$XDto` — with `fromJson` + `toDomain()`
- **Must use `abstract class`** (Freezed 3.2.x + Dart 3.10 requirement)

### Barrel Files
- **Two-level barrel hierarchy**: sub-barrel per subfolder → layer barrel re-exports sub-barrels only
- **CRITICAL**: Layer barrels (`domain.dart`, `data.dart`, `presentation.dart`) NEVER export individual files
- New files → add to sub-barrel immediately; new subfolder → create sub-barrel + add to layer barrel
- **Full rules**: `docs/conventions/barrel-files.md`

### Imports
- Always use `package:fandag/...` (no relative imports)
- Order: `dart:` → `package:` → project packages

### Dependencies
- All versions **fixed** (no `^` prefix). Updates are manual and intentional.

### Form Validation
- **Validation in TextField widgets** (NOT in controllers) — see `docs/presentation/pages-and-widgets.md`
- Specialized widgets in `lib/core/widgets/text_fields/`: `EmailTextField`, `PasswordTextField`, etc.
- Controllers store **validity flags** (`isEmailValid: bool`), NOT error messages
- Methods: `setEmail(String value, {required bool isValid})`

## Code Style

- **Explicit types everywhere** — `always_specify_types` is enabled
- **Single quotes** for strings
- **Empty line before `return`**
- **No magic numbers** — extract to named constants
- **No widget functions** — only widget classes (`StatelessWidget`, `ConsumerWidget`, etc.)
- **Constructors first** in class body, **`build()` always last**
- **`const` wherever possible**
- **`final` for locals and fields** that are not reassigned
- **Strict mode**: `strict-casts`, `strict-inference`, `strict-raw-types`
- **Clean analyzer** — `make analyze` must show "No issues found!" (info-level warnings NOT acceptable)

## Code Generation

After modifying Freezed models, Riverpod providers, or Drift tables: `make gen`

Generated files (`*.g.dart`, `*.freezed.dart`) are committed to git.
