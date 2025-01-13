import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bodybuild/data/mealplan/mealplan_persistence_provider.dart';
import 'package:bodybuild/model/mealplanner/meal_plan.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mealplan_list_provider.g.dart';

@Riverpod()
Future<Map<String, MealPlan>> mealplanList(Ref ref) async {
  final service = await ref.watch(mealplanPersistenceProvider.future);
  return service.loadMealplans();
}
