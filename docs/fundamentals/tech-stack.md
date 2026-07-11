# Tech Stack

All dependencies with their versions, purpose, and the reason they were chosen.

---

## State Management & Dependency Injection

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_riverpod` | 3.1.0 | Core Riverpod runtime -- `ProviderScope`, `ConsumerWidget`, `ref` |
| `riverpod_annotation` | 4.0.0 | `@riverpod` / `@Riverpod(keepAlive: true)` annotations for codegen |
| `riverpod_generator` | 4.0.0+1 | _(dev)_ Generates provider boilerplate from annotations |
| `riverpod_lint` | 3.1.0 | _(dev)_ Lint rules specific to Riverpod best practices |

**Rationale:** Riverpod provides compile-safe, testable DI with built-in state management. The codegen approach (`@riverpod`) reduces boilerplate and enforces consistent provider patterns.

---

## Navigation

| Package | Version | Purpose |
|---------|---------|---------|
| `go_router` | 17.1.0 | Declarative routing with redirect guards and deep linking |

**Rationale:** GoRouter integrates with `MaterialApp.router`, supports auth-based redirects, and works well with Riverpod via `ref.watch` on the router provider.

---

## Networking

| Package | Version | Purpose |
|---------|---------|---------|
| `dio` | 5.9.2 | HTTP client with interceptors, timeouts, and request/response transformers |

**Rationale:** Dio provides interceptor chains (auth headers, logging, MadInspector integration), typed responses, and granular timeout control.

---

## Local Storage

| Package | Version | Purpose |
|---------|---------|---------|
| `drift` | 2.31.0 | Type-safe reactive SQLite ORM |
| `drift_dev` | 2.31.0 | _(dev)_ Code generator for Drift tables and DAOs |
| `sqlite3_flutter_libs` | 0.6.0+eol | Native SQLite binaries for mobile platforms |
| `shared_preferences` | 2.5.4 | Simple key-value storage for non-sensitive settings |
| `flutter_secure_storage` | 10.0.0 | Encrypted key-value storage for tokens and secrets |
| `path_provider` | 2.1.5 | Platform-specific file system paths (used by Drift) |
| `path` | 1.9.1 | Path manipulation utilities |

**Rationale:** Three storage tiers cover all needs. Drift for structured data with migrations, SharedPreferences for flags/settings, FlutterSecureStorage for tokens.

---

## Models & Serialisation

| Package | Version | Purpose |
|---------|---------|---------|
| `freezed_annotation` | 3.1.0 | `@freezed` annotation for immutable data classes and unions |
| `freezed` | 3.2.3 | _(dev)_ Code generator for Freezed |
| `json_annotation` | 4.9.0 | `@JsonKey` annotation for JSON field mapping |
| `json_serializable` | 6.11.2 | _(dev)_ Generates `fromJson` / `toJson` methods |

**Rationale:** Freezed gives immutable models with `copyWith`, equality, and pattern matching. json_serializable handles JSON mapping with `snake_case` field rename configured in `build.yaml`.

---

## Code Generation

| Package | Version | Purpose |
|---------|---------|---------|
| `build_runner` | 2.12.2 | _(dev)_ Runs all code generators (Freezed, json_serializable, Riverpod, Drift) |

**Rationale:** Single entry point for all codegen. Run with `make gen` (one-shot) or `make watch` (continuous).

---

## Translations

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_localizations` | SDK | Material/Cupertino locale delegates |
| `slang` | 4.13.0 | Type-safe i18n with nested JSON, compile-time key checking |
| `slang_flutter` | 4.13.0 | Flutter integration: `TranslationProvider`, `context.t` extension |

**Rationale:** Slang provides type-safe translations with compile-time key verification and autocomplete. Nested JSON structure groups keys by feature (`auth.*`, `home.*`, `common.*`). Generated into `lib/core/translations/generated/`. Accessed via `context.t.group.key`.

---

## Debug & Inspector

| Package | Version | Purpose |
|---------|---------|---------|
| `mad_inspector` | 3.4.2 (git) | In-app debug overlay and inspector |
| `mad_inspector_dio` | 3.4.2 (git) | Dio network request inspector integration |
| `mad_inspector_debug_menu` | 3.4.2 (git) | Debug menu overlay |
| `mad_inspector_server_selection` | 3.4.2 (git) | Runtime server/environment switching |

**Rationale:** MadInspector provides a shake-to-open debug panel for inspecting network requests, switching servers, and viewing app state in QA/dev builds.

---

## Linting & Analysis

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_lints` | 5.0.0 | _(dev)_ Base lint rule set |
| `custom_lint` | latest | _(dev)_ Custom lint rules (e.g. `newline_before_return`) |

**Rationale:** Strict analysis (`strict-casts`, `strict-inference`, `strict-raw-types`) with project-specific rules enforced via `analysis_options.yaml`. See [code-style.md](../conventions/code-style.md).

---

## Build Configuration

`build.yaml` configures code generators:

```yaml
targets:
  $default:
    builders:
      json_serializable:
        options:
          explicit_to_json: true   # Nested toJson calls
          field_rename: snake      # camelCase -> snake_case
```

---

## Version Management

The project uses **FVM** (Flutter Version Management) to pin the Flutter SDK version. All commands in the Makefile run through `fvm flutter` / `fvm dart`.
