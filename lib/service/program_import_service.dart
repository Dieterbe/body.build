import 'dart:convert';

import 'package:bodybuild/data/dataset/ex.dart';
import 'package:bodybuild/data/dataset/exercise_versioning.dart';
import 'package:bodybuild/data/workouts/workout_database.dart';
import 'package:bodybuild/model/interchange/program_export.dart'
    show ProgramExport, programExportFormatVersion;
import 'package:bodybuild/model/programmer/program_state.dart';
import 'package:bodybuild/model/workouts/template.dart';
import 'package:bodybuild/service/exercise_migration_service.dart';
import 'package:bodybuild/service/template_persistence_service.dart';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

/// Result of a program import operation
class ProgramImportResult {
  final bool success;
  final List<WorkoutTemplate> templates;
  final List<String> logs;
  final String? error;
  final bool migrationApplied;

  const ProgramImportResult({
    required this.success,
    this.templates = const [],
    this.logs = const [],
    this.error,
    this.migrationApplied = false,
  });

  factory ProgramImportResult.failure(String error, {List<String> logs = const []}) {
    return ProgramImportResult(success: false, error: error, logs: logs);
  }

  factory ProgramImportResult.ok(
    List<WorkoutTemplate> templates, {
    List<String> logs = const [],
    bool migrationApplied = false,
  }) {
    return ProgramImportResult(
      success: true,
      templates: templates,
      logs: logs,
      migrationApplied: migrationApplied,
    );
  }
}

/// Service for importing programs from the interchange format
class ProgramImportService {
  final WorkoutDatabase _database;

  ProgramImportService(this._database);

