import 'package:bodybuild/data/mealplan/mealplan_persistence_provider.dart';
import 'package:bodybuild/model/mealplanner/meal_plan.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_mealplan_provider.g.dart';

@Riverpod()
class CurrentMealplan extends _$CurrentMealplan {
  @override
  Future<String> build() async {
    ref.onDispose(() {
      print('current mealplan provider disposed');
    });

    // Get the persistence service
    final service = await ref.read(mealplanPersistenceProvider.future);

    // Try to load the last selected mealplan ID
    final lastMealplanId = service.loadLastMealplanId();
    if (lastMealplanId != null) {
      // Verify the mealplan still exists
      final mealplan = service.loadMealplan(lastMealplanId);
      if (mealplan != null) {
        return lastMealplanId;
      }
    }

    // If no last mealplan or it doesn't exist anymore, get the first available mealplan
    final mealplans = service.loadMealplans();

    if (mealplans.isEmpty) {
      final newId = DateTime.now().millisecondsSinceEpoch.toString();
      await service.saveMealplan(newId, const MealPlan(name: 'New Mealplan'));
      await service.saveLastMealplanId(newId);
      return newId;
    }

    final firstId = mealplans.keys.first;
    await service.saveLastMealplanId(firstId);
    return firstId;
  }

  void select(String id) async {
    state = AsyncData(id);
    // Save the selected mealplan ID
    final service = await ref.read(mealplanPersistenceProvider.future);
    await service.saveLastMealplanId(id);
  }
}
