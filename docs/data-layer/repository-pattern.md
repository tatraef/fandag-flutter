# Repository Pattern

Entities, repository interfaces, and implementations -- the core of the domain and data layers.

---

## Rules

### Entity Rules

- `@freezed abstract class` with `with _$X` (Freezed 3.2.x + Dart 3.10)
- `const factory` constructor
- NO `fromJson`, NO `_$XFromJson`, NO `toJson`
- Only import: `package:freezed_annotation/freezed_annotation.dart`
- `part '<name>.freezed.dart';` -- code generation
- Nullable fields (`String?`) for optional data, `required` for mandatory
- After creating: run `make gen` and add to `entities/entities.dart` sub-barrel
- **Field ordering** (same as DTOs): required fields (alphabetically) → @Default fields (alphabetically) → nullable fields (alphabetically)

### Interface Rules

- `abstract class` (NOT `abstract interface class`)
- Methods return domain entities (never DTOs)
- No implementation details leak through the interface
- Import only from own `entities/` sub-barrel
- No dependency on Dio, Drift, or any framework

### Implementation Rules

- `implements` the domain repository interface
- Constructor injection of datasource (and optional storage)
- **NO error handling needed in most cases** — datasources (via ApiClient) already throw `ApiException`
- **Exception cases for error handling** — see Repository Error Handling Decision Rules below
- Calls `dto.toDomain()` to convert to domain entity before returning
- May hold additional infrastructure (`StreamController`, `FlutterSecureStorage`)
- Never imports from the presentation layer

### Mock Rules

- Implements the same domain interface
- Uses `Future<void>.delayed()` with a named `_simulatedDelay` constant
- No dependency on Dio, networking, or storage
- Imports only from `domain/domain.dart`
- Maintains minimal in-memory state (e.g., `_currentUser`)

---

## Repository Error Handling Decision Rules

**General rule:** NO try-catch in repositories. ApiClient already converts all errors to `ApiException`, which repositories propagate to controllers.

**Exception cases** — catch `ApiException` ONLY when:

### 1. signOut() — Ignore API errors, always clear local state

```dart
@override
Future<void> signOut() async {
  try {
    await _remoteDataSource.signOut();
  } on ApiException {
    // Ignore — always clear tokens even if API call fails
  } finally {
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
  }
}
```

**Why:** User must be signed out locally even if server is unreachable. Clearing tokens is more important than reporting API errors.

### 2. Optional operations — Operation failure should not block user flow

```dart
@override
Future<User> getUserProfile() async {
  final UserDto dto = await _remoteDataSource.getUser();
  String? avatarUrl;

  try {
    avatarUrl = await _remoteDataSource.getAvatar();
  } on ApiException {
    // Ignore — avatar is optional, use null if fetch fails
    avatarUrl = null;
  }

  return dto.toDomain(avatarUrl: avatarUrl);
}
```

**Why:** Avatar fetch failure shouldn't prevent showing user profile. Graceful degradation is better than showing error screen.

### 3. Fallback logic — Provide default value if API call fails

```dart
@override
Future<AppSettings> getSettings() async {
  try {
    final SettingsDto dto = await _remoteDataSource.getSettings();
    return dto.toDomain();
  } on NetworkException {
    // Fallback to cached settings if network is unavailable
    final String? cached = await _localStorage.read(key: 'settings');
    if (cached != null) {
      return SettingsDto.fromJson(jsonDecode(cached)).toDomain();
    }
    // Return defaults if no cache
    return const AppSettings.defaults();
  }
}
```

**Why:** App should work offline using cached data or sensible defaults.

---

### When NOT to catch exceptions in repository

**DON'T catch if:**
- Operation is critical (sign in, load required data)
- No fallback or default value available
- Error should be shown to user
- Controller needs to handle different error types differently

**Example — DON'T catch:**

```dart
// ❌ WRONG — pointless try-catch that just rethrows
@override
Future<List<Post>> getPosts() async {
  try {
    final List<PostDto> dtos = await _remoteDataSource.getPosts();
    return dtos.map((PostDto dto) => dto.toDomain()).toList();
  } on ApiException {
    rethrow; // Pointless! Just remove the try-catch.
  }
}

// ✅ CORRECT — let ApiException propagate naturally
@override
Future<List<Post>> getPosts() async {
  final List<PostDto> dtos = await _remoteDataSource.getPosts();
  return dtos.map((PostDto dto) => dto.toDomain()).toList();
}
```

---

### Decision Tree

```
Should repository catch ApiException?
│
├── Is this signOut()? → YES → Catch, ignore, always clear local state
│
├── Is operation OPTIONAL (avatar, analytics, non-critical)? → YES → Catch, use null/default
│
├── Do you have FALLBACK (cached data, defaults)? → YES → Catch, use fallback
│
└── Otherwise → NO → Let ApiException propagate to controller
```

---

## Anti-Patterns

### WRONG: Entity with `fromJson`

```dart
// domain/entities/user.dart
@freezed
abstract class User with _$User {
  const factory User({required String id, required String name}) = _User;
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json); // WRONG
}
```

Entities must have NO JSON serialization. JSON belongs in DTOs (`data/models/`).

### WRONG: Repository returning DTO

```dart
// WRONG -- leaks data layer into domain
Future<UserDto> getCurrentUser() async { ... }

// CORRECT -- returns domain entity
Future<User> getCurrentUser() async {
  final UserDto dto = await _remoteDataSource.getCurrentUser();

  return dto.toDomain();
}
```

