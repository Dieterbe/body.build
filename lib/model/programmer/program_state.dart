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
    return copyWith(
      workouts: workouts.map((workout) {
        return workout.copyWith(
          setGroups: workout.setGroups.map((setGroup) {
            return setGroup.copyWith(
              sets: setGroup.sets.map((sets) {
                final exerciseId = sets.ex?.id;
                if (exerciseId == null) return sets;

                final (newId, newTweaks) = ExerciseMigrationService.migrateExercise(
                  exerciseId,
                  sets.tweakOptions,
                  fromVersion,
                  exerciseDatasetVersion,
                );

                if (newId == exerciseId && mapEquals(newTweaks, sets.tweakOptions)) return sets;

                final resolvedExercise = exes.firstWhereOrNull((ex) => ex.id == newId);
                if (resolvedExercise == null) {
                  throw 'Migration failed: exercise "$newId" not found';
                }
                return sets.copyWith(ex: resolvedExercise, tweakOptions: newTweaks);
              }).toList(),
            );
          }).toList(),
        );
      }).toList(),
    );
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
