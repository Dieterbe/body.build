import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bodybuild/data/mealplan/current_mealplan_provider.dart';
import 'package:bodybuild/data/mealplan/mealplan_list_provider.dart';
import 'package:bodybuild/data/mealplan/mealplan_persistence_provider.dart';
import 'package:bodybuild/model/mealplanner/meal_plan.dart';
import 'package:bodybuild/ui/core/widget/data_manager.dart';

class MealPlanHeader extends ConsumerWidget {
  const MealPlanHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMealPlanId = ref.watch(currentMealplanProvider);

    List<String> getOpts(String currentId, Map<String, MealPlan> plans) {
      final currentName = plans[currentId]!.name;
      final otherNames = plans.entries
          .where((e) => e.key != currentId)
          .map((e) => e.value.name)
          .toList();
      return [currentName, ...otherNames];
    }

    onSelect(String name, Map<String, MealPlan> plans) {
      final entry = plans.entries.firstWhere((e) => e.value.name == name);
      ref.read(currentMealplanProvider.notifier).select(entry.key);
    }

    onCreate(String id, String name) async {
      final service = await ref.read(mealplanPersistenceProvider.future);
      final newPlan = MealPlan(name: name, dayplans: []);
      await service.saveMealplan(id, newPlan);
      ref.invalidate(mealplanListProvider);
      await ref.read(mealplanListProvider.future).then((_) {
        // Then switch to the new plan
        ref.read(currentMealplanProvider.notifier).select(id);
      });
    }

    onRename(String oldName, String newName) async {
      final service = await ref.read(mealplanPersistenceProvider.future);
      final plans = service.loadMealplans();
      final plan = plans.entries.firstWhere((p) => p.value.name == oldName);

      await service.saveMealplan(plan.key, plan.value.copyWith(name: newName));
      ref.invalidate(mealplanListProvider);
      // Wait for the plan list to be reloaded
      await ref.read(mealplanListProvider.future);
    }

    onDuplicate(String nameOld, String nameNew) async {
      final service = await ref.read(mealplanPersistenceProvider.future);
      final plans = service.loadMealplans();

      final plan = plans.entries.firstWhere((p) => p.value.name == nameOld);
      final newPlan = plan.value.copyWith(name: nameNew);
      final newId = DateTime.now().millisecondsSinceEpoch.toString();

      await service.saveMealplan(newId, newPlan);
      ref.invalidate(mealplanListProvider);
      await ref.read(mealplanListProvider.future);

      // Then switch to the new plan
      ref.read(currentMealplanProvider.notifier).select(newId);
    }

    onDelete(String name) async {
      final service = await ref.read(mealplanPersistenceProvider.future);
      var plans = service.loadMealplans();
      final plan = plans.entries.firstWhere((p) => p.value.name == name);
      await service.deleteMealplan(plan.key);

      // Get remaining plans after deletion
      plans = service.loadMealplans();
      ref.invalidate(mealplanListProvider);

      // If no plans exist, create a new default one
      if (plans.isEmpty) {
        final newId = DateTime.now().millisecondsSinceEpoch.toString();
        await service.saveMealplan(newId, const MealPlan(name: "default name mealplan"));
        ref.invalidate(mealplanListProvider);
        ref.read(currentMealplanProvider.notifier).select(newId);
      } else {
        // Select the first available plan
        ref.read(currentMealplanProvider.notifier).select(plans.keys.first);
      }
    }

    return currentMealPlanId.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
      data: (currentId) => ref
          .watch(mealplanListProvider)
          .when(
            loading: () => const CircularProgressIndicator(),
            error: (error, stack) => Text('Error: $error'),
            data: (plans) => DataManager(
              opts: getOpts(currentId, plans),
              onSelect: (name) => onSelect(name, plans),
              onCreate: onCreate,
              onRename: onRename,
              onDuplicate: onDuplicate,
              onDelete: onDelete,
            ),
          ),
    );
  }
}
