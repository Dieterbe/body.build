/// Enrichment CLI: reads a body.build SQLite export and writes an analytics
/// SQLite file that adds a set_recruitments table.
///
/// Usage:
///   dart run bin/enrich.dart <input.sqlite> <output.sqlite>
///
/// The input file is the SQLite export produced by the body.build app.
/// The output file is created (or overwritten) with:
///   - Input tables copied (exercises migrated if there's a new schema version)
///   - A new `set_recruitments` table: (set_id, program_group, volume)

library;

import 'dart:io';

import 'package:bodybuild/data/dataset/ex.dart';
import 'package:bodybuild/data/dataset/exercise_versioning.dart';
import 'package:bodybuild/data/dataset/program_group.dart';
import 'package:bodybuild/service/exercise_migration_service.dart';
import 'package:bodybuild/util/tweaks.dart';
import 'package:sqlite3/sqlite3.dart';

void main(List<String> args) {
  if (args.length != 2) {
    stderr.writeln('Usage: dart run bin/enrich.dart <input.sqlite> <output.sqlite>');
    exit(1);
  }

  final inputPath = args[0];
  final outputPath = args[1];

  if (!File(inputPath).existsSync()) {
    stderr.writeln('Input file not found: $inputPath');
    exit(1);
  }

  // Copy input to output so we can add tables without touching the original.
  File(inputPath).copySync(outputPath);

  final db = sqlite3.open(outputPath);

  try {
    _enrich(db);
  } finally {
    db.dispose();
  }

  print('Done. Analytics SQLite written to: $outputPath');
}

void _enrich(Database db) {
  // --- Check exercise dataset version ---
  final exportVersion = _readExportVersion(db);
  if (exportVersion == null) {
    stderr.writeln(
      'Error: exercise_versions table missing or empty in export. '
      'Cannot determine exercise dataset version — aborting.',
    );
    exit(1);
  }

  final fromVersion = exportVersion;

  if (fromVersion > exerciseDatasetVersion) {
    stderr.writeln(
      'Error: export was created with exercise dataset v$fromVersion, '
      'but this tool only knows v$exerciseDatasetVersion. '
      'Please update the body.build source and re-run.',
    );
    exit(1);
  }

  if (fromVersion < exerciseDatasetVersion) {
    print('Export exercise dataset v$fromVersion -> migrating to v$exerciseDatasetVersion:');
    print(ExerciseMigrationService.getMigrationDescription(fromVersion, exerciseDatasetVersion));
  } else {
    print('Exercise dataset v$exerciseDatasetVersion: no migration needed.');
  }

  // --- Build exercise lookup map ---
  final exMap = {for (final ex in exes) ex.id: ex};

  // --- Create set_recruitments table ---
  db.execute('DROP TABLE IF EXISTS set_recruitments');
  db.execute('''
    CREATE TABLE set_recruitments (
      set_id        TEXT NOT NULL,
      program_group TEXT NOT NULL,
      volume        REAL NOT NULL,
      PRIMARY KEY (set_id, program_group)
    )
  ''');

  // --- Process each workout set ---
  final sets = db.select('SELECT id, exercise_id, tweaks FROM workout_sets WHERE completed = 1');

  var processed = 0;
  var skipped = 0;

  final stmt = db.prepare(
    'INSERT INTO set_recruitments (set_id, program_group, volume) VALUES (?, ?, ?)',
  );

  db.execute('BEGIN');

  try {
    for (final row in sets) {
      final setId = row['id'] as String;
      var exerciseId = row['exercise_id'] as String;
      var tweaks = tweaksFromJson((row['tweaks'] as String?) ?? '');

      // Apply exercise migrations if needed and write back to the analytics DB.
      if (fromVersion < exerciseDatasetVersion) {
        final originalId = exerciseId;
        final originalTweaks = tweaks;
        (exerciseId, tweaks) = ExerciseMigrationService.migrateExercise(
          exerciseId,
          tweaks,
          fromVersion,
          exerciseDatasetVersion,
        );
        if (exerciseId != originalId || tweaks.toString() != originalTweaks.toString()) {
          db.execute('UPDATE workout_sets SET exercise_id = ?, tweaks = ? WHERE id = ?', [
            exerciseId,
            tweaksToJson(tweaks),
            setId,
          ]);
        }
      }

      final ex = exMap[exerciseId];
      if (ex == null) {
        stderr.writeln('Warning: unknown exercise "$exerciseId" (set $setId) — skipping.');
        skipped++;
        continue;
      }

      for (final pg in ProgramGroup.values) {
        final assign = ex.recruitment(pg, tweaks);
        if (assign.volume > 0) {
          stmt.execute([setId, pg.name, assign.volume]);
        }
      }

      processed++;
    }

    db.execute('COMMIT');
  } catch (e) {
    db.execute('ROLLBACK');
    rethrow;
  } finally {
    stmt.dispose();
  }

  print('Processed $processed sets, skipped $skipped.');
  print(
    'set_recruitments rows: ${db.select('SELECT COUNT(*) AS n FROM set_recruitments').first['n']}',
  );
}

int? _readExportVersion(Database db) {
  try {
    final rows = db.select("SELECT version FROM exercise_versions WHERE id = 'current' LIMIT 1");
    if (rows.isEmpty) return null;
    return rows.first['version'] as int?;
  } catch (_) {
    return null;
  }
}
