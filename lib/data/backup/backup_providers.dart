import 'package:bodybuild/data/workouts/workout_providers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:riverpod_annotation/riverpod_annotation.dart';
// Only import backup service on non-web platforms
import 'package:bodybuild/service/database_backup_service.dart'
    if (dart.library.html) 'backup_providers_stub.dart';

part 'backup_providers.g.dart';

@riverpod
DatabaseBackupService databaseBackupService(Ref ref) {
  if (kIsWeb) {
    throw UnsupportedError('Backup is not supported on web');
  }
  final database = ref.watch(workoutDatabaseProvider);
  return DatabaseBackupService(database);
}
