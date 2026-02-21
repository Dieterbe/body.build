import 'package:bodybuild/data/dataset/ex.dart';
import 'package:bodybuild/data/dataset/exercise_versioning.dart';
import 'package:bodybuild/model/programmer/workout.dart';
import 'package:bodybuild/model/workouts/template.dart';
import 'package:bodybuild/service/exercise_migration_service.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'program_state.freezed.dart';
part 'program_state.g.dart';

@freezed
abstract class ProgramState with _$ProgramState {
  const ProgramState._();

  const factory ProgramState({
    @Default('unnamed program') String name,
    @Default([]) List<Workout> workouts,
    @Default(false) bool builtin,
  }) = _ProgramState;

  factory ProgramState.fromJson(Map<String, dynamic> json) => _$ProgramStateFromJson(json);

  /// Convert each Workout in this program to a WorkoutTemplate,
  List<WorkoutTemplate> toTemplates() {
    final now = DateTime.now();
    const uuid = Uuid();
    return workouts
        .map(
          (workout) => WorkoutTemplate(
            id: uuid.v4(),
            description: 'Imported ${workout.name} from $name',
            isBuiltin: builtin,
            createdAt: now,
            updatedAt: now,
            workout: workout.copyWith(name: '$name / ${workout.name}'),
          ),
        )
        .toList();
  }

  /// Migrate a program's exercises from one version to another
  ProgramState migrate(int fromVersion) {
    final rawJson = toJson();

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
            throw 'Migration failed: exercise "$newId" not found';
          }
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

    return ProgramState.fromJson(updatedJson);
  }

  /// Validate that all exercises in the program exist in the current dataset
  String? validate() {
    final missingExercises = <String>{};

    for (final workout in workouts) {
      for (final setGroup in workout.setGroups) {
        for (final sets in setGroup.sets) {
          if (sets.ex == null) {
            missingExercises.add('unknown');
          }
        }
      }
    }

    if (missingExercises.isEmpty) {
      return null;
    }
    return 'Program contains unknown exercises: ${missingExercises.join(', ')}';
  }
}
