import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'meal_plan_setup.freezed.dart';
part 'meal_plan_setup.g.dart';

enum CalorieCyclingType {
  off,
  on,
  psmf,
}

@freezed
class MealPlanSetup with _$MealPlanSetup {
  const factory MealPlanSetup({
    required int weeklyKcal,
    @Default(CalorieCyclingType.off) CalorieCyclingType calorieCycling,
    @Default(4) int mealsPerDay,
    @Default(1.0) double energyBalanceFactor,
    @Default(3) int trainingDaysPerWeek,
  }) = _MealPlanSetup;

  factory MealPlanSetup.fromJson(Map<String, dynamic> json) =>
      _$MealPlanSetupFromJson(json);
}

@riverpod
class MealPlanSetupNotifier extends _$MealPlanSetupNotifier {
  @override
  MealPlanSetup build() {
    return const MealPlanSetup(
      weeklyKcal: 14000, // Default 2000 kcal per day
    );
  }

  void updateSetup(MealPlanSetup setup) {
    state = setup;
  }

  void updateWeeklyKcal(int kcal) {
    state = state.copyWith(weeklyKcal: kcal);
  }

  void updateCalorieCycling(CalorieCyclingType type) {
    state = state.copyWith(calorieCycling: type);
  }

  void updateMealsPerDay(int meals) {
    state = state.copyWith(mealsPerDay: meals);
  }

  void updateEnergyBalanceFactor(double factor) {
    state = state.copyWith(energyBalanceFactor: factor);
  }

  void updateTrainingDays(int days) {
    state = state.copyWith(trainingDaysPerWeek: days);
  }
}
