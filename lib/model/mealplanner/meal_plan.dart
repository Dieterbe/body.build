import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'meal_plan.freezed.dart';
part 'meal_plan.g.dart';

enum CalorieCyclingType { off, on, psmf }

/*
no weekly targets because:
- don't want to be locked in to week intervals
- what matters is the per day amounts, as those correspond to workouts
*/
@freezed
abstract class MealPlan with _$MealPlan {
  const factory MealPlan({
    required String name,
    @Default(<DayPlan>[]) List<DayPlan> dayplans,

    // to support the wizard.
    @Default(CalorieCyclingType.off) CalorieCyclingType calorieCycling,
    @Default(4) int mealsPerDay,
    @Default(3) int trainingDaysPerWeek,
  }) = _MealPlan;

  factory MealPlan.fromJson(Map<String, dynamic> json) => _$MealPlanFromJson(json);
}

@freezed
abstract class DayPlan with _$DayPlan {
  const factory DayPlan({
    required String desc,
    required Targets targets,
    required List<Event> events,
    // how many times this day is done within one plan (the plan duration is the sum of the num of all its days)
    @Default(1) int num,
  }) = _DayPlan;

  factory DayPlan.fromJson(Map<String, dynamic> json) => _$DayPlanFromJson(json);
}

@freezed
sealed class Event with _$Event {
  const factory Event.meal({required String desc, required Targets targets}) = MealEvent;

  const factory Event.strengthWorkout({required String desc, required double estimatedKcal}) =
      StrengthWorkoutEvent;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}

@freezed
abstract class Targets with _$Targets {
  const factory Targets({
    required double minProtein,
    required double maxProtein,
    required double minCarbs,
    required double maxCarbs,
    required double minFats,
    required double maxFats,
    required double kCal,
  }) = _Targets;

  factory Targets.fromJson(Map<String, dynamic> json) => _$TargetsFromJson(json);
}
