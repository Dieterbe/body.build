import 'dart:convert';
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
    required DateTime timestamp,
    required int setOrder,
  }) = _WorkoutSet;

  factory WorkoutSet.fromJson(Map<String, dynamic> json) => _$WorkoutSetFromJson(json);

  String get tweaksJson => json.encode(tweaks);

  static Map<String, String> tweaksFromJson(String jsonStr) {
    if (jsonStr.isEmpty) return {};
    final decoded = json.decode(jsonStr);
    return Map<String, String>.from(decoded);
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
