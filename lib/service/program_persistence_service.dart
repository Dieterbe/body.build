import 'dart:convert';

import 'package:bodybuild/data/dataset/exercise_versioning.dart';
import 'package:bodybuild/data/dataset/exercises.dart';
import 'package:bodybuild/model/programmer/program_state.dart';
import 'package:bodybuild/service/exercise_migration_service.dart';
import 'package:bodybuild/model/migration_report.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgramPersistenceService {
  static const String _programsKey = 'programs';
  static const String _lastProgramKey = 'last_program_id';
  static const String _exerciseVersionKey = 'exercise_dataset_version_programs';
  final SharedPreferences _prefs;

  ProgramPersistenceService(this._prefs);

  /// Loads all programs from SharedPreferences
  Map<String, ProgramState> loadPrograms() {
    final String? programsJson = _prefs.getString(_programsKey);
    if (programsJson == null) return {};

    final Map<String, dynamic> programsMap = json.decode(programsJson);
    return programsMap.map(
      (key, value) => MapEntry(key, ProgramState.fromJson(value as Map<String, dynamic>)),
    );
  }

  /// Helper method to save programs map to SharedPreferences
  Future<bool> _savePrograms(Map<String, ProgramState> programs) {
    final programsJson = json.encode(programs.map((key, value) => MapEntry(key, value.toJson())));
    return _prefs.setString(_programsKey, programsJson);
  }

  /// Loads a specific program by ID
  ProgramState? loadProgram(String id) {
    final programs = loadPrograms();
    return programs[id];
  }

  /// Saves a program to SharedPreferences
  Future<bool> saveProgram(String id, ProgramState program) async {
    final programs = loadPrograms();
    programs[id] = program;
    return await _savePrograms(programs);
  }

  /// Deletes a program by ID
  Future<bool> deleteProgram(String id) async {
    final programs = loadPrograms();
    programs.remove(id);
    return await _savePrograms(programs);
  }

  /// Loads the ID of the last selected program
  String? loadLastProgramId() {
    return _prefs.getString(_lastProgramKey);
  }

  /// Saves the ID of the last selected program
  Future<bool> saveLastProgramId(String id) async {
    return await _prefs.setString(_lastProgramKey, id);
  }

  /// Gets the current exercise dataset version from SharedPreferences
  int? getCurrentExerciseVersion() {
    return _prefs.getInt(_exerciseVersionKey);
  }

  /// Sets the current exercise dataset version in SharedPreferences
  Future<bool> setCurrentExerciseVersion(int version) {
    return _prefs.setInt(_exerciseVersionKey, version);
  }

  Future<MigrationReport?> runExerciseMigration() async {
    // if it's not set, use '0' which we never used in the DB, so migrations will execute
    final currentVersion = getCurrentExerciseVersion() ?? 0;
    if (currentVersion == exerciseDatasetVersion) {
      await Posthog().capture(
        eventName: 'ExerciseMigrationSkipped',
        properties: {
          'reason': 'already_up_to_date',
          'from_version': currentVersion,
          'to_version': exerciseDatasetVersion,
        },
      );
      return null;
    }

    var logs = <String>[];

    if (currentVersion > exerciseDatasetVersion) {
      await Posthog().capture(
        eventName: 'ExerciseMigrationFailed',
        properties: {
          'reason': 'future_version',
          'from_version': currentVersion,
          'to_version': exerciseDatasetVersion,
        },
      );
      return MigrationReport(
        from: currentVersion,
        to: exerciseDatasetVersion,
        logs: logs,
        error:
            'Program data references a newer exercise dataset ($currentVersion) than this app supports ($exerciseDatasetVersion). Please update the app.',
        boring: false,
      );
    }

    logs.add('Migrating program data from v$currentVersion to v$exerciseDatasetVersion.');

    // Load raw JSON to avoid losing exercises during deserialization
    final String? programsJson = _prefs.getString(_programsKey);
    if (programsJson == null) {
      logs.add('No programs found, setting version to $exerciseDatasetVersion.');
      await setCurrentExerciseVersion(exerciseDatasetVersion);
      await Posthog().capture(
        eventName: 'ExerciseMigrationSkipped',
        properties: {
          'reason': 'no_programs',
          'from_version': currentVersion,
          'to_version': exerciseDatasetVersion,
        },
      );
      return MigrationReport(
        from: currentVersion,
        to: exerciseDatasetVersion,
        logs: logs,
        boring: true,
      );
    }

    final Map<String, dynamic> rawPrograms = json.decode(programsJson);
    final updatedRawPrograms = <String, dynamic>{};
    var anyChanges = false;
    var programsProcessed = 0;
    var programsChanged = 0;
    var workoutsChanged = 0;
    var setGroupsChanged = 0;
    var setsMigrated = 0;

    for (final MapEntry(key: programId, value: rawProgram) in rawPrograms.entries) {
      final programData = rawProgram as Map<String, dynamic>;
      final workouts = programData['workouts'] as List<dynamic>? ?? [];
      final updatedWorkouts = <Map<String, dynamic>>[];
      var programChanged = false;
      programsProcessed++;

      for (final workoutData in workouts) {
        final workout = workoutData as Map<String, dynamic>;
        final setGroups = workout['setGroups'] as List<dynamic>? ?? [];
        final updatedSetGroups = <Map<String, dynamic>>[];
        var workoutChanged = false;

        for (final setGroupData in setGroups) {
          final setGroup = setGroupData as Map<String, dynamic>;
          final sets = setGroup['sets'] as List<dynamic>? ?? [];
          final updatedSets = <Map<String, dynamic>>[];
          var setGroupChanged = false;

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
              currentVersion,
              exerciseDatasetVersion,
            );

            if (newId == exerciseId && mapEquals(newTweaks, tweakOptions)) {
              updatedSets.add(set);
              continue;
            }

            // Verify the new exercise exists
            final resolvedExercise = exes.firstWhereOrNull((ex) => ex.id == newId);
            if (resolvedExercise == null) {
              final message = 'Unable to migrate program "$programId": exercise "$newId" not found';
              logs.add(message);
              await Posthog().capture(
                eventName: 'ExerciseMigrationFailed',
                properties: {
                  'reason': 'exercise_not_found',
                  'from_version': currentVersion,
                  'to_version': exerciseDatasetVersion,
                  'missing_exercise_id': newId,
                  'sets_migrated': setsMigrated,
                  'programs_processed': programsProcessed,
                },
              );
              return MigrationReport(
                from: currentVersion,
                to: exerciseDatasetVersion,
                logs: logs,
                error: message,
                boring: false,
              );
            }

            logs.add(
              'Program "$programId" workout "${workout['name'] ?? 'unnamed'}":'
              '$exerciseId → $newId, tweaks $tweakOptions → $newTweaks',
            );

            final updatedSet = Map<String, dynamic>.of(set);
            updatedSet['ex'] = newId;
            updatedSet['tweakOptions'] = newTweaks;
            updatedSets.add(updatedSet);

            setGroupChanged = true;
            workoutChanged = true;
            programChanged = true;
            setsMigrated++;
          }

          final updatedSetGroup = Map<String, dynamic>.of(setGroup);
          if (setGroupChanged) {
            updatedSetGroup['sets'] = updatedSets;
            setGroupsChanged++;
          }
          updatedSetGroups.add(updatedSetGroup);
        }

        final updatedWorkout = Map<String, dynamic>.of(workout);
        if (workoutChanged) {
          updatedWorkout['setGroups'] = updatedSetGroups;
          workoutsChanged++;
        }
        updatedWorkouts.add(updatedWorkout);
      }

      final updatedProgram = Map<String, dynamic>.of(programData);
      if (programChanged) {
        updatedProgram['workouts'] = updatedWorkouts;
        anyChanges = true;
        programsChanged++;
      }
      updatedRawPrograms[programId] = updatedProgram;
    }

    if (anyChanges) {
      logs.add('Saving migrated programs.');
      await _prefs.setString(_programsKey, json.encode(updatedRawPrograms));
    } else {
      logs.add('No program changes required.');
    }

    logs.add('Updating exercise dataset version to $exerciseDatasetVersion.');
    await setCurrentExerciseVersion(exerciseDatasetVersion);
    logs.add('Program data migration complete.');

    await Posthog().capture(
      eventName: 'ExerciseMigrationCompleted',
      properties: {
        'from_version': currentVersion,
        'to_version': exerciseDatasetVersion,
        'programs_processed': programsProcessed,
        'programs_changed': programsChanged,
        'workouts_changed': workoutsChanged,
        'set_groups_changed': setGroupsChanged,
        'sets_migrated': setsMigrated,
        'any_changes': anyChanges,
      },
    );

    return MigrationReport(
      from: currentVersion,
      to: exerciseDatasetVersion,
      logs: logs,
      boring: !anyChanges,
    );
  }
}
