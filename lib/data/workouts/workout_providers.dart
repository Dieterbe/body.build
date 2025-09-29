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

// Active workout provider
@riverpod
class ActiveWorkout extends _$ActiveWorkout {
  @override
  Future<model.Workout?> build() async {
    final service = ref.watch(workoutPersistenceServiceProvider);
    return service.getActiveWorkout();
  }

  Future<String> startWorkout({DateTime? startTime, String? notes}) async {
    final service = ref.read(workoutPersistenceServiceProvider);

    // Check for existing active workout
    final existing = await service.getActiveWorkout();
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

    // Also invalidate workout history
    ref.invalidate(workoutHistoryProvider);
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

  Future<void> updateWorkoutNotes(String workoutId, String? notes) async {
    final service = ref.read(workoutPersistenceServiceProvider);
    final workout = await service.getWorkoutById(workoutId);
    if (workout != null) {
      await service.updateWorkout(workout.copyWith(notes: notes));
      ref.invalidateSelf();
    }
  }
}

// Workout history provider
@riverpod
class WorkoutHistory extends _$WorkoutHistory {
  @override
  Future<List<model.Workout>> build() async {
    final service = ref.watch(workoutPersistenceServiceProvider);
    return service.getCompletedWorkouts();
  }

  Future<void> deleteWorkout(String workoutId) async {
    final service = ref.read(workoutPersistenceServiceProvider);
    await service.deleteWorkout(workoutId);
    ref.invalidateSelf();
  }
}

// All Workouts provider
// TODO: unify with WorkoutHistory, or get rid of it. cause if you invalidate either, it should invalidate the other
@riverpod
class WorkoutsAll extends _$WorkoutsAll {
  @override
  Future<List<model.Workout>> build() async {
    final service = ref.watch(workoutPersistenceServiceProvider);
    return service.getAllWorkouts();
  }

  Future<void> deleteWorkout(String workoutId) async {
    final service = ref.read(workoutPersistenceServiceProvider);
    await service.deleteWorkout(workoutId);
    ref.invalidateSelf();
  }
}

// Individual workout provider
@riverpod
Future<model.Workout?> workoutById(Ref ref, String workoutId) async {
  final service = ref.watch(workoutPersistenceServiceProvider);
  return service.getWorkoutById(workoutId);
}

// Workout operations provider
@riverpod
class WorkoutOperations extends _$WorkoutOperations {
  @override
  void build() {
    // No initial state needed
  }

  Future<void> updateSet(String workoutId, model.WorkoutSet workoutSet) async {
    final service = ref.read(workoutPersistenceServiceProvider);
    await service.updateWorkoutSet(workoutSet);

    // Invalidate the specific workout
    ref.invalidate(workoutByIdProvider(workoutId));

    // Also invalidate active workout if this is the active one
    final activeWorkout = await ref.read(activeWorkoutProvider.future);
    if (activeWorkout?.id == workoutId) {
      ref.invalidate(activeWorkoutProvider);
    }
  }

  Future<void> deleteSet(String workoutId, String setId) async {
    final service = ref.read(workoutPersistenceServiceProvider);
    await service.deleteWorkoutSet(setId);

    // Invalidate the specific workout
    ref.invalidate(workoutByIdProvider(workoutId));

    // Also invalidate active workout if this is the active one
    final activeWorkout = await ref.read(activeWorkoutProvider.future);
    if (activeWorkout?.id == workoutId) {
      ref.invalidate(activeWorkoutProvider);
    }
  }
}
