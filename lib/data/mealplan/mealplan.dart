import 'package:ptc/model/mealplanner/meal_plan.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ptc/data/mealplan/mealplan_persistence_provider.dart';
import 'package:ptc/data/mealplan/current_mealplan_provider.dart';

part 'mealplan.g.dart';

@Riverpod(keepAlive: true)
class Mealplan extends _$Mealplan {
  @override
  Future<MealPlan> build() async {
    ref.onDispose(() {
      print('mealplan provider disposed');
    });

    // Watch the current mealplan ID to rebuild when it changes
    final currentMealplan = await ref.watch(currentMealplanProvider.future);

    // Listen to state changes and save automatically
    ref.listenSelf((previous, next) async {
      if (next.value == null) return;
      final service = await ref.read(mealplanPersistenceProvider.future);
      await service.saveMealplan(currentMealplan, next.value!);
    });

    // Try to load saved mealplan
    final service = await ref.read(mealplanPersistenceProvider.future);
    final savedMealplan = await service.loadMealplan(currentMealplan);
    return savedMealplan ??
        MealPlan(
            name:
                'Meal Plan ${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}');
  }

  void updateName(String name) =>
      state = AsyncData(state.value!.copyWith(name: name));
}
