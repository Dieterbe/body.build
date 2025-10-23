import 'package:drift/drift.dart';
import 'workout_database_connection_stub.dart'
    if (dart.library.io) 'workout_database_connection_native.dart';

/// Opens the database connection using the appropriate backend for the platform.
/// - Native (mobile/desktop): Uses NativeDatabase with SQLite file
/// - Web: Not supported
QueryExecutor openWorkoutDatabaseConnection() {
  return openConnection();
}
