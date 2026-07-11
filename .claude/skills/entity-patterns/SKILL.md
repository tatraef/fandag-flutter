---
name: entity-patterns
description: Domain entity patterns with Freezed. Auto-loads when creating entities, domain models, or discussing domain layer.
user-invocable: false
---

# Entity Patterns

Domain entities are **pure business objects** — no JSON, no serialization, no infrastructure concerns.

## Canonical Template

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part '<entity_name>.freezed.dart';

@freezed
abstract class EntityName with _$EntityName {
  const factory EntityName({
    required String id,
    required String name,
    Type? optionalField,
  }) = _EntityName;
}
```

## Rules

1. **`@freezed abstract class X with _$X`** — Freezed 3.x + Dart 3.10 requirement
2. **`const factory`** constructor
3. **`part '*.freezed.dart'`** only — NO `part '*.g.dart'`
4. **No `fromJson` / `toJson`** — serialization belongs in DTOs
5. **`required`** for all non-optional fields
6. **Nullable `Type?`** for truly optional fields (no `@Default`)
7. **Explicit types everywhere** — `always_specify_types` is enabled
8. **Single quotes** for strings

## Real Examples

### User Entity

```dart
// lib/features/auth/domain/entities/user.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String name,
    String? avatarUrl,
  }) = _User;
}
```

### Post Entity

```dart
// lib/features/home/domain/entities/post.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post.freezed.dart';

@freezed
abstract class Post with _$Post {
  const factory Post({
    required String id,
    required String title,
    required String body,
    required String authorId,
    required DateTime createdAt,
  }) = _Post;
}
```

### AuthTokens Entity

```dart
// lib/features/auth/domain/entities/auth_tokens.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_tokens.freezed.dart';

@freezed
abstract class AuthTokens with _$AuthTokens {
  const factory AuthTokens({
    required String accessToken,
    required String refreshToken,
  }) = _AuthTokens;
}
```

## Barrel File

Add every new entity to the sub-barrel `entities/entities.dart`:

```dart
// domain/entities/entities.dart
export 'user.dart';
export 'auth_tokens.dart';
```

Do NOT add individual files to the layer barrel `domain.dart`.

## Anti-Patterns

```dart
// BAD: adding fromJson — entities have no JSON
@freezed
abstract class User with _$User {
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  // ...
}

// BAD: using `class` instead of `abstract class`
@freezed
class User with _$User { ... }

// BAD: missing part directive
@freezed
abstract class User with _$User { ... }  // no `part 'user.freezed.dart';`

// BAD: adding part '*.g.dart' — entities don't need it
part 'user.freezed.dart';
part 'user.g.dart';  // WRONG — no JSON in entities

// BAD: using @Default for business-required fields
const factory User({
  @Default('') String email,  // email is required, not optional
}) = _User;
```
