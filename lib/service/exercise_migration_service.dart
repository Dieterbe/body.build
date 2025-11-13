import 'package:bodybuild/data/programmer/exercise_migrations.dart';
import 'package:bodybuild/data/programmer/exercise_versioning.dart';

/// Service for applying exercise migrations across version ranges
class ExerciseMigrationService {
  /// Migrate exercise ID and tweaks through all applicable migrations
  static (String, Map<String, String>) migrateExercise(
    String exerciseId,
    Map<String, String> tweaks,
    int fromVersion,
    int toVersion,
  ) {
    var currentId = exerciseId;
    var currentTweaks = Map<String, String>.of(tweaks);

    for (final migration in getApplicableMigrations(fromVersion, toVersion)) {
      final result = migration.migrate(currentId, currentTweaks);
      if (result != null) {
        currentId = result.$1;
        currentTweaks = result.$2;
      }
    }

    return (currentId, currentTweaks);
  }

  /// Check if migrations are needed between versions
  static bool isMigrationNeeded(int fromVersion, int toVersion) {
    return exerciseMigrations.any(
      (migration) => migration.fromVersion >= fromVersion && migration.toVersion <= toVersion,
    );
  }

  /// Get list of migrations that would be applied between versions
  static List<ExerciseMigration> getApplicableMigrations(int fromVersion, int toVersion) {
    return exerciseMigrations
        .where(
          (migration) => migration.fromVersion >= fromVersion && migration.toVersion <= toVersion,
        )
        .toList();
  }

  /// Get description of all migrations that would be applied
  static String getMigrationDescription(int fromVersion, int toVersion) {
    final migrations = getApplicableMigrations(fromVersion, toVersion);
    if (migrations.isEmpty) return 'No migrations needed';

    return migrations.map((m) => '• ${m.description}').join('\n');
  }
}
