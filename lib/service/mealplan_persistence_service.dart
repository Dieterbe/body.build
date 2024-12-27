import 'dart:convert';
import 'package:ptc/model/mealplanner/meal_plan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MealplanPersistenceService {
  static const String _mealplansKey = 'mealplans';
  static const String _lastMealplanKey = 'last_mealplan_id';
  final SharedPreferences _prefs;

  MealplanPersistenceService(this._prefs);

  /// Loads all mealplans from SharedPreferences
  Future<Map<String, MealPlan>> loadMealplans() async {
    final String? mealplansJson = _prefs.getString(_mealplansKey);
    if (mealplansJson == null) return {};

    final Map<String, dynamic> mealplansMap = json.decode(mealplansJson);
    return mealplansMap.map((key, value) =>
        MapEntry(key, MealPlan.fromJson(value as Map<String, dynamic>)));
  }

  /// Helper method to save mealplans map to SharedPreferences
  Future<bool> _saveMealplans(Map<String, MealPlan> mealplans) {
    final mealplansJson = json
        .encode(mealplans.map((key, value) => MapEntry(key, value.toJson())));
    return _prefs.setString(_mealplansKey, mealplansJson);
  }

  /// Loads a specific mealplan by ID
  Future<MealPlan?> loadMealplan(String id) async {
    final mealplans = await loadMealplans();
    return mealplans[id];
  }

  /// Saves a mealplan to SharedPreferences
  Future<bool> saveMealplan(String id, MealPlan mealplan) async {
    final mealplans = await loadMealplans();
    mealplans[id] = mealplan;
    return _saveMealplans(mealplans);
  }

  /// Deletes a mealplan by ID
  Future<bool> deleteMealplan(String id) async {
    final mealplans = await loadMealplans();
    mealplans.remove(id);
    return _saveMealplans(mealplans);
  }

  /// Loads the ID of the last selected mealplan
  Future<String?> loadLastMealplanId() async {
    return _prefs.getString(_lastMealplanKey);
  }

  /// Saves the ID of the last selected mealplan
  Future<bool> saveLastMealplanId(String id) async {
    return _prefs.setString(_lastMealplanKey, id);
  }
}
