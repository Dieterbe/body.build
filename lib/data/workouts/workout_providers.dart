// ignore_for_file: prefer-match-file-name

import 'dart:async';

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
  static const _autoCloseThreshold = Duration(minutes: 1);
  static const _autoCloseBuffer = Duration(minutes: 1);
  static const _autoRefreshInterval = Duration(minutes: 1);

  Timer? _autoRefreshTimer;

  @override
  Stream<model.WorkoutState> build() {
    final service = ref.watch(workoutPersistenceServiceProvider);

    // to enforce a run of _closeStaleActiveWorkout if there are other events triggering
    _autoRefreshTimer ??= Timer.periodic(_autoRefreshInterval, (_) => ref.invalidateSelf());
    ref.onDispose(() => _autoRefreshTimer?.cancel());

    return service.watchAllWorkouts().asyncMap((allWorkouts) async {
      final normalizedWorkouts = await _closeStaleActiveWorkout(allWorkouts, service);

      return model.WorkoutState(
        allWorkouts: normalizedWorkouts,
        activeWorkout: normalizedWorkouts.where((w) => w.isActive).firstOrNull,
        completedWorkouts: normalizedWorkouts.where((w) => !w.isActive).toList(),
      );
    });
  }

  Future<List<model.Workout>> _closeStaleActiveWorkout(
    List<model.Workout> allWorkouts,
    WorkoutPersistenceService service,
  ) async {
    final activeWorkout = allWorkouts.where((w) => w.isActive).firstOrNull;
    if (activeWorkout == null) {
      return allWorkouts;
    }

    final now = DateTime.now();
    final lastSetTime = activeWorkout.sets.lastOrNull?.timestamp;
    DateTime? autoCloseEndTime;

    if (lastSetTime == null && now.difference(activeWorkout.startTime) >= _autoCloseThreshold) {
      autoCloseEndTime = activeWorkout.startTime.add(_autoCloseBuffer);
      print("auto-closing stale empty workout ${activeWorkout.id}");
    }

    if (lastSetTime != null && now.difference(lastSetTime) >= _autoCloseThreshold) {
      autoCloseEndTime = lastSetTime.add(_autoCloseBuffer);
      print("auto-closing stale workout ${activeWorkout.id}");
    }

    if (autoCloseEndTime != null) {
      await service.endWorkout(activeWorkout.id, endTime: autoCloseEndTime);
      return await service.getAllWorkouts();
    }

    return allWorkouts;
  }

  Future<void> closeStaleActiveWorkout() async {
    final service = ref.read(workoutPersistenceServiceProvider);
    final workouts = await service.getAllWorkouts();
    await _closeStaleActiveWorkout(workouts, service);
  }

  // start workout or resume if there's an active one
  Future<String> startWorkout({DateTime? startTime, String? notes}) async {
    final service = ref.read(workoutPersistenceServiceProvider);

    final currentState = await future;
    final existing = currentState.activeWorkout;

    return (existing != null)
        ? existing.id
        : await service.createWorkout(startTime: startTime, notes: notes);
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

  /// Create a new workout from a template (prior workout)
  /// Copies all sets with completed=false, keeping weight/reps/rir/comments as defaults
  Future<String> startWorkoutFromTemplate(String templateWorkoutId) async {
    final service = ref.read(workoutPersistenceServiceProvider);
    return await service.startWorkoutFromTemplate(templateWorkoutId);
  }
}

/// Derived provider - gets specific workout by ID from the unified state
@riverpod
Future<model.Workout?> workoutById(Ref ref, String workoutId) async {
  final state = await ref.watch(workoutManagerProvider.future);
  return state.allWorkouts.where((w) => w.id == workoutId).firstOrNull;
}
