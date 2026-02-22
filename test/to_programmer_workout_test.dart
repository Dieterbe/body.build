import 'package:bodybuild/data/dataset/ex.dart';
import 'package:bodybuild/model/workouts/workout.dart';
import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';

/// Helper to create a WorkoutSet with minimal boilerplate
WorkoutSet _ws(String exerciseId, {Map<String, String> tweaks = const {}, int order = 0}) {
  return WorkoutSet(
    id: 'set-$order',
    workoutId: 'w1',
    exerciseId: exerciseId,
    tweaks: tweaks,
    setOrder: order,
    timestamp: DateTime(2025, 1, 1).add(Duration(seconds: order)),
  );
}

/// Helper to create a Workout from a list of sets
Workout _workout(List<WorkoutSet> sets) {
  return Workout(
    id: 'w1',
    startTime: DateTime(2025, 1, 1),
    createdAt: DateTime(2025, 1, 1),
    updatedAt: DateTime(2025, 1, 1),
    sets: sets,
  );
}

void main() {
  // Pick two real exercise IDs from the dataset
  final exA = exes.elementAtOrNull(0)!.id; // "standing barbell good morning"
  final exB = exes.elementAtOrNull(4)!.id; // "deadlift (powerlift)"

  group('Workout.toProgrammerWorkout', () {
    test('empty workout returns empty setGroups', () {
      final w = _workout([]);
      final result = w.toProgrammerWorkout(name: 'test');

      expect(result.name, 'test');
      expect(result.setGroups, isEmpty);
    });

    test('single exercise repeated 3 times → 1 SetGroup with n=3', () {
      final w = _workout([_ws(exA, order: 0), _ws(exA, order: 1), _ws(exA, order: 2)]);
      final result = w.toProgrammerWorkout();

      expect(result.setGroups.length, 1);
      expect(result.setGroups.elementAtOrNull(0)!.sets.length, 1);
      expect(result.setGroups.elementAtOrNull(0)!.sets.elementAtOrNull(0)!.ex?.id, exA);
      expect(result.setGroups.elementAtOrNull(0)!.sets.elementAtOrNull(0)!.n, 3);
    });

    test('two different exercises in sequence → 2 SetGroups each with n=1', () {
      final w = _workout([_ws(exA, order: 0), _ws(exB, order: 1)]);
      final result = w.toProgrammerWorkout();

      // exA then exB with no repetition → single group with 2 exercises, n=1 each
      // Actually the algorithm builds the pattern [exA, exB] and finds 1 round
      expect(result.setGroups.length, 1);
      expect(result.setGroups.elementAtOrNull(0)!.sets.length, 2);
      expect(result.setGroups.elementAtOrNull(0)!.sets.elementAtOrNull(0)!.ex?.id, exA);
      expect(result.setGroups.elementAtOrNull(0)!.sets.elementAtOrNull(0)!.n, 1);
      expect(result.setGroups.elementAtOrNull(0)!.sets.elementAtOrNull(1)!.ex?.id, exB);
      expect(result.setGroups.elementAtOrNull(0)!.sets.elementAtOrNull(1)!.n, 1);
    });

    test('superset pattern A,B,A,B,A,B → 1 SetGroup with 2 exercises, n=3', () {
      final w = _workout([
        _ws(exA, order: 0),
        _ws(exB, order: 1),
        _ws(exA, order: 2),
        _ws(exB, order: 3),
        _ws(exA, order: 4),
        _ws(exB, order: 5),
      ]);
      final result = w.toProgrammerWorkout();

      expect(result.setGroups.length, 1);
      expect(result.setGroups.elementAtOrNull(0)!.sets.length, 2);
      expect(result.setGroups.elementAtOrNull(0)!.sets.elementAtOrNull(0)!.ex?.id, exA);
      expect(result.setGroups.elementAtOrNull(0)!.sets.elementAtOrNull(0)!.n, 3);
      expect(result.setGroups.elementAtOrNull(0)!.sets.elementAtOrNull(1)!.ex?.id, exB);
      expect(result.setGroups.elementAtOrNull(0)!.sets.elementAtOrNull(1)!.n, 3);
    });

    test('A,A,A,B,B → 2 SetGroups: A×3 then B×2', () {
      final w = _workout([
        _ws(exA, order: 0),
        _ws(exA, order: 1),
        _ws(exA, order: 2),
        _ws(exB, order: 3),
        _ws(exB, order: 4),
      ]);
      final result = w.toProgrammerWorkout();

      expect(result.setGroups.length, 2);
      // First group: exA × 3
      expect(result.setGroups.elementAtOrNull(0)!.sets.length, 1);
      expect(result.setGroups.elementAtOrNull(0)!.sets.elementAtOrNull(0)!.ex?.id, exA);
      expect(result.setGroups.elementAtOrNull(0)!.sets.elementAtOrNull(0)!.n, 3);
      // Second group: exB × 2
      expect(result.setGroups.elementAtOrNull(1)!.sets.length, 1);
      expect(result.setGroups.elementAtOrNull(1)!.sets.elementAtOrNull(0)!.ex?.id, exB);
      expect(result.setGroups.elementAtOrNull(1)!.sets.elementAtOrNull(0)!.n, 2);
    });

    test('superset then straight sets: A,B,A,B,A,A → group1(A,B)×2 + group2(A)×2', () {
      final w = _workout([
        _ws(exA, order: 0),
        _ws(exB, order: 1),
        _ws(exA, order: 2),
        _ws(exB, order: 3),
        _ws(exA, order: 4),
        _ws(exA, order: 5),
      ]);
      final result = w.toProgrammerWorkout();

      expect(result.setGroups.length, 2);
      // First group: superset A,B repeated 2 times
      expect(result.setGroups.elementAtOrNull(0)!.sets.length, 2);
      expect(result.setGroups.elementAtOrNull(0)!.sets.elementAtOrNull(0)!.ex?.id, exA);
      expect(result.setGroups.elementAtOrNull(0)!.sets.elementAtOrNull(0)!.n, 2);
      expect(result.setGroups.elementAtOrNull(0)!.sets.elementAtOrNull(1)!.ex?.id, exB);
      expect(result.setGroups.elementAtOrNull(0)!.sets.elementAtOrNull(1)!.n, 2);
      // Second group: A repeated 2 times
      expect(result.setGroups.elementAtOrNull(1)!.sets.length, 1);
      expect(result.setGroups.elementAtOrNull(1)!.sets.elementAtOrNull(0)!.ex?.id, exA);
      expect(result.setGroups.elementAtOrNull(1)!.sets.elementAtOrNull(0)!.n, 2);
    });

    test('tweaks are preserved and differentiate sets', () {
      final tweaksA = {'rom': 'full'};
      final tweaksB = {'rom': 'partial'};
      final w = _workout([
        _ws(exA, tweaks: tweaksA, order: 0),
        _ws(exA, tweaks: tweaksA, order: 1),
        _ws(exA, tweaks: tweaksB, order: 2),
      ]);
      final result = w.toProgrammerWorkout();

      // Same exercise but different tweaks → treated as different sets
      expect(result.setGroups.length, 2);
      expect(result.setGroups.elementAtOrNull(0)!.sets.elementAtOrNull(0)!.tweakOptions, tweaksA);
      expect(result.setGroups.elementAtOrNull(0)!.sets.elementAtOrNull(0)!.n, 2);
      expect(result.setGroups.elementAtOrNull(1)!.sets.elementAtOrNull(0)!.tweakOptions, tweaksB);
      expect(result.setGroups.elementAtOrNull(1)!.sets.elementAtOrNull(0)!.n, 1);
    });

    test('custom name is used', () {
      final w = _workout([_ws(exA, order: 0)]);
      final result = w.toProgrammerWorkout(name: 'My Workout');
      expect(result.name, 'My Workout');
    });

    test('default name when none provided', () {
      final w = _workout([_ws(exA, order: 0)]);
      final result = w.toProgrammerWorkout();
      expect(result.name, 'unnamed workout');
    });

    test('single set → 1 SetGroup with n=1', () {
      final w = _workout([_ws(exA, order: 0)]);
      final result = w.toProgrammerWorkout();

      expect(result.setGroups.length, 1);
      expect(result.setGroups.elementAtOrNull(0)!.sets.length, 1);
      expect(result.setGroups.elementAtOrNull(0)!.sets.elementAtOrNull(0)!.n, 1);
    });
  });
}
