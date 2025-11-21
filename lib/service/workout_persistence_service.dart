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

  Future<void> endWorkout(String workoutId, DateTime endTime) async {
    final companion = WorkoutsCompanion(endTime: Value(endTime), updatedAt: Value(DateTime.now()));

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
  Future<String> addWorkoutSet(model.WorkoutSet workoutSet) async {
    final id = _uuid.v4();
    final now = DateTime.now();

    final companion = WorkoutSetsCompanion(
      id: Value(id),
      workoutId: Value(workoutSet.workoutId),
      exerciseId: Value(workoutSet.exerciseId),
      tweaks: Value(workoutSet.tweaksJson),
      weight: Value(workoutSet.weight),
      reps: Value(workoutSet.reps),
      rir: Value(workoutSet.rir),
      comments: Value(workoutSet.comments),
      timestamp: Value(workoutSet.timestamp),
      completed: Value(workoutSet.completed),
    );

    await _database.insertWorkoutSet(companion);

    // Update workout timestamp to trigger stream updates
    await _database.updateWorkoutFields(
      workoutSet.workoutId,
      WorkoutsCompanion(updatedAt: Value(now)),
    );

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
      completed: Value(workoutSet.completed),
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
      completed: setData.completed,
    );
  }

  /// Create a new workout from a template (prior workout or built-in template)
  /// Copies all sets with completed=false, keeping weight/reps/rir/comments as defaults
  Future<String> startWorkoutFromTemplate(String templateId) async {
    // Check if it's a built-in template first
    final builtinTemplate = await _database.getTemplateById(templateId);

    List<model.WorkoutSet> setsToAdd;

    if (builtinTemplate != null) {
      // Load from built-in template
      final templateSets = await _database.getTemplateSets(templateId);
      setsToAdd = templateSets
          .map(
            (ts) => model.WorkoutSet(
              id: '', // Will be generated
              workoutId: '', // Will be set below
              exerciseId: ts.exerciseId,
              tweaks: model.WorkoutSet.tweaksFromJson(ts.tweaks),
              weight: null,
              reps: null,
              rir: null,
              comments: null,
              setOrder: 0, // Will be computed at read time based on timestamp
              timestamp: DateTime.now(), // Will be updated with proper spacing in insertion loop
              completed: false,
            ),
          )
          .toList();
    } else {
      // Load from past workout
      final templateWorkout = await getWorkoutById(templateId);
      if (templateWorkout == null) {
        throw Exception('Template not found: $templateId');
      }
      setsToAdd = templateWorkout.sets;
    }

    // Reuse existing active workout if available, otherwise create a new one
    final activeWorkout = await getActiveWorkout();
    final targetWorkoutId = activeWorkout?.id ?? await createWorkout();

    // Copy all sets as planned sets (completed=false)
    for (var i = 0; i < setsToAdd.length; i++) {
      await addWorkoutSet(
        setsToAdd[i].copyWith(
          workoutId: targetWorkoutId,
          completed: false,
          timestamp: DateTime.now(),
        ),
      );
      // Small delay to ensure timestamp ordering
      await Future.delayed(const Duration(milliseconds: 1));
    }

    return targetWorkoutId;
  }
}
