// ignore_for_file: prefer-match-file-name

import 'dart:convert';
import 'package:bodybuild/data/dataset/exercise_versioning.dart';
import 'package:bodybuild/service/exercise_migration_service.dart';
import 'package:drift/drift.dart';
import 'package:bodybuild/data/workouts/workout_database_connection.dart';
import 'package:flutter/foundation.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

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
  BoolColumn get completed =>
      boolean().withDefault(const Constant(true))(); // false = planned, true = completed
  // Note: setOrder is derived at runtime from timestamp ordering, not stored in DB

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

// Measurements table
class Measurements extends Table {
  TextColumn get id => text()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get timezoneOffset => text()();
  TextColumn get measurementType => text()(); // Enum as string: 'weight'
  RealColumn get value => real()();
  TextColumn get unit => text()(); // Enum as string: 'kg' or 'lbs'
  TextColumn get comment => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {timestamp, measurementType},
  ];
}

@DriftDatabase(tables: [Workouts, WorkoutSets, ExerciseVersions, Measurements])
class WorkoutDatabase extends _$WorkoutDatabase {
  WorkoutDatabase() : super(_openConnection());

  // Constructor for testing with custom QueryExecutor
  WorkoutDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 5;

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
        if (from < 3) {
          // Remove set_order column - it's now computed at runtime from timestamp
          await customStatement('ALTER TABLE workout_sets DROP COLUMN set_order');
        }
        if (from < 4) {
          // Add measurements table
          await m.createTable(measurements);
        }
        if (from < 5) {
          // Add completed column to workout_sets - default to true for existing sets
          await customStatement(
            'ALTER TABLE workout_sets ADD COLUMN completed INTEGER NOT NULL DEFAULT 1',
          );
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

  // Workout set queries (always ordered by timestamp)
  Future<List<WorkoutSet>> getWorkoutSets(String workoutId) =>
      (select(workoutSets)
            ..where((s) => s.workoutId.equals(workoutId))
            ..orderBy([(s) => OrderingTerm(expression: s.timestamp)]))
          .get();
  Stream<List<WorkoutSet>> watchWorkoutSets(String workoutId) =>
      (select(workoutSets)
            ..where((s) => s.workoutId.equals(workoutId))
            ..orderBy([(s) => OrderingTerm(expression: s.timestamp)]))
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
    await into(exerciseVersions).insertOnConflictUpdate(
      ExerciseVersionsCompanion(
        id: const Value('current'),
        version: Value(version),
        setAt: Value(DateTime.now()),
        source: Value(source),
      ),
    );
  }

  Future<void> _checkExerciseMigration() async {
    await transaction(() async {
      final currentVersion = await getCurrentExerciseVersion();

      if (currentVersion == null) {
        await Posthog().capture(
          eventName: 'ExerciseMigrationDriftFailed',
          properties: {'reason': 'current_version_unset', 'to_version': exerciseDatasetVersion},
        );
        throw Exception("current exercise version is unset. this should never happen");
      }
      if (currentVersion == exerciseDatasetVersion) {
        await Posthog().capture(
          eventName: 'ExerciseMigrationDriftSkipped',
          properties: {
            'reason': 'already_up_to_date',
            'from_version': currentVersion,
            'to_version': exerciseDatasetVersion,
          },
        );
        print(
          "migrator drift: already at latest version $exerciseDatasetVersion - no migration needed",
        );
        return;
      }

      if (currentVersion > exerciseDatasetVersion) {
        await Posthog().capture(
          eventName: 'ExerciseMigrationDriftFailed',
          properties: {
            'reason': 'future_version',
            'from_version': currentVersion,
            'to_version': exerciseDatasetVersion,
          },
        );
        throw Exception(
          'Database version ($currentVersion) newer than app ($exerciseDatasetVersion). Has app been downgraded? It should be upgraded',
        );
      }

      print(
        'migrator drift: migrating workout data from v$currentVersion to v$exerciseDatasetVersion',
      );

      // Get all workout sets
      final allSets = await select(workoutSets).get();
      var setsChanged = 0;
      for (final set in allSets) {
        final oldTweaks = _tweaksFromJson(set.tweaks);
        final (newId, newTweaks) = ExerciseMigrationService.migrateExercise(
          set.exerciseId,
          oldTweaks,
          currentVersion,
          exerciseDatasetVersion,
        );

        if (newId != set.exerciseId || !mapEquals(newTweaks, oldTweaks)) {
          setsChanged++;
          // Update the set
          await (update(workoutSets)..where((s) => s.id.equals(set.id))).write(
            WorkoutSetsCompanion(exerciseId: Value(newId), tweaks: Value(json.encode(newTweaks))),
          );
        }
      }
      await Posthog().capture(
        eventName: 'ExerciseMigrationDriftCompleted',
        properties: {
          'from_version': currentVersion,
          'to_version': exerciseDatasetVersion,
          'sets_checked': allSets.length,
          'sets_changed': setsChanged,
        },
      );

      // Update version
      await setCurrentExerciseVersion(exerciseDatasetVersion, 'migration');
      print('Migration complete');
    });
  }

  // Measurement queries. lists of measurements are always returned in TS ASC order
  Future<List<Measurement>> getAllMeasurements() => (select(
    measurements,
  )..orderBy([(m) => OrderingTerm(expression: m.timestamp, mode: OrderingMode.asc)])).get();

  Stream<List<Measurement>> watchAllMeasurements() => (select(
    measurements,
  )..orderBy([(m) => OrderingTerm(expression: m.timestamp, mode: OrderingMode.asc)])).watch();

  Future<List<Measurement>> getMeasurementsByType(String type) =>
      (select(measurements)
            ..where((m) => m.measurementType.equals(type))
            ..orderBy([(m) => OrderingTerm(expression: m.timestamp, mode: OrderingMode.asc)]))
          .get();

  Stream<List<Measurement>> watchMeasurementsByType(String type) =>
      (select(measurements)
            ..where((m) => m.measurementType.equals(type))
            ..orderBy([(m) => OrderingTerm(expression: m.timestamp, mode: OrderingMode.asc)]))
          .watch();

  Future<Measurement?> getLatestMeasurement() =>
      (select(measurements)
            ..orderBy([(m) => OrderingTerm(expression: m.timestamp, mode: OrderingMode.desc)])
            ..limit(1))
          .getSingleOrNull();

  Future<Measurement?> getLatestMeasurementByType(String type) =>
      (select(measurements)
            ..where((m) => m.measurementType.equals(type))
            ..orderBy([(m) => OrderingTerm(expression: m.timestamp, mode: OrderingMode.desc)])
            ..limit(1))
          .getSingleOrNull();

  Future<int> insertMeasurement(MeasurementsCompanion measurement) =>
      into(measurements).insert(measurement);

  Future<bool> updateMeasurement(MeasurementsCompanion measurement) =>
      update(measurements).replace(measurement);

  Future<int> deleteMeasurement(String id) =>
      (delete(measurements)..where((m) => m.id.equals(id))).go();
}

QueryExecutor _openConnection() {
  return openWorkoutDatabaseConnection();
}

// Helper to parse tweaks JSON without depending on model classes
Map<String, String> _tweaksFromJson(String jsonStr) {
  if (jsonStr.isEmpty) return {};
  final decoded = json.decode(jsonStr);
  return Map<String, String>.from(decoded);
}
