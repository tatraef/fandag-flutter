import 'package:drift/drift.dart';
import 'package:fandag/core/storage/database/connection/unsupported.dart'
    if (dart.library.io) 'package:fandag/core/storage/database/connection/native.dart'
    if (dart.library.js_interop) 'package:fandag/core/storage/database/connection/web.dart';

part 'app_database.g.dart';

class CacheEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get key => text().unique()();
  TextColumn get value => text()();
  DateTimeColumn get expiresAt => dateTime().nullable()();
}

@DriftDatabase(tables: <Type>[CacheEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(connect());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;
}
