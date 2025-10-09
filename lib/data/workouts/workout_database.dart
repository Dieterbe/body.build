import 'package:bodybuild/data/programmer/exercises.dart';
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
  TextColumn get tweaks => text()(); // JSON string
  RealColumn get weight => real().nullable()();
  IntColumn get reps => integer().nullable()();
  IntColumn get rir => integer().nullable()(); // Reps in Reserve
  TextColumn get comments => text().nullable()();
  DateTimeColumn get timestamp => dateTime()();
  IntColumn get setOrder => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

// Exercise version tracking table
class ExerciseVersions extends Table {
  TextColumn get id =>
      text().withDefault(const Constant('current'))(); // Always 'current' for the active version
  IntColumn get version => integer()(); // Current exercise dataset version in use
  DateTimeColumn get setAt => dateTime()(); // When this version was set
  TextColumn get source => text()(); // 'code', 'migration', 'manual'

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Workouts, WorkoutSets, ExerciseVersions])
class WorkoutDatabase extends _$WorkoutDatabase {
  WorkoutDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        if (details.wasCreated) {
          print("drift database just created");
          await setCurrentExerciseVersion(exerciseDatasetVersion, 'initial');
        } else {
          print("drift database already exists");
          await _checkExerciseMigration();
        }
        await customStatement('PRAGMA foreign_keys = ON');
      },
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // Add exercise_versions table
          await m.createTable(exerciseVersions);
          // Set initial version
          await setCurrentExerciseVersion(exerciseDatasetVersion, 'migration');
        }
      },
    );
  }

  // Workout queries
  Future<List<Workout>> getAllWorkouts() => select(workouts).get();
  Stream<List<Workout>> watchAllWorkouts() => select(workouts).watch();

  Future<List<Workout>> getCompletedWorkouts() =>
      (select(workouts)..where((w) => w.endTime.isNotNull())).get();
  Stream<List<Workout>> watchCompletedWorkouts() =>
      (select(workouts)..where((w) => w.endTime.isNotNull())).watch();

  Future<Workout?> getActiveWorkout() =>
      (select(workouts)..where((w) => w.endTime.isNull())).getSingleOrNull();
  Stream<Workout?> watchActiveWorkout() =>
      (select(workouts)..where((w) => w.endTime.isNull())).watchSingleOrNull();

  Future<Workout?> getWorkoutById(String id) =>
      (select(workouts)..where((w) => w.id.equals(id))).getSingleOrNull();
  Stream<Workout?> watchWorkoutById(String id) =>
      (select(workouts)..where((w) => w.id.equals(id))).watchSingleOrNull();

  Future<int> insertWorkout(WorkoutsCompanion workout) => into(workouts).insert(workout);

  Future<bool> updateWorkout(WorkoutsCompanion workout) => update(workouts).replace(workout);

  Future<int> updateWorkoutFields(String id, WorkoutsCompanion workout) =>
      (update(workouts)..where((w) => w.id.equals(id))).write(workout);

  Future<int> deleteWorkout(String id) => (delete(workouts)..where((w) => w.id.equals(id))).go();

  // Workout set queries
  Future<List<WorkoutSet>> getWorkoutSets(String workoutId) =>
      (select(workoutSets)
            ..where((s) => s.workoutId.equals(workoutId))
            ..orderBy([(s) => OrderingTerm(expression: s.setOrder)]))
          .get();
  Stream<List<WorkoutSet>> watchWorkoutSets(String workoutId) =>
      (select(workoutSets)
            ..where((s) => s.workoutId.equals(workoutId))
            ..orderBy([(s) => OrderingTerm(expression: s.setOrder)]))
          .watch();

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

  // Exercise version tracking
  Future<int?> getCurrentExerciseVersion() async {
    final version =
        await (select(exerciseVersions)
              ..where((v) => v.id.equals('current'))
              ..limit(1))
            .getSingleOrNull();

    return version?.version;
  }

  Future<void> setCurrentExerciseVersion(int version, String source) async {
    await into(exerciseVersions).insert(
      ExerciseVersionsCompanion(
        id: const Value('current'),
        version: Value(version),
        setAt: Value(DateTime.now()),
        source: Value(source),
      ),
      mode: InsertMode.insertOrIgnore,
    );
  }

  Future<void> _checkExerciseMigration() async {
    // TODO: This would integrate with a migration service
    // For now, just a placeholder
    final currentVersion = await getCurrentExerciseVersion();
    if (currentVersion != exerciseDatasetVersion) {
      throw ('Exercise migration needed: ${currentVersion!} -> $exerciseDatasetVersion');
    }
  }
}

QueryExecutor _openConnection() => driftDatabase(name: 'workouts');
