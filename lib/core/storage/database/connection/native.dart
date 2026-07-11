import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Opens a native (FFI) database connection for mobile and desktop platforms.
QueryExecutor connect() {
  return LazyDatabase(() async {
    final Directory dbFolder = await getApplicationDocumentsDirectory();
    final File file = File(p.join(dbFolder.path, 'app_database.sqlite'));

    return NativeDatabase.createInBackground(file);
  });
}
