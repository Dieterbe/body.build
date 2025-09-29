import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'workout_database.g.dart';

// Workouts table
class Workouts extends Table {
  TextColumn get id => text()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime().nullable()(); // NULL for active workouts
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// Workout sets table
class WorkoutSets extends Table {
  TextColumn get id => text()();
  TextColumn get workoutId => text().references(Workouts, #id)();
  TextColumn get exerciseId => text()();
  TextColumn get modifiers => text()(); // JSON string
  TextColumn get cues => text()(); // JSON string
  RealColumn get weight => real().nullable()();
  IntColumn get reps => integer().nullable()();
  IntColumn get rir => integer().nullable()(); // Reps in Reserve
  TextColumn get comments => text().nullable()();
  DateTimeColumn get timestamp => dateTime()();
  IntColumn get setOrder => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Workouts, WorkoutSets])
class WorkoutDatabase extends _$WorkoutDatabase {
  WorkoutDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        if (details.wasCreated) {
          // ...
        }
        await customStatement('PRAGMA foreign_keys = ON');
      },
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {},
    );
  }

  // Workout queries
  Future<List<Workout>> getAllWorkouts() => select(workouts).get();

  Future<List<Workout>> getCompletedWorkouts() =>
      (select(workouts)..where((w) => w.endTime.isNotNull())).get();

  Future<Workout?> getActiveWorkout() =>
      (select(workouts)..where((w) => w.endTime.isNull())).getSingleOrNull();

  Future<Workout?> getWorkoutById(String id) =>
      (select(workouts)..where((w) => w.id.equals(id))).getSingleOrNull();

  Future<int> insertWorkout(WorkoutsCompanion workout) => into(workouts).insert(workout);

  Future<bool> updateWorkout(WorkoutsCompanion workout) => update(workouts).replace(workout);

  Future<int> deleteWorkout(String id) => (delete(workouts)..where((w) => w.id.equals(id))).go();

  // Workout set queries
  Future<List<WorkoutSet>> getWorkoutSets(String workoutId) =>
      (select(workoutSets)
            ..where((s) => s.workoutId.equals(workoutId))
            ..orderBy([(s) => OrderingTerm(expression: s.setOrder)]))
          .get();

  Future<WorkoutSet?> getLastSetForWorkout(String workoutId) =>
      (select(workoutSets)
            ..where((s) => s.workoutId.equals(workoutId))
            ..orderBy([(s) => OrderingTerm(expression: s.timestamp, mode: OrderingMode.desc)])
            ..limit(1))
          .getSingleOrNull();

  Future<int> insertWorkoutSet(WorkoutSetsCompanion workoutSet) =>
      into(workoutSets).insert(workoutSet);

  Future<bool> updateWorkoutSet(WorkoutSetsCompanion workoutSet) =>
      update(workoutSets).replace(workoutSet);

  Future<int> deleteWorkoutSet(String id) =>
      (delete(workoutSets)..where((s) => s.id.equals(id))).go();

  Future<int> deleteWorkoutSets(String workoutId) =>
      (delete(workoutSets)..where((s) => s.workoutId.equals(workoutId))).go();
}

QueryExecutor _openConnection() => driftDatabase(name: 'workouts');
