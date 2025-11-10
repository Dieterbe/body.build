import 'package:bodybuild/data/workouts/workout_providers.dart';
import 'package:bodybuild/service/database_backup_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'backup_providers.g.dart';

@riverpod
DatabaseBackupService databaseBackupService(Ref ref) {
  final database = ref.watch(workoutDatabaseProvider);
  return DatabaseBackupService(database);
}
