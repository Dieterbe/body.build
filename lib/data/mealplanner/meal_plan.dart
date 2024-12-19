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
    required List<Meal> meals,
  }) = _DayPlan;

  factory DayPlan.fromJson(Map<String, dynamic> json) =>
      _$DayPlanFromJson(json);
}

@freezed
class Meal with _$Meal {
  const factory Meal({
    required String desc,
    required Targets targets,
  }) = _Meal;

  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);
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
