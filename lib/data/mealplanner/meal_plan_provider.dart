import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'meal_plan.dart';

part 'meal_plan_provider.g.dart';

@riverpod
class CurrentMealPlan extends _$CurrentMealPlan {
  @override
  MealPlan? build() => null;

  void setMealPlan(MealPlan plan) {
    state = plan;
  }

  void clearMealPlan() {
    state = null;
  }
}
