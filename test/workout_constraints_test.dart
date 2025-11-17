import 'package:bodybuild/data/workouts/workout_database.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late WorkoutDatabase database;

  setUp(() {
    database = WorkoutDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  group('Workout Constraints', () {
    test('allows creating one active workout', () async {
      final workout1 = WorkoutsCompanion(
        id: const Value('workout1'),
        startTime: Value(DateTime.now()),
        endTime: const Value.absent(), // Active workout
        createdAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      );

      await database.insertWorkout(workout1);
      final activeWorkout = await database.getActiveWorkout();

      expect(activeWorkout, isNotNull);
      expect(activeWorkout!.id, 'workout1');
    });

    test('prevents creating second active workout (database constraint)', () async {
      final now = DateTime.now();

      // Create first active workout
      final workout1 = WorkoutsCompanion(
        id: const Value('workout1'),
        startTime: Value(now),
        endTime: const Value.absent(), // Active
        createdAt: Value(now),
        updatedAt: Value(now),
      );
      await database.insertWorkout(workout1);

      // Try to create second active workout - should fail
      final workout2 = WorkoutsCompanion(
        id: const Value('workout2'),
        startTime: Value(now),
        endTime: const Value.absent(), // Active
        createdAt: Value(now),
        updatedAt: Value(now),
      );

      await expectLater(database.insertWorkout(workout2), throwsA(isA<SqliteException>()));
    });

    test('allows creating second workout after first is completed', () async {
      final now = DateTime.now();

      // Create and complete first workout
      final workout1 = WorkoutsCompanion(
        id: const Value('workout1'),
        startTime: Value(now),
        endTime: Value(now.add(const Duration(hours: 1))), // Completed
        createdAt: Value(now),
        updatedAt: Value(now),
      );
      await database.insertWorkout(workout1);

      // Create second active workout - should succeed
      final workout2 = WorkoutsCompanion(
        id: const Value('workout2'),
        startTime: Value(now.add(const Duration(hours: 2))),
        endTime: const Value.absent(), // Active
        createdAt: Value(now.add(const Duration(hours: 2))),
        updatedAt: Value(now.add(const Duration(hours: 2))),
      );

      await database.insertWorkout(workout2);
      final activeWorkout = await database.getActiveWorkout();

      expect(activeWorkout, isNotNull);
      expect(activeWorkout!.id, 'workout2');
    });

    test('allows multiple completed workouts', () async {
      final now = DateTime.now();

      // Create multiple completed workouts
      for (var i = 0; i < 5; i++) {
        final workout = WorkoutsCompanion(
          id: Value('workout$i'),
          startTime: Value(now.add(Duration(hours: i))),
          endTime: Value(now.add(Duration(hours: i, minutes: 30))), // All completed
          createdAt: Value(now),
          updatedAt: Value(now),
        );
        await database.insertWorkout(workout);
      }

      final completedWorkouts = await database.getCompletedWorkouts();
      expect(completedWorkouts.length, 5);

      final activeWorkout = await database.getActiveWorkout();
      expect(activeWorkout, isNull);
    });

    test('allows resuming workout by clearing end_time', () async {
      final now = DateTime.now();

      // Create completed workout
      final workout = WorkoutsCompanion(
        id: const Value('workout1'),
        startTime: Value(now),
        endTime: Value(now.add(const Duration(hours: 1))),
        createdAt: Value(now),
        updatedAt: Value(now),
      );
      await database.insertWorkout(workout);

      // Resume it (clear end_time)
      await database.updateWorkoutFields(
        'workout1',
        WorkoutsCompanion(endTime: const Value(null), updatedAt: Value(DateTime.now())),
      );

      final activeWorkout = await database.getActiveWorkout();
      expect(activeWorkout, isNotNull);
      expect(activeWorkout!.id, 'workout1');
    });
  });
}
