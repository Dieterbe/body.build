import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'meal_plan.dart';

part 'meal_plan_persistence_provider.g.dart';

@riverpod
class MealPlanPersistence extends _$MealPlanPersistence {
  static const _key = 'meal_plans';

  @override
  Future<List<MealPlan>> build() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_key);
    if (jsonString == null) return [];
    
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => MealPlan.fromJson(json)).toList();
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, json.encode(updatedPlans));
    state = AsyncValue.data(updatedPlans);
  }
}
