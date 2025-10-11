import 'package:bodybuild/data/workouts/workout_database.dart';
import 'package:bodybuild/model/workouts/workout.dart' as model;
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class WorkoutPersistenceService {
  final WorkoutDatabase _database;
  final Uuid _uuid = const Uuid();

  WorkoutPersistenceService(this._database);

  // Workout operations
  Future<List<model.Workout>> getAllWorkouts() async {
    final workouts = await _database.getAllWorkouts();
    return Future.wait(workouts.map(_workoutWithSets));
  }

  Stream<List<model.Workout>> watchAllWorkouts() {
    return _database.watchAllWorkouts().asyncMap((workouts) async {
      return Future.wait(workouts.map(_workoutWithSets));
    });
  }

  Future<List<model.Workout>> getCompletedWorkouts() async {
    final workouts = await _database.getCompletedWorkouts();
    return Future.wait(workouts.map(_workoutWithSets));
  }

  Future<model.Workout?> getActiveWorkout() async {
    final workout = await _database.getActiveWorkout();
    if (workout == null) return null;
    return _workoutWithSets(workout);
  }

  Future<model.Workout?> getWorkoutById(String id) async {
    final workout = await _database.getWorkoutById(id);
    if (workout == null) return null;
    return _workoutWithSets(workout);
  }

  Future<String> createWorkout({DateTime? startTime, String? notes}) async {
    final id = _uuid.v4();
    final now = DateTime.now();

    final companion = WorkoutsCompanion(
      id: Value(id),
      startTime: Value(startTime ?? now),
      endTime: const Value.absent(),
      notes: Value(notes),
      createdAt: Value(now),
      updatedAt: Value(now),
    );

    await _database.insertWorkout(companion);
    return id;
  }

  Future<void> updateWorkout(model.Workout workout) async {
    final companion = WorkoutsCompanion(
      id: Value(workout.id),
      startTime: Value(workout.startTime),
      endTime: Value(workout.endTime),
      notes: Value(workout.notes),
      createdAt: Value(workout.createdAt),
      updatedAt: Value(DateTime.now()),
    );

    await _database.updateWorkout(companion);
  }

  Future<void> endWorkout(String workoutId, {DateTime? endTime}) async {
    final companion = WorkoutsCompanion(
      endTime: Value(endTime ?? DateTime.now()),
      updatedAt: Value(DateTime.now()),
    );

    await _database.updateWorkoutFields(workoutId, companion);
  }

  Future<void> resumeWorkout(String workoutId) async {
    final companion = WorkoutsCompanion(
      endTime: const Value(null), // Remove end time to make it active again
      updatedAt: Value(DateTime.now()),
    );

    await _database.updateWorkoutFields(workoutId, companion);
  }

  Future<void> deleteWorkout(String id) async {
    await _database.deleteWorkoutSets(id);
    await _database.deleteWorkout(id);
  }

  // Workout set operations
  Future<String> addWorkoutSet({
    required String workoutId,
    required String exerciseId,
    Map<String, String> tweaks = const {},
    double? weight,
    int? reps,
    int? rir,
    String? comments,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();

    final companion = WorkoutSetsCompanion(
      id: Value(id),
      workoutId: Value(workoutId),
      exerciseId: Value(exerciseId),
      tweaks: Value(
        model.WorkoutSet(
          id: id,
          workoutId: workoutId,
          exerciseId: exerciseId,
          tweaks: tweaks,
          timestamp: now,
          setOrder: 0, // is ignored I think
        ).tweaksJson,
      ),
      weight: Value(weight),
      reps: Value(reps),
      rir: Value(rir),
      comments: Value(comments),
      timestamp: Value(now),
    );

    await _database.insertWorkoutSet(companion);

    // Update workout timestamp to trigger stream updates
    await _database.updateWorkoutFields(workoutId, WorkoutsCompanion(updatedAt: Value(now)));

    return id;
  }

  Future<void> updateWorkoutSet(model.WorkoutSet workoutSet) async {
    final companion = WorkoutSetsCompanion(
      id: Value(workoutSet.id),
      workoutId: Value(workoutSet.workoutId),
      exerciseId: Value(workoutSet.exerciseId),
      tweaks: Value(workoutSet.tweaksJson),
      weight: Value(workoutSet.weight),
      reps: Value(workoutSet.reps),
      rir: Value(workoutSet.rir),
      comments: Value(workoutSet.comments),
      timestamp: Value(workoutSet.timestamp),
    );

    await _database.updateWorkoutSet(companion);

    // Update workout timestamp to trigger stream updates
    await _database.updateWorkoutFields(
      workoutSet.workoutId,
      WorkoutsCompanion(updatedAt: Value(DateTime.now())),
    );
  }

  Future<void> deleteWorkoutSet(String id) async {
    // Get the workout ID before deleting
    final set = await (_database.select(
      _database.workoutSets,
    )..where((s) => s.id.equals(id))).getSingleOrNull();

    await _database.deleteWorkoutSet(id);

    // Update workout timestamp to trigger stream updates
    if (set != null) {
      await _database.updateWorkoutFields(
        set.workoutId,
        WorkoutsCompanion(updatedAt: Value(DateTime.now())),
      );
    }
  }

  Future<DateTime?> getLastSetTime(String workoutId) async {
    final lastSet = await _database.getLastSetForWorkout(workoutId);
    return lastSet?.timestamp;
  }

  // Helper method to convert database workout to domain model with sets
  Future<model.Workout> _workoutWithSets(Workout workout) async {
    final sets = await _database.getWorkoutSets(workout.id);
    final workoutSets = sets
        .asMap()
        .entries
        .map((e) => _convertWorkoutSet(e.value, e.key + 1))
        .toList();

    return model.Workout(
      id: workout.id,
      startTime: workout.startTime,
      endTime: workout.endTime,
      notes: workout.notes,
      createdAt: workout.createdAt,
      updatedAt: workout.updatedAt,
      sets: workoutSets,
    );
  }

  // Helper method to convert database workout set to domain model
  model.WorkoutSet _convertWorkoutSet(WorkoutSet setData, int setOrder) {
    return model.WorkoutSet(
      id: setData.id,
      workoutId: setData.workoutId,
      exerciseId: setData.exerciseId,
      tweaks: model.WorkoutSet.tweaksFromJson(setData.tweaks),
      weight: setData.weight,
      reps: setData.reps,
      rir: setData.rir,
      comments: setData.comments,
      setOrder: setOrder,
      timestamp: setData.timestamp,
    );
  }
}
