import 'dart:convert';
import 'package:bodybuild/data/dataset/ex.dart';
import 'package:bodybuild/model/programmer/set_group.dart' as programmer;
import 'package:bodybuild/model/programmer/workout.dart' as programmer;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout.freezed.dart';
part 'workout.g.dart';

@freezed
abstract class Workout with _$Workout {
  const Workout._(); // Enable custom methods

  const factory Workout({
    required String id,
    required DateTime startTime,
    DateTime? endTime, // NULL for active workouts
    String? notes,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default([]) List<WorkoutSet> sets,
  }) = _Workout;

  factory Workout.fromJson(Map<String, dynamic> json) => _$WorkoutFromJson(json);

  // Custom getters
  bool get isActive => endTime == null;

  Duration get duration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  Set<String> get exerciseIds => sets.map((s) => s.exerciseId).toSet();

  /// Heuristic conversion of flat logged sets into a programmer Workout.
  /// Detects interleaved patterns (combo/super sets) and infers repeat count `n`.
  ///
  /// Algorithm: walk through sets in order, building a candidate pattern.
  /// When we see an exercise+tweaks combo that's already in the current pattern,
  /// we check if the sequence so far is a repeating pattern. If so, we count
  /// the repetitions. When the pattern breaks, we emit a SetGroup and start fresh.
  programmer.Workout toProgrammerWorkout({String? name}) {
    if (sets.isEmpty) return programmer.Workout(name: name ?? 'unnamed workout');

    final exMap = {for (final ex in exes) ex.id: ex};
    final result = <programmer.SetGroup>[];

    // Represent each set as a key for pattern matching
    String setKey(WorkoutSet s) {
      final tweaksKey = s.tweaks.entries.map((e) => '${e.key}:${e.value}').toList()..sort();
      return '${s.exerciseId}|${tweaksKey.join(',')}';
    }

    var i = 0;
    while (i < sets.length) {
      // Try to find the longest non-repeating pattern starting at i
      final patternKeys = <String>[];
      final patternSets = <WorkoutSet>[];
      var j = i;

      // Build the initial pattern (first occurrence of each unique set key)
      while (j < sets.length) {
        final key = setKey(sets[j]);
        if (patternKeys.contains(key)) break;
        patternKeys.add(key);
        patternSets.add(sets[j]);
        j++;
      }

      // Count how many full repetitions of this pattern follow
      final patternLen = patternKeys.length;
      var rounds = 1;
      while (i + rounds * patternLen <= sets.length) {
        var matches = true;
        for (var k = 0; k < patternLen; k++) {
          final idx = i + rounds * patternLen + k;
          if (idx >= sets.length || setKey(sets[idx]) != patternKeys[k]) {
            matches = false;
            break;
          }
        }
        if (!matches) break;
        rounds++;
      }

      // Also check for partial trailing rounds (some exercises have fewer reps)
      // For now, keep it simple: only count full rounds, then handle remaining
      // sets as a separate group in the next iteration.

      // Build the SetGroup
      final groupSets = patternSets.map((ws) {
        final ex = exMap[ws.exerciseId];
        return programmer.Sets(1, ex: ex, n: rounds, tweakOptions: ws.tweaks);
      }).toList();

      result.add(programmer.SetGroup(groupSets));
      i += rounds * patternLen;
    }

    return programmer.Workout(name: name ?? 'unnamed workout', setGroups: result);
  }
}

@freezed
abstract class WorkoutSet with _$WorkoutSet {
  const WorkoutSet._(); // Enable custom methods

  const factory WorkoutSet({
    required String id,
    required String workoutId,
    required String exerciseId,
    @Default({}) Map<String, String> tweaks,
    double? weight,
    int? reps,
    int? rir, // Reps in Reserve
    String? comments,
    required int setOrder, // we're "the i-th set in the workout (grouped by time)", not persisted
    required DateTime timestamp,
    @Default(true) bool completed, // false = planned set, true = completed set
  }) = _WorkoutSet;

  factory WorkoutSet.fromJson(Map<String, dynamic> json) => _$WorkoutSetFromJson(json);

  String get tweaksJson => json.encode(tweaks);

  static Map<String, String> tweaksFromJson(String jsonStr) {
    if (jsonStr.isEmpty) return {};
    final decoded = json.decode(jsonStr);
    return Map<String, String>.from(decoded);
  }
}

/// UI model for grouping sets by exercise and tweaks
/// This is not persisted to the database - it's a view model for the UI
@freezed
abstract class ExerciseSetGroup with _$ExerciseSetGroup {
  const ExerciseSetGroup._();

  const factory ExerciseSetGroup({
    required String exerciseId,
    @Default({}) Map<String, String> tweaks,
    required List<WorkoutSet> sets,
  }) = _ExerciseSetGroup;

  factory ExerciseSetGroup.fromJson(Map<String, dynamic> json) => _$ExerciseSetGroupFromJson(json);

  /// Create groups from a list of sets
  static List<ExerciseSetGroup> fromSets(List<WorkoutSet> sets) {
    final groupedSets = <String, List<WorkoutSet>>{};
    for (final set in sets) {
      final tweaksKey = set.tweaks.entries.map((e) => '${e.key}:${e.value}').toList()..sort();
      final groupKey = '${set.exerciseId}|${tweaksKey.join(',')}';
      groupedSets.putIfAbsent(groupKey, () => []).add(set);
    }

    return groupedSets.entries.map((entry) {
      final firstSet = entry.value.firstOrNull!;
      return ExerciseSetGroup(
        exerciseId: firstSet.exerciseId,
        tweaks: firstSet.tweaks,
        sets: entry.value,
      );
    }).toList();
  }
}

/// State container for all workout data
@freezed
abstract class WorkoutState with _$WorkoutState {
  const WorkoutState._();

  const factory WorkoutState({
    required List<Workout> allWorkouts,
    Workout? activeWorkout,
    required List<Workout> completedWorkouts,
  }) = _WorkoutState;

  factory WorkoutState.fromJson(Map<String, dynamic> json) => _$WorkoutStateFromJson(json);
}