### WRONG: Missing `toDomain()` call

```dart
// WRONG -- returning raw DTO data
return await _remoteDataSource.getPosts();

// CORRECT -- map each DTO to domain entity
final List<PostDto> dtos = await _remoteDataSource.getPosts();

return dtos.map((PostDto dto) => dto.toDomain()).toList();
```

### WRONG: Importing data layer in domain

```dart
// domain/repositories/auth_repository.dart
import 'package:flutter_template_v3/features/auth/data/models/models.dart'; // WRONG
// Domain must NEVER import from data layer
```

---

## Freezed Field Ordering for Entities

Entity fields must follow the same strict ordering as DTOs:

1. **Required non-nullable fields** — alphabetically
2. **Optional with @Default** — alphabetically (rare in entities, common in state classes)
3. **Nullable fields** — alphabetically

**Example:**

```dart
@freezed
abstract class Post with _$Post {
  const factory Post({
    // 1. Required non-nullable (alphabetically)
    required String authorId,      // 'a' first
    required String body,           // 'b' second
    required DateTime createdAt,    // 'c' third
    required String id,             // 'i' fourth
    required String title,          // 't' last

    // 2. @Default (if any, alphabetically)
    @Default(0) int likeCount,

    // 3. Nullable (alphabetically)
    DateTime? editedAt,             // 'e' first
    String? imageUrl,               // 'i' second
  }) = _Post;
}
```

**This ordering applies to:**
- Domain entities (`domain/entities/`)
- DTOs (`data/models/`)
- Controller state classes (`presentation/controllers/`)

See [DTO Mapping -- Freezed Field Ordering](dto-mapping.md#freezed-field-ordering-strict) for full details and examples.

---

## Domain Entity

```dart
// lib/features/auth/domain/entities/user.dart
@freezed
abstract class User with _$User {
  const factory User({
    // Required fields (alphabetically)
    required String email,
    required String id,
    required String name,

    // Nullable fields (alphabetically)
    String? avatarUrl,
  }) = _User;
}
```

See also: `lib/features/auth/domain/entities/auth_tokens.dart`, `lib/features/home/domain/entities/post.dart`

---

## Repository Interface

```dart
// lib/features/auth/domain/repositories/auth_repository.dart
abstract class AuthRepository {
  Future<AuthTokens> signIn({required String email, required String password});
  Future<AuthTokens> signUp({
    required String email,
    required String password,
    required String name,
  });
  Future<void> signOut();
  Future<void> recoverPassword({required String email});
  Future<User> getCurrentUser();
  Stream<bool> getAuthState();
}
```

See also: `lib/features/home/domain/repositories/home_repository.dart`

---

## Repository Implementation

Key pattern -- datasource call + `toDomain()` (no error handling needed):

```dart
// lib/features/home/data/repositories/home_repository_impl.dart
@override
Future<List<Post>> getPosts() async {
  final List<PostDto> dtos = await _remoteDataSource.getPosts();

  return dtos.map((PostDto dto) => dto.toDomain()).toList();
}
```

Auth repository adds token storage on sign-in/sign-up and uses `try/catch` in `signOut()` to always clear local state even if API fails:

```dart
// lib/features/auth/data/repositories/auth_repository_impl.dart
@override
Future<void> signOut() async {
  try {
    await _remoteDataSource.signOut();
  } on ApiException {
    // Ignore API errors on sign out — always clear local state
  } finally {
    await _clearTokens();
    _authStateController.add(false);
  }
}
```

See full: `lib/features/auth/data/repositories/auth_repository_impl.dart`, `lib/features/home/data/repositories/home_repository_impl.dart`

---

## Mock Repository

```dart
// lib/features/auth/data/repositories/mock_auth_repository.dart
class MockAuthRepository implements AuthRepository {
  static const Duration _simulatedDelay = Duration(milliseconds: 500);
  User? _currentUser;

  @override
  Future<AuthTokens> signIn({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(_simulatedDelay);
    _currentUser = User(id: 'mock-user-id', email: email, name: email.split('@').first);

    return const AuthTokens(
      accessToken: 'mock-access-token',
      refreshToken: 'mock-refresh-token',
    );
  }
  // ... other methods follow same pattern
}
```

See full: `lib/features/auth/data/repositories/mock_auth_repository.dart`

---

## Data Flow

```
UI (Page/Widget)
  → Controller (ref.read(repositoryProvider))
    → Repository Interface (domain)
      → Repository Impl (data): maps DTO → domain, does NOT map errors
        → DataSource: ApiClient HTTP call, returns DTO
          → ApiClient: converts errors to ApiException
          → DTO.toDomain() → Domain Entity (returned to controller)
```

---

## Decision Tree: Feature vs Core

```
Does it have its own screen?
├── YES → Create a feature in lib/features/
Does it serve 3+ features?
├── YES → Put in lib/core/
Is it data-only (no UI)?
├── YES → Feature without presentation/ layer
Is it a pure utility?
└── YES → lib/core/extensions/ or lib/core/utils/
```

---

## Cross-References

- [DTO Mapping](dto-mapping.md) -- DTO structure, `fromJson`, `toDomain()`
- [Networking](networking.md) -- Datasource patterns, ApiClient/Dio setup
- [Error Handling](../architecture/error-handling.md) -- ApiException hierarchy, centralized conversion
- [Riverpod Providers](../architecture/riverpod-providers.md) -- Provider wiring for repos
- [Barrel Files](../conventions/barrel-files.md) -- Export conventions
