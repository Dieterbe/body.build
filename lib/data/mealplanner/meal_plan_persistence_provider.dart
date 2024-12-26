import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'meal_plan.dart';

part 'meal_plan_persistence_provider.g.dart';

@riverpod
class MealPlanPersistence extends _$MealPlanPersistence {
  static const _key = 'meal_plans';

  MealPlan _createDefaultPlan() {
    return MealPlan(
      id: const Uuid().v4(),
      name: 'New Meal Plan',
      dayplans: [],
    );
  }

  @override
  Future<List<MealPlan>> build() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_key);
    
    if (jsonString == null) {
      // Create default plan on first run
      final defaultPlan = _createDefaultPlan();
      await saveMealPlan(defaultPlan);
      return [defaultPlan];
    }
    
    final List<dynamic> jsonList = json.decode(jsonString);
    final plans = jsonList.map((json) => MealPlan.fromJson(json)).toList();
    
    // Ensure there's at least one plan
    if (plans.isEmpty) {
      final defaultPlan = _createDefaultPlan();
      await saveMealPlan(defaultPlan);
      return [defaultPlan];
    }
    
    return plans;
  }

  Future<void> saveMealPlan(MealPlan plan) async {
    final currentPlans = await future;
    final updatedPlans = [...currentPlans, plan];
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, json.encode(updatedPlans));
    state = AsyncValue.data(updatedPlans);
  }

  Future<void> deleteMealPlan(String planId) async {
    final currentPlans = await future;
    final updatedPlans = currentPlans.where((plan) => plan.id != planId).toList();
    
    // If we're deleting the last plan, create a new default one
    if (updatedPlans.isEmpty) {
      final defaultPlan = _createDefaultPlan();
      updatedPlans.add(defaultPlan);
    }
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, json.encode(updatedPlans));
    state = AsyncValue.data(updatedPlans);
  }
}