  /// Parse and validate a program export JSON string
  ProgramExport? parseExportJson(String jsonString) {
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return ProgramExport.fromJson(json);
    } catch (e) {
      debugPrint('Failed to parse program export JSON: $e');
      return null;
    }
  }

  /// Pick a JSON file and parse it as a ProgramExport.
  /// Returns null if the user cancelled or the file is invalid.
  static Future<ProgramExport?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return null;

    final bytes = result.files.first.bytes;
    if (bytes == null) return null;

    try {
      final jsonString = utf8.decode(bytes);
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return ProgramExport.fromJson(json);
    } catch (e) {
      debugPrint('Failed to parse picked file: $e');
      return null;
    }
  }

  /// Import a program from the interchange format.
  /// Validates version compatibility, applies migrations if needed,
  /// and converts to WorkoutTemplates.
  Future<ProgramImportResult> importProgram(ProgramExport export) async {
    final logs = <String>[];
    final sourceVersion = export.exerciseDatasetVersion;

    logs.add('Importing program "${export.program.name}" from v$sourceVersion');

    // Check format version compatibility
    if (export.formatVersion > programExportFormatVersion) {
      return ProgramImportResult.failure(
        'Program export format v${export.formatVersion} is not supported. '
        'This app supports up to v$programExportFormatVersion. Please update the app.',
        logs: logs,
      );
    }

    // Check exercise dataset version compatibility
    if (sourceVersion > exerciseDatasetVersion) {
      return ProgramImportResult.failure(
        'Program requires exercise dataset v$sourceVersion, but this app only supports v$exerciseDatasetVersion. Please update the app.',
        logs: logs,
      );
    }

    // Apply migrations if needed
    ProgramState migratedProgram;
    bool migrationApplied = false;

    if (sourceVersion < exerciseDatasetVersion) {
      logs.add('Migrating from v$sourceVersion to v$exerciseDatasetVersion');
      final migrationResult = _migrateProgram(export.program, sourceVersion);
      if (migrationResult.error != null) {
        return ProgramImportResult.failure(
          migrationResult.error!,
          logs: [...logs, ...migrationResult.logs],
        );
      }
      migratedProgram = migrationResult.program!;
      migrationApplied = true;
      logs.addAll(migrationResult.logs);
    } else {
      migratedProgram = export.program;
    }

    // Validate all exercises exist
    final validationError = _validateExercises(migratedProgram);
    if (validationError != null) {
      return ProgramImportResult.failure(validationError, logs: logs);
    }

    // Convert to templates
    final templates = migratedProgram.toTemplates();
    logs.add('Created ${templates.length} workout templates');

    // Persist templates
    final templateService = TemplatePersistenceService(_database);
    for (final template in templates) {
      await templateService.createTemplate(template);
      logs.add('Saved template: ${template.name}');
    }

    return ProgramImportResult.ok(templates, logs: logs, migrationApplied: migrationApplied);
  }

  /// Migrate and validate a program without needing a DB.
  /// Returns the migrated [ProgramState] and whether migration was applied.
  /// Throws a [String] error message on failure.
  static ({ProgramState program, bool migrationApplied}) migrateAndValidate(ProgramExport export) {
    final sourceVersion = export.exerciseDatasetVersion;
    ProgramState program;
    bool migrationApplied = false;

    if (sourceVersion < exerciseDatasetVersion) {
      final result = _migrateProgram(export.program, sourceVersion);
      if (result.error != null) throw result.error!;
      program = result.program!;
      migrationApplied = true;
    } else {
      program = export.program;
    }

    final validationError = _validateExercises(program);
    if (validationError != null) throw validationError;

    return (program: program, migrationApplied: migrationApplied);
  }

  /// Migrate a program's exercises from one version to another
  static _MigrationResult _migrateProgram(ProgramState program, int fromVersion) {
    final logs = <String>[];
    final rawJson = program.toJson();

    final workouts = rawJson['workouts'] as List<dynamic>? ?? [];
    final updatedWorkouts = <Map<String, dynamic>>[];

    for (final workoutData in workouts) {
      final workout = workoutData as Map<String, dynamic>;
      final setGroups = workout['setGroups'] as List<dynamic>? ?? [];
      final updatedSetGroups = <Map<String, dynamic>>[];

      for (final setGroupData in setGroups) {
        final setGroup = setGroupData as Map<String, dynamic>;
        final sets = setGroup['sets'] as List<dynamic>? ?? [];
        final updatedSets = <Map<String, dynamic>>[];

        for (final setData in sets) {
          final set = setData as Map<String, dynamic>;
          final exerciseId = set['ex'] as String?;
          final tweakOptions =
              (set['tweakOptions'] as Map<String, dynamic>?)?.map(
                (k, v) => MapEntry(k, v.toString()),
              ) ??
              <String, String>{};

          if (exerciseId == null) {
            updatedSets.add(set);
            continue;
          }

          final (newId, newTweaks) = ExerciseMigrationService.migrateExercise(
            exerciseId,
            tweakOptions,
            fromVersion,
            exerciseDatasetVersion,
          );

          if (newId == exerciseId && mapEquals(newTweaks, tweakOptions)) {
            updatedSets.add(set);
            continue;
          }

          // Verify the new exercise exists
          final resolvedExercise = exes.firstWhereOrNull((ex) => ex.id == newId);
          if (resolvedExercise == null) {
            return _MigrationResult(
              error: 'Migration failed: exercise "$newId" not found',
              logs: logs,
            );
          }

          logs.add('Migrated: $exerciseId → $newId');

          final updatedSet = Map<String, dynamic>.of(set);
          updatedSet['ex'] = newId;
          updatedSet['tweakOptions'] = newTweaks;
          updatedSets.add(updatedSet);
        }

        final updatedSetGroup = Map<String, dynamic>.of(setGroup);
        updatedSetGroup['sets'] = updatedSets;
        updatedSetGroups.add(updatedSetGroup);
      }

      final updatedWorkout = Map<String, dynamic>.of(workout);
      updatedWorkout['setGroups'] = updatedSetGroups;
      updatedWorkouts.add(updatedWorkout);
    }

    final updatedJson = Map<String, dynamic>.of(rawJson);
    updatedJson['workouts'] = updatedWorkouts;

    return _MigrationResult(program: ProgramState.fromJson(updatedJson), logs: logs);
  }

  /// Validate that all exercises in the program exist in the current dataset
  static String? _validateExercises(ProgramState program) {
    final missingExercises = <String>{};

    for (final workout in program.workouts) {
      for (final setGroup in workout.setGroups) {
        for (final sets in setGroup.sets) {
          if (sets.ex == null) {
            missingExercises.add('unknown');
          }
        }
      }
    }

    if (missingExercises.isNotEmpty) {
      return 'Program contains unknown exercises: ${missingExercises.join(', ')}';
    }
    return null;
  }
}

class _MigrationResult {
  final ProgramState? program;
  final String? error;
  final List<String> logs;

  _MigrationResult({this.program, this.error, this.logs = const []});
}
