# Architecture Overview

## Pattern: MVVM + Repository on Riverpod

Fandag follows **feature-first** project organisation with **MVVM + Repository** architecture, powered by **Riverpod** for dependency injection and state management.

### Core Principles

1. **Feature-first** -- code is grouped by business feature (`auth`, `home`, ...), not by technical role.
2. **Three-layer separation** inside every feature: `domain` -> `data` -> `presentation`.
3. **Unidirectional data flow** -- UI reads state from controllers; controllers call repositories; repositories coordinate data sources.
4. **Dependency inversion** -- `presentation` and `data` depend on `domain`, never the other way around. Repository contracts live in `domain`; implementations live in `data`.
5. **Code generation** -- Freezed for immutable models and unions, Riverpod Generator for providers, json_serializable for JSON, Drift for database.

---

## Layers

| Layer | Responsibility | Key classes |
|-------|---------------|-------------|
| **domain** | Business entities, repository interfaces | `User`, `AuthRepository` (abstract) |
| **data** | DTOs, data sources, repository implementations | `UserDto`, `AuthRemoteDataSource`, `AuthRepositoryImpl` |
| **presentation** | Controllers (ViewModels), pages, widgets | `SignInController`, `SignInPage`, `AuthFormField` |

### Layer Rules

- `domain` has **zero** dependency on Flutter, Dio, Drift, or any framework.
- `data` imports `domain` entities and implements its repository interfaces.
- `presentation` imports `domain` entities and repository interfaces (via providers). It never touches `data` classes directly.
- Cross-feature communication goes through `domain` barrels only.

### Layer Dependency Diagram

```
presentation ──► domain ◄── data
     │                        │
     ▼                        ▼
   core                     core
```

**Allowed dependencies:**
- `presentation` → `domain` (entities, repository interfaces via providers)
- `data` → `domain` (entities for `toDomain()`, repository interfaces to implement)
- `presentation` → `core` (widgets, theme, router, extensions)
- `data` → `core` (network, storage, constants)
- `domain` → `core/exceptions` only (for `AppException`)

**Forbidden dependencies:**
- `presentation` ✗→ `data` — NEVER import data layer classes from presentation
- `domain` ✗→ `data` — domain must not know about DTOs, datasources, or implementations
- `domain` ✗→ `presentation` — domain must not know about controllers, pages, or widgets

### Cross-Feature Imports

When a feature needs types from another feature:
- Import ONLY via the other feature's **domain barrel**: `import 'package:fandag/features/other/domain/domain.dart';`
- NEVER import from another feature's `data` or `presentation` layers
- This ensures features remain loosely coupled through domain contracts

Example: `home` feature needs `User` from `auth`:
```dart
// CORRECT
import 'package:fandag/features/auth/domain/domain.dart';

// WRONG — importing from presentation layer of another feature
import 'package:fandag/features/auth/presentation/presentation.dart';
```

---

## Data Flow Diagram

```
┌──────────────────────────────────────────────────────────┐
│                       PRESENTATION                       │
│                                                          │
│   Page (ConsumerWidget / ConsumerStatefulWidget)         │
│     │  ref.watch(controllerProvider)                     │
│     ▼                                                    │
│   Controller (@riverpod class)                           │
│     │  ref.read(repositoryProvider).method()              │
│     ▼                                                    │
├──────────────────────────────────────────────────────────┤
│                         DOMAIN                           │
│                                                          │
│   Repository (abstract class)                            │
│   Entity (@freezed, no fromJson)                         │
│                                                          │
├──────────────────────────────────────────────────────────┤
│                          DATA                            │
│                                                          │
│   RepositoryImpl ──► DataSource ──► ApiClient / Drift / Prefs  │
│   DTO (@freezed + fromJson/toJson + toDomain())          │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

### Step-by-step flow (example: sign in)

1. `SignInPage` calls `ref.read(signInControllerProvider.notifier).submit()`.
2. `SignInController.submit()` validates input, then calls `ref.read(authRepositoryProvider).signIn(...)`.
3. `authRepositoryProvider` resolves to `AuthRepositoryImpl`, which calls `AuthRemoteDataSource.signIn(...)`.
4. The data source sends a POST request via `ApiClient`, receives JSON, deserialises it into `AuthTokensDto`.
5. `AuthRepositoryImpl` calls `tokensDto.toDomain()` to convert DTO to domain entity `AuthTokens`.
6. The controller updates its Freezed state; the page rebuilds via `ref.watch`.

---

## Quick Start for Developers

```bash
# 1. Clone and initialise
git clone <repo-url>
make init          # FVM install + pub get + build_runner + translations

# 2. Run the app
make run           # Launches in dev mode with inspector

# 3. Code generation (after model/provider changes)
make gen           # One-shot build_runner
make watch         # Continuous build_runner

# 4. Analysis
make analyze       # Static analysis
make format        # Code formatting
```

See [development-workflow.md](../fundamentals/development-workflow.md) for the full command reference and Git workflow.

---

## Further Reading

| Document | Contents |
|----------|----------|
| [project-structure.md](../fundamentals/project-structure.md) | Full project tree with explanations |
| [tech-stack.md](../fundamentals/tech-stack.md) | All packages with versions and rationale |
| [development-workflow.md](../fundamentals/development-workflow.md) | Daily commands, Git workflow, pre-commit checklist |
| [barrel-files.md](../conventions/barrel-files.md) | Barrel file conventions |
| [adding-feature.md](../reference/adding-feature.md) | Step-by-step checklist for new features |
| [code-style.md](../conventions/code-style.md) | Code style and lint rules |
| [riverpod-providers.md](riverpod-providers.md) | Provider types, DI wiring, ref rules |
| [error-handling.md](error-handling.md) | Exception hierarchy, error mapping |
| [navigation.md](navigation.md) | GoRouter setup, auth redirects, adding routes |
