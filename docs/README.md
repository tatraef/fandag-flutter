# Documentation — Flutter Template v3

This is the central navigation hub for all project documentation. Use the task-to-doc mapping table below to find the right doc for your task.

## Task-to-Documentation Mapping

| Task | Read First | Then |
|------|-----------|------|
| New Feature (full) | [reference/adding-feature.md](reference/adding-feature.md) | [architecture/overview.md](architecture/overview.md) |
| New Entity | [data-layer/repository-pattern.md](data-layer/repository-pattern.md) §Entities | [conventions/barrel-files.md](conventions/barrel-files.md) |
| New DTO | [data-layer/dto-mapping.md](data-layer/dto-mapping.md) | [conventions/barrel-files.md](conventions/barrel-files.md) |
| New Controller | [presentation/controllers.md](presentation/controllers.md) | [architecture/riverpod-providers.md](architecture/riverpod-providers.md) |
| New Repository | [data-layer/repository-pattern.md](data-layer/repository-pattern.md) | [architecture/error-handling.md](architecture/error-handling.md) |
| New Datasource | [data-layer/networking.md](data-layer/networking.md) | [data-layer/dto-mapping.md](data-layer/dto-mapping.md) |
| New Page/Screen | [presentation/pages-and-widgets.md](presentation/pages-and-widgets.md) | [presentation/theming.md](presentation/theming.md) |
| New Route | [architecture/navigation.md](architecture/navigation.md) | [reference/adding-feature.md](reference/adding-feature.md) §5 |
| Add Translations | [fundamentals/development-workflow.md](fundamentals/development-workflow.md) §Translations | — |
| Core Widget | [reference/core-widgets.md](reference/core-widgets.md) | [presentation/theming.md](presentation/theming.md) |
| Error Handling | [architecture/error-handling.md](architecture/error-handling.md) | [data-layer/networking.md](data-layer/networking.md) |
| Storage/DB | [data-layer/storage.md](data-layer/storage.md) | — |
| Write Tests | [testing/overview.md](testing/overview.md) | [testing/unit-testing.md](testing/unit-testing.md) |
| Understand Architecture | [architecture/overview.md](architecture/overview.md) | [fundamentals/project-structure.md](fundamentals/project-structure.md) |
| Code Style Questions | [conventions/code-style.md](conventions/code-style.md) | [conventions/imports-and-dependencies.md](conventions/imports-and-dependencies.md) |

## For AI Coding Agents

When implementing a feature, read docs in this order:

1. `reference/adding-feature.md` — Step-by-step checklist
2. `reference/patterns-reference.md` — Canonical file examples
3. Layer-specific doc (domain → data-layer → presentation)
4. `conventions/barrel-files.md` — Always after creating files

## Quick Links

### Fundamentals

- [Project Structure](fundamentals/project-structure.md) — Full annotated directory tree, naming conventions, decision tree
- [Tech Stack](fundamentals/tech-stack.md) — All packages with versions and rationale
- [Development Workflow](fundamentals/development-workflow.md) — Commands, git workflow, code generation triggers

### Architecture

- [Overview](architecture/overview.md) — MVVM + Repository pattern, layer rules, data flow
- [Riverpod Providers](architecture/riverpod-providers.md) — Provider types, DI wiring, ref rules
- [Error Handling](architecture/error-handling.md) — ApiException hierarchy
- [Navigation](architecture/navigation.md) — GoRouter setup, AppRoute, auth redirects

### Data Layer

- [Repository Pattern](data-layer/repository-pattern.md) — Entities, interfaces, implementations
- [Networking](data-layer/networking.md) — Dio provider, interceptor, API endpoints
- [DTO Mapping](data-layer/dto-mapping.md) — Freezed DTOs, fromJson, toDomain()
- [Storage](data-layer/storage.md) — Drift DB, SecureStorage, SharedPreferences

### Presentation

- [Controllers](presentation/controllers.md) — Form, async list, global state patterns
- [Pages & Widgets](presentation/pages-and-widgets.md) — ConsumerWidget, Consumer+select(), widget rules
- [Theming](presentation/theming.md) — ThemeColors, PrimaryFonts, context extensions

### Conventions

- [Barrel Files](conventions/barrel-files.md) — Two-level barrel hierarchy, rules, checklist
- [Code Style](conventions/code-style.md) — Linting rules, formatting, typing
- [Imports & Dependencies](conventions/imports-and-dependencies.md) — Import order, no relative imports

### Reference

- [Patterns Reference](reference/patterns-reference.md) — Quick-lookup table for every pattern
- [Adding a Feature](reference/adding-feature.md) — Step-by-step checklist with code examples
- [Core Widgets](reference/core-widgets.md) — AppButton, AppTextField, LoadingOverlay API

### Testing

- [Overview](testing/overview.md) — Testing strategy, test organization, running tests
- [What to Test](testing/what-to-test.md) — Testing priorities, decision tree, 80/20 rule
- [Unit Testing](testing/unit-testing.md) — Patterns for domain, data, and presentation layers
- [Widget Testing](testing/widget-testing.md) — Testing UI components and user interactions
- [Integration Testing](testing/integration-testing.md) — E2E tests for critical user flows
- [Best Practices](testing/best-practices.md) — Conventions, patterns, and anti-patterns
- [Troubleshooting](testing/troubleshooting.md) — Common issues and solutions

### Other

- [App Setup](app-setup.md) — main.dart, app.dart, initialization flow
