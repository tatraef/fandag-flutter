# Storage

Drift database, FlutterSecureStorage, and SharedPreferences — all local storage options.

---

## Anti-Patterns

### WRONG: Storing tokens in SharedPreferences

```dart
// WRONG -- tokens are sensitive, SharedPreferences is NOT encrypted
await ref.read(sharedPrefsProvider).setString('access_token', token);

// CORRECT -- use FlutterSecureStorage for sensitive data
await secureStorage.write(key: 'access_token', value: token);
```

### WRONG: Async provider init instead of throw-then-override

```dart
// WRONG -- async initialization makes all consumers deal with Future
@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPrefs(Ref ref) async {
  return SharedPreferences.getInstance();
}

// CORRECT -- throw by default, override with pre-initialized value in main.dart
@Riverpod(keepAlive: true)
SharedPreferences sharedPrefs(Ref ref) {
  throw UnimplementedError('must be overridden in ProviderScope');
}
// In main.dart: sharedPrefsProvider.overrideWithValue(sharedPrefs)
```

---

## Overview

| Storage | Provider | Use For | Encrypted |
|---------|----------|---------|-----------|
| Drift (SQLite) | `appDatabaseProvider` | Structured cached data | No |
| FlutterSecureStorage | `secureStorageProvider` | Tokens, sensitive data | Yes |
| SharedPreferences | `sharedPrefsProvider` | Settings, simple preferences | No |

---

## Drift Database

Type-safe SQLite ORM for structured data caching.

### Table Definition

```dart
// lib/core/storage/database/app_database.dart
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class CacheEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get key => text().unique()();
  TextColumn get value => text()();
  DateTimeColumn get expiresAt => dateTime().nullable()();
}

@DriftDatabase(tables: <Type>[CacheEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final Directory dbFolder = await getApplicationDocumentsDirectory();
    final File file = File(p.join(dbFolder.path, 'app_database.sqlite'));

    return NativeDatabase.createInBackground(file);
  });
}
```

### Database Provider

```dart
// lib/core/storage/database/app_database_provider.dart
import 'package:flutter_template_v3/core/storage/database/app_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_database_provider.g.dart';

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final AppDatabase db = AppDatabase();
  ref.onDispose(db.close);

  return db;
}
```

**Key points:**
- `@Riverpod(keepAlive: true)` — database is a singleton
- `ref.onDispose(db.close)` — ensures database is properly closed when provider is disposed
- `NativeDatabase.createInBackground` — opens database on a background isolate
- `AppDatabase.forTesting(super.e)` — constructor for unit tests with in-memory database

### Adding a New Table

1. Define a new table class extending `Table` in `app_database.dart`
2. Add it to `@DriftDatabase(tables: <Type>[CacheEntries, NewTable])`
3. Increment `schemaVersion`
4. Run `make gen`

---

## Secure Storage

Encrypted key-value storage for sensitive data (tokens, credentials).

### Provider

```dart
// lib/core/storage/secure_storage_provider.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secure_storage_provider.g.dart';

@Riverpod(keepAlive: true)
FlutterSecureStorage secureStorage(Ref ref) {
  return const FlutterSecureStorage();
}
```

### Usage

```dart
// Write
await secureStorage.write(key: 'access_token', value: token);

// Read
final String? token = await secureStorage.read(key: 'access_token');

// Delete
await secureStorage.delete(key: 'access_token');
```

### When to Use

- Access tokens and refresh tokens
- API keys
- Any user credential or sensitive data
- Data that must be encrypted at rest

### Usage in Repository

The auth repository stores/retrieves tokens via secure storage:

```dart
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required FlutterSecureStorage secureStorage,
  }) : _remoteDataSource = remoteDataSource,
       _secureStorage = secureStorage;

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  Future<void> _saveTokens(AuthTokensDto tokens) async {
    await _secureStorage.write(key: _accessTokenKey, value: tokens.accessToken);
    await _secureStorage.write(key: _refreshTokenKey, value: tokens.refreshToken);
  }

  Future<void> _clearTokens() async {
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
  }
}
```

---

## SharedPreferences

Simple key-value storage for non-sensitive data (settings, preferences, flags).

### Provider

```dart
// lib/core/storage/shared_prefs_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_prefs_provider.g.dart';

@Riverpod(keepAlive: true)
SharedPreferences sharedPrefs(Ref ref) {
  throw UnimplementedError(
    'sharedPrefsProvider must be overridden with a valid SharedPreferences instance',
  );
}
```

**Important:** This provider throws by default. It's overridden in `main.dart` with the actual instance:

```dart
// In main.dart
final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();

runApp(
  ProviderScope(
    overrides: [sharedPrefsProvider.overrideWithValue(sharedPrefs)],
    child: const App(),
  ),
);
```

This pattern avoids async provider initialization — `SharedPreferences.getInstance()` is called before the widget tree starts.

### Usage

```dart
// Read
final String? value = ref.read(sharedPrefsProvider).getString('key');
final bool flag = ref.read(sharedPrefsProvider).getBool('key') ?? false;

// Write
await ref.read(sharedPrefsProvider).setString('key', 'value');
await ref.read(sharedPrefsProvider).setBool('key', true);

// Remove
await ref.read(sharedPrefsProvider).remove('key');
```

### When to Use

- User preferences (theme mode, language)
- App settings (notification preferences)
- Simple flags (onboarding completed, first launch)
- Non-sensitive cached data

---

## Decision Tree: Which Storage?

```
Is the data sensitive (tokens, credentials)?
├── YES → FlutterSecureStorage
│
Is the data structured / relational / needs queries?
├── YES → Drift
│
Is it a simple key-value?
└── YES → SharedPreferences
```
