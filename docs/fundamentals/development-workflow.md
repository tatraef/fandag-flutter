# Development Workflow

## Daily Commands

All commands are defined in the project `Makefile` and use FVM under the hood.

### Setup & Initialisation

| Command | Description |
|---------|-------------|
| `make setup` | Install FVM Flutter version + `pub get` |
| `make init` | Full init: FVM + pub get + build_runner + slang |
| `make i` | Quick alias for `fvm flutter pub get` |

### Code Generation

| Command | Description |
|---------|-------------|
| `make gen` | One-shot `build_runner build --delete-conflicting-outputs` |
| `make watch` | Continuous `build_runner watch` (use during active development) |
| `make translations` | Generate translations via slang (`fvm dart run slang`) |

Run `make gen` after:
- Adding/changing a `@freezed` model
- Adding/changing a `@riverpod` provider
- Modifying Drift tables
- Adding/changing `@JsonSerializable` DTOs

### Run & Build

| Command | Description |
|---------|-------------|
| `make run` | Run app in dev mode with MadInspector enabled |
| `make ios` | Run on iOS simulator |
| `make android` | Run on Android emulator |
| `make build-apk` | Release APK |
| `make build-ios` | iOS build (no codesign) |
| `make build-ipa` | Release IPA |

### Testing & Analysis

| Command | Description |
|---------|-------------|
| `make test` | Run all tests |
| `make test-coverage` | Run tests with coverage report |
| `make analyze` | Static analysis |
| `make format` | Format `lib/` and `test/` |
| `make lint` | Analyze + format combined |

### Cleanup

| Command | Description |
|---------|-------------|
| `make clean` | `fvm flutter clean` + `pub get` |
| `make clean-all` | Clean + delete all `*.g.dart`, `*.freezed.dart`, `*.drift.dart` + `pub get` |

### Environment

| Command | Description |
|---------|-------------|
| `make generate_env_files` | Generate environment config from `config/` |

---

## Git Workflow

### Branch Naming

```
feature/<ticket-id>-short-description
fix/<ticket-id>-short-description
refactor/<description>
chore/<description>
```

### Commit Flow

1. Work on your feature branch.
2. Run `make lint` before committing.
3. Run `make test` to verify nothing is broken.
4. Commit generated files (`*.g.dart`, `*.freezed.dart`) along with source changes -- they must stay in sync.
5. Push and open a Merge Request.

### Commit Message Format

```
<type>: <short summary>

<optional body with details>
```

Types: `feat`, `fix`, `refactor`, `chore`, `docs`, `test`, `style`.

---

## Pre-Commit Checklist

Before pushing your branch, verify every item:

- [ ] `make gen` -- code generation is up to date, generated files committed
- [ ] `make lint` -- no analysis warnings, code is formatted
- [ ] `make test` -- all tests pass
- [ ] New files added to the correct barrel file (see [barrel-files.md](../conventions/barrel-files.md))
- [ ] New translation keys added to **both** `en.i18n.json` and `ru.i18n.json`, then `make translations`
- [ ] No hardcoded strings in UI -- all user-facing text goes through `context.t`
- [ ] No magic numbers -- values extracted to named constants
- [ ] No widget functions -- only widget classes (see [code-style.md](../conventions/code-style.md))
- [ ] Routes registered in `app_router.dart` and `AppRoute` enum
- [ ] New providers use `@riverpod` / `@Riverpod(keepAlive: true)` codegen

---

## Typical Development Session

```bash
# Start of day
git checkout -b feature/PROJ-42-user-profile
make i

# While coding (keep running in a separate terminal)
make watch

# Before commit
make gen          # Ensure all generated code is fresh
make lint         # Analyze + format
make test         # Run tests
git add .
git commit -m "feat: add user profile feature"
git push -u origin feature/PROJ-42-user-profile
```

---

## Spec-Driven Workflow

For non-trivial features, follow this workflow to ensure complete, correct implementation:

### 1. Specify

Define the feature requirements in a specification document:
- List all entities, DTOs, endpoints, screens
- Define API contracts (request/response shapes)
- List translation keys needed
- Identify which controller pattern to use (form, async list, global state)

### 2. Plan

Break the specification into implementation steps:
- Map entities to files and folders
- Identify which existing patterns to follow (see `reference/patterns-reference.md`)
- Order tasks by dependency: domain → data → presentation → routes → translations

### 3. Scaffold

Create the folder structure and barrel files first:
- All directories under `lib/features/<feature>/`
- All sub-barrel files (empty exports initially)
- All layer barrel files
- This ensures imports work before implementation begins

### 4. Implement

Follow the execution order strictly:
1. Domain entities + repository interface + barrel updates
2. `make gen` (generates `.freezed.dart` for entities)
3. DTOs + datasource + repository impl + barrel updates
4. `make gen` (generates `.freezed.dart` + `.g.dart` for DTOs)
5. DI providers + controllers + barrel updates
6. `make gen` (generates `.g.dart` for providers/controllers)
7. Pages + widgets + barrel updates
8. Routes (AppRoute enum + GoRoute)
9. Translations (both JSON files) + `make translations`
10. `make gen` (final pass)

### 5. Verify

Run the full verification pipeline:
```bash
make gen          # Ensure all generated code is fresh
make analyze      # No analysis warnings
make format       # Code is formatted
make test         # All tests pass
```

---

## Code Generation Triggers

Run `make gen` after ANY of these changes:

| Change | Generated Files | Why |
|--------|----------------|-----|
| New/modified `@freezed` model | `*.freezed.dart` | Immutable class implementation |
| New/modified DTO with `fromJson` | `*.g.dart` | JSON serialization |
| New/modified `@riverpod` provider | `*.g.dart` | Provider boilerplate |
| New/modified `@riverpod class` controller | `*.g.dart` | Notifier + provider |
| Modified Drift table | `*.drift.dart` | Database schema |

**Tip**: During active development, run `make watch` in a separate terminal to auto-regenerate on save.

**Important**: Always commit generated files (`*.g.dart`, `*.freezed.dart`) alongside source changes — they must stay in sync.

---

## Translations Workflow

### Adding New Strings

1. Add key to `lib/core/translations/en.i18n.json` under the appropriate feature group:
   ```json
   {
     "featureName": {
       "newKey": "English text"
     }
   }
   ```

2. Add the same key to `lib/core/translations/ru.i18n.json`:
   ```json
   {
     "featureName": {
       "newKey": "Русский текст"
     }
   }
   ```

3. Regenerate: `make translations`

4. Access in code: `context.t.featureName.newKey`

### Rules

- All user-facing strings MUST go through translations — no hardcoded strings in UI
- Both `en` and `ru` files must have identical key structures
- Group keys by feature name matching the feature folder
- Use nested groups for sub-sections (e.g., `auth.signIn`, `auth.signUp`)
