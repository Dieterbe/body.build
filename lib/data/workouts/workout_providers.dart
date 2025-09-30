import 'package:bodybuild/data/workouts/workout_database.dart';
import 'package:bodybuild/model/workouts/workout.dart' as model;
import 'package:bodybuild/service/workout_persistence_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workout_providers.g.dart';

// Database provider - singleton to avoid multiple instances
@Riverpod(keepAlive: true)
WorkoutDatabase workoutDatabase(Ref ref) {
  return WorkoutDatabase();
}

// Persistence service provider - singleton to match database
@Riverpod(keepAlive: true)
WorkoutPersistenceService workoutPersistenceService(Ref ref) {
  final database = ref.watch(workoutDatabaseProvider);
  return WorkoutPersistenceService(database);
}

/// Unified workout manager - single source of truth for all workout state
@riverpod
class WorkoutManager extends _$WorkoutManager {
  @override
  Future<model.WorkoutState> build() async {
    final service = ref.watch(workoutPersistenceServiceProvider);
    final allWorkouts = await service.getAllWorkouts();

    final activeWorkout = allWorkouts.where((w) => w.isActive).firstOrNull;
    final completedWorkouts = allWorkouts.where((w) => !w.isActive).toList();

    return model.WorkoutState(
      allWorkouts: allWorkouts,
      activeWorkout: activeWorkout,
      completedWorkouts: completedWorkouts,
    );
  }

  Future<String> startWorkout({DateTime? startTime, String? notes}) async {
    final service = ref.read(workoutPersistenceServiceProvider);

    // Check for existing active workout
    final currentState = await future;
    final existing = currentState.activeWorkout;

    if (existing != null) {
      final lastSetTime = await service.getLastSetTime(existing.id);
      final now = DateTime.now();

      // If last set was more than 30 minutes ago, end the old workout
      if (lastSetTime != null && now.difference(lastSetTime).inMinutes > 30) {
        await service.endWorkout(existing.id, endTime: lastSetTime.add(const Duration(minutes: 5)));
      } else {
        // Resume existing workout
        return existing.id;
      }
    }

    // Create new workout
    final workoutId = await service.createWorkout(startTime: startTime, notes: notes);
    ref.invalidateSelf();
    return workoutId;
  }

  Future<void> endWorkout(String workoutId, {DateTime? endTime}) async {
    final service = ref.read(workoutPersistenceServiceProvider);
    await service.endWorkout(workoutId, endTime: endTime);
    ref.invalidateSelf();
  }

  Future<String> addSet({
    required String workoutId,
    required String exerciseId,
    Map<String, String> modifiers = const {},
    Map<String, bool> cues = const {},
    double? weight,
    int? reps,
    int? rir,
    String? comments,
  }) async {
    final service = ref.read(workoutPersistenceServiceProvider);
    final setId = await service.addWorkoutSet(
      workoutId: workoutId,
      exerciseId: exerciseId,
      modifiers: modifiers,
      cues: cues,
      weight: weight,
      reps: reps,
      rir: rir,
      comments: comments,
    );

    ref.invalidateSelf();
    return setId;
  }

  Future<void> updateSet(String workoutId, model.WorkoutSet workoutSet) async {
    final service = ref.read(workoutPersistenceServiceProvider);
    await service.updateWorkoutSet(workoutSet);
    ref.invalidateSelf();
  }

  Future<void> deleteSet(String workoutId, String setId) async {
    final service = ref.read(workoutPersistenceServiceProvider);
    await service.deleteWorkoutSet(setId);
    ref.invalidateSelf();
  }

  Future<void> updateWorkoutNotes(String workoutId, String? notes) async {
    final service = ref.read(workoutPersistenceServiceProvider);
    final workout = await service.getWorkoutById(workoutId);
    if (workout != null) {
      await service.updateWorkout(workout.copyWith(notes: notes));
      ref.invalidateSelf();
    }
  }

  Future<void> deleteWorkout(String workoutId) async {
    final service = ref.read(workoutPersistenceServiceProvider);
    await service.deleteWorkout(workoutId);
    ref.invalidateSelf();
  }
}

/// Derived provider - gets specific workout by ID from the unified state
@riverpod
Future<model.Workout?> workoutById(Ref ref, String workoutId) async {
  final state = await ref.watch(workoutManagerProvider.future);
  return state.allWorkouts.where((w) => w.id == workoutId).firstOrNull;
}
