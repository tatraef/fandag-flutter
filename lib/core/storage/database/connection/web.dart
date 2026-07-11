import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

/// Opens a WASM-backed database connection for the web platform.
///
/// Requires `sqlite3.wasm` and `drift_worker.js` to be present in the web
/// build output (see `web/`).
QueryExecutor connect() {
  return LazyDatabase(() async {
    final WasmDatabaseResult result = await WasmDatabase.open(
      databaseName: 'app_database',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.js'),
    );

    return result.resolvedExecutor;
  });
}
