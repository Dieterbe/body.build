import 'package:bodybuild/service/exercise_migration_service.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bodybuild/data/programmer/exercise_migrations.dart';

void main() {
  group('ExerciseMigration', () {
    group('RenameExerciseMigration', () {
      test('should rename exercise IDs correctly', () {
        const migration = RenameExerciseMigration(1, 2, {
          'old bench press': 'bench press',
          'old squat': 'squat',
        });

        // Test rename
        final result1 = migration.migrate('old bench press', {'grip': 'wide'});
        expect(result1, isNotNull);
        expect(result1!.$1, equals('bench press'));
        expect(result1.$2, equals({'grip': 'wide'}));

        // Test no change needed
        final result2 = migration.migrate('deadlift', {'stance': 'conventional'});
        expect(result2, isNull);
      });
    });

    group('MergeExerciseMigration', () {
      test('should merge exercises with distinguishing tweak', () {
        const migration = MergeExerciseMigration(2, 3, 'leg curl', 'equipment', {
          'seated leg curl': 'machine (seated)',
          'lying leg curl': 'machine (lying)',
          'standing leg curl': 'machine (standing)',
        });

        // Test merge
        final result1 = migration.migrate('seated leg curl', {'rom': 'full'});
        expect(result1, isNotNull);
        expect(result1!.$1, equals('leg curl'));
        expect(result1.$2, equals({'rom': 'full', 'equipment': 'machine (seated)'}));

        // Test no change needed
        final result2 = migration.migrate('deadlift', {'stance': 'conventional'});
        expect(result2, isNull);
      });
    });

    group('SplitExerciseMigration', () {
      test('should split exercise by tweak value', () {
        const migration = SplitExerciseMigration(3, 4, 'squat', 'depth', {
          'quarter': 'quarter squat',
          'half': 'half squat',
          'parallel': 'squat',
          'atg': 'deep squat',
        });

        // Test split with known tweak value
        final result1 = migration.migrate('squat', {'depth': 'quarter', 'stance': 'wide'});
        expect(result1, isNotNull);
        expect(result1!.$1, equals('quarter squat'));
        expect(result1.$2, equals({'stance': 'wide'})); // depth tweak removed

        // Test split with unknown tweak value (should throw error)
        expect(
          () => migration.migrate('squat', {'depth': 'unknown', 'stance': 'narrow'}),
          throwsA(isA<ArgumentError>()),
        );

        // Test no change needed (different exercise)
        final result3 = migration.migrate('deadlift', {'depth': 'quarter'});
        expect(result3, isNull);
      });
    });

    group('RenameTweakMigration', () {
      test('should rename tweak names', () {
        const migration = RenameTweakMigration(
          4,
          5,
          oldTweakName: 'grip_width',
          newTweakName: 'grip',
        );

        // Test rename tweak
        final result1 = migration.migrate('bench press', {'grip_width': 'wide', 'tempo': 'slow'});
        expect(result1, isNotNull);
        expect(result1!.$1, equals('bench press'));
        expect(result1.$2, equals({'grip': 'wide', 'tempo': 'slow'}));

        // Test no change needed
        final result2 = migration.migrate('bench press', {'grip': 'wide', 'tempo': 'slow'});
        expect(result2, isNull);
      });

      test('should rename option values', () {
        const migration = RenameTweakMigration(
          5,
          6,
          oldTweakName: 'grip',
          oldOptionValue: 'narrow',
          newOptionValue: 'close',
        );

        // Test rename option value
        final result1 = migration.migrate('bench press', {'grip': 'narrow', 'tempo': 'slow'});
        expect(result1, isNotNull);
        expect(result1!.$1, equals('bench press'));
        expect(result1.$2, equals({'grip': 'close', 'tempo': 'slow'}));

        // Test no change needed
        final result2 = migration.migrate('bench press', {'grip': 'wide', 'tempo': 'slow'});
        expect(result2, isNull);
      });

      test('should apply only to target exercise when specified', () {
        const migration = RenameTweakMigration(
          6,
          7,
          targetExerciseId: 'bench press',
          oldTweakName: 'grip_width',
          newTweakName: 'grip',
        );

        // Test applies to target exercise
        final result1 = migration.migrate('bench press', {'grip_width': 'wide'});
        expect(result1, isNotNull);
        expect(result1!.$2, equals({'grip': 'wide'}));

        // Test doesn't apply to other exercises
        final result2 = migration.migrate('squat', {'grip_width': 'wide'});
        expect(result2, isNull);
      });
    });
  });

  group('ExerciseMigrationService', () {
    test('should apply multiple migrations in sequence', () {
      // Create test migrations
      const migrations = [
        RenameExerciseMigration(1, 2, {'old squat': 'squat'}),
        SplitExerciseMigration(2, 3, 'squat', 'depth', {
          'quarter': 'quarter squat',
          'full': 'full squat',
        }),
      ];

      // Mock the exerciseMigrations list for testing
      // Note: In real implementation, we'd need to modify the service to accept migrations as parameter
      // For now, this tests the logic conceptually

      // Test sequential application
      var (currentId, currentTweaks) = ('old squat', {'depth': 'quarter', 'stance': 'wide'});

      // Apply first migration (rename)
      final result1 = migrations[0].migrate(currentId, currentTweaks);
      if (result1 != null) {
        currentId = result1.$1;
        currentTweaks = result1.$2;
      }
      expect(currentId, equals('squat'));
      expect(currentTweaks, equals({'depth': 'quarter', 'stance': 'wide'}));

      // Apply second migration (split)
      final result2 = migrations[1].migrate(currentId, currentTweaks);
      if (result2 != null) {
        currentId = result2.$1;
        currentTweaks = result2.$2;
      }
      expect(currentId, equals('quarter squat'));
      expect(currentTweaks, equals({'stance': 'wide'})); // depth removed
    });

    test('should handle no applicable migrations', () {
      final (newId, newTweaks) = ExerciseMigrationService.migrateExercise(
        'bench press',
        {'grip': 'wide'},
        1,
        1, // Same version, no migrations
      );

      expect(newId, equals('bench press'));
      expect(newTweaks, equals({'grip': 'wide'}));
    });

    test('utility methods should work correctly', () {
      // Test isMigrationNeeded (with empty migrations list)
      expect(ExerciseMigrationService.isMigrationNeeded(1, 2), isFalse);

      // Test getApplicableMigrations
      final applicable = ExerciseMigrationService.getApplicableMigrations(1, 2);
      expect(applicable, isEmpty);

      // Test getMigrationDescription
      final description = ExerciseMigrationService.getMigrationDescription(1, 2);
      expect(description, equals('No migrations needed'));
    });
  });
}
