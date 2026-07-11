import 'package:drift/drift.dart';

/// Fallback used when no platform-specific database implementation is available.
QueryExecutor connect() {
  throw UnsupportedError(
    'No database implementation is available for this platform.',
  );
}
