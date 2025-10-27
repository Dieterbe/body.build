// ignore_for_file: prefer-match-file-name

import 'package:bodybuild/data/workouts/workout_database.dart';
import 'package:bodybuild/model/workouts/workout.dart' as model;
import 'package:bodybuild/service/workout_persistence_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workout_providers.g.dart';

// Database provider - singleton to avoid multiple instances
@Riverpod(keepAlive: true)
WorkoutDatabase workoutDatabase(Ref _) {
  return WorkoutDatabase();
}

// Persistence service provider - singleton to match database
@Riverpod(keepAlive: true)
WorkoutPersistenceService workoutPersistenceService(Ref ref) {
  final database = ref.watch(workoutDatabaseProvider);
  return WorkoutPersistenceService(database);
}

/// Unified workout manager - single source of truth for all workout state
/// Uses Drift streams to automatically update when workout data changes
/// Need to stay alive because we check for active workout and navigate to different screen
/// Otherwise we get errors when the screen unmounts, provider disposes while the stream is loading
/// (e.g. when navigating from the articulations screen to 'start new workout')
@Riverpod(keepAlive: true)
class WorkoutManager extends _$WorkoutManager {
  @override
  Stream<model.WorkoutState> build() {
    final service = ref.watch(workoutPersistenceServiceProvider);

    // TODO: this is probably the best place to assure any stale active workouts
    // are terminated, but i can't be bothered to implement that here right now.
    return service.watchAllWorkouts().map(
      (allWorkouts) => model.WorkoutState(
        allWorkouts: allWorkouts,
        activeWorkout: allWorkouts.where((w) => w.isActive).firstOrNull,
        completedWorkouts: allWorkouts.where((w) => !w.isActive).toList(),
      ),
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

    return await service.createWorkout(startTime: startTime, notes: notes);
  }

  Future<void> endWorkout(String workoutId, {DateTime? endTime}) async {
    final service = ref.read(workoutPersistenceServiceProvider);
    await service.endWorkout(workoutId, endTime: endTime);
  }

  Future<String> addSet({
    required String workoutId,
    required String exerciseId,
    Map<String, String> tweaks = const {},
    double? weight,
    int? reps,
    int? rir,
    String? comments,
  }) async {
    final service = ref.read(workoutPersistenceServiceProvider);
    final setId = await service.addWorkoutSet(
      workoutId: workoutId,
      exerciseId: exerciseId,
      tweaks: tweaks,
      weight: weight,
      reps: reps,
      rir: rir,
      comments: comments,
    );
    return setId;
  }

  Future<void> updateSet(model.WorkoutSet workoutSet) async {
    final service = ref.read(workoutPersistenceServiceProvider);
    await service.updateWorkoutSet(workoutSet);
  }

  Future<void> deleteSet(String setId) async {
    final service = ref.read(workoutPersistenceServiceProvider);
    await service.deleteWorkoutSet(setId);
  }

  Future<void> updateWorkoutNotes(String workoutId, String? notes) async {
    final service = ref.read(workoutPersistenceServiceProvider);
    final workout = await service.getWorkoutById(workoutId);
    if (workout != null) {
      await service.updateWorkout(workout.copyWith(notes: notes));
    }
  }

  Future<void> deleteWorkout(String workoutId) async {
    final service = ref.read(workoutPersistenceServiceProvider);
    await service.deleteWorkout(workoutId);
  }

  Future<void> resumeWorkout(String workoutId) async {
    final service = ref.read(workoutPersistenceServiceProvider);
    await service.resumeWorkout(workoutId);
  }
}

/// Derived provider - gets specific workout by ID from the unified state
@riverpod
Future<model.Workout?> workoutById(Ref ref, String workoutId) async {
  final state = await ref.watch(workoutManagerProvider.future);
  return state.allWorkouts.where((w) => w.id == workoutId).firstOrNull;
}
