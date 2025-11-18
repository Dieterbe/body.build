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
  // How long we allow a workout to stay idle before auto-closing it.
  // the human body cools down and most of the workout stresses subside after this much time
  static const autoCloseThreshold = Duration(minutes: 30);
  // When we close a workout we end it a little after the last activity, to
  // 1) avoid zero-duration workouts, 2) account for the duration of a quick cooldown
  static const autoCloseBuffer = Duration(minutes: 5);
  // Periodically we force the provider to recompute even if the database stream is silent.
  static const _autoRefreshInterval = Duration(minutes: 10);

  // Lazily created timer that invalidates the provider so stale workouts close even without writes.
  Timer? _autoRefreshTimer;
  // Prevent overlapping sweeps when the DB is slow.
  bool _autoCloseSweepInProgress = false;

  @override
  Stream<model.WorkoutState> build() {
    final service = ref.watch(workoutPersistenceServiceProvider);

    // Ensure the auto-close logic runs on a schedule, not only when Drift emits because of writes.
    _autoRefreshTimer ??= Timer.periodic(_autoRefreshInterval, (_) {
      if (_autoCloseSweepInProgress) {
        return;
      }
      _autoCloseSweepInProgress = true;
      unawaited(
        closeStaleActiveWorkout().whenComplete(() {
          _autoCloseSweepInProgress = false;
        }),
      );
    });
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

    if (lastSetTime == null && now.difference(activeWorkout.startTime) >= autoCloseThreshold) {
      autoCloseEndTime = activeWorkout.startTime.add(autoCloseBuffer);
      print("auto-closing stale empty workout ${activeWorkout.id}");
    }

    if (lastSetTime != null && now.difference(lastSetTime) >= autoCloseThreshold) {
      autoCloseEndTime = lastSetTime.add(autoCloseBuffer);
      print("auto-closing stale workout ${activeWorkout.id}");
    }

    if (autoCloseEndTime != null) {
      await service.endWorkout(activeWorkout.id, autoCloseEndTime);
      return await service.getAllWorkouts();
    }

    return allWorkouts;
  }

  Future<void> closeStaleActiveWorkout() async {
    // Utility for screens: run the same normalisation outside the stream pathway (e.g. on first load).
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

  Future<void> endWorkout(String workoutId, DateTime endTime) async {
    final service = ref.read(workoutPersistenceServiceProvider);
    await service.endWorkout(workoutId, endTime);
  }

  Future<String> addSet({
    required String workoutId,
    required String exerciseId,
    Map<String, String> tweaks = const {},
    double? weight,
    int? reps,
    int? rir,
    String? comments,
    bool completed = true,
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
      completed: completed,
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
