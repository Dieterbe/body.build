import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'meal_plan.freezed.dart';
part 'meal_plan.g.dart';

@freezed
class MealPlan with _$MealPlan {
  const factory MealPlan({
    required String id,
    required String name,
    required List<DayPlan> dayplans,
  }) = _MealPlan;

  factory MealPlan.fromJson(Map<String, dynamic> json) =>
      _$MealPlanFromJson(json);
}

@freezed
class DayPlan with _$DayPlan {
  const factory DayPlan({
    required String desc,
    required Targets targets,
    required List<Event> events,
  }) = _DayPlan;

  factory DayPlan.fromJson(Map<String, dynamic> json) =>
      _$DayPlanFromJson(json);
}

@freezed
class Event with _$Event {
  const factory Event.meal({
    required String desc,
    required Targets targets,
  }) = MealEvent;

  const factory Event.strengthWorkout({
    required String desc,
    required double estimatedKcal,
  }) = StrengthWorkoutEvent;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}

@freezed
class Targets with _$Targets {
  const factory Targets({
    required double minProtein,
    required double maxProtein,
    required double minCarbs,
    required double maxCarbs,
    required double minFats,
    required double maxFats,
    required double kCal,
  }) = _Targets;

  factory Targets.fromJson(Map<String, dynamic> json) =>
      _$TargetsFromJson(json);
}
