import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:ptc/data/mealplanner/meal_plan.dart';
import 'package:ptc/data/mealplanner/meal_plan_persistence_provider.dart';
import 'package:ptc/data/mealplanner/meal_plan_provider.dart';
import 'package:ptc/ui/core/widget/data_manager.dart';

class MealPlanHeader extends ConsumerWidget {
  const MealPlanHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> getOpts(MealPlan? currentPlan, List<MealPlan> plans) {
      if (currentPlan == null) return plans.map((p) => p.name).toList();
      return [
        currentPlan.name,
        ...plans.where((p) => p.id != currentPlan.id).map((p) => p.name),
      ];
    }

    return ref.watch(mealPlanPersistenceProvider).when(
          loading: () => const SizedBox(
            width: 200,
            child: LinearProgressIndicator(),
          ),
          error: (error, stack) => Text('Error: $error'),
          data: (plans) {
            final currentPlan = ref.watch(currentMealPlanProvider);
            
            // If no plan is selected but we have plans, select the first one
            if (currentPlan == null && plans.isNotEmpty) {
              // Use Future to avoid modifying state during build
              Future(() {
                ref.read(currentMealPlanProvider.notifier).setMealPlan(plans.first);
              });
              return const SizedBox(
                width: 200,
                child: LinearProgressIndicator(),
              );
            }

            // If we have no plans at all, show empty state
            if (plans.isEmpty) {
              return const SizedBox(
                width: 500,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No meal plans yet. Create one to get started!'),
                  ),
                ),
              );
            }

            return SizedBox(
              width: 500,
              child: DataManager(
                opts: getOpts(currentPlan, plans),
                onSelect: (name) {
                  final selectedPlan = plans.firstWhere((p) => p.name == name);
                  ref
                      .read(currentMealPlanProvider.notifier)
                      .setMealPlan(selectedPlan);
                },
                onCreate: (id, name) async {
                  final newPlan = MealPlan(
                    id: id,
                    name: name,
                    dayplans: [],
                  );
                  await ref
                      .read(mealPlanPersistenceProvider.notifier)
                      .saveMealPlan(newPlan);
                  ref
                      .read(currentMealPlanProvider.notifier)
                      .setMealPlan(newPlan);
                },
                onRename: (nameOld, nameNew) async {
                  final plan = plans.firstWhere((p) => p.name == nameOld);
                  final updatedPlan = plan.copyWith(name: nameNew);
                  await ref
                      .read(mealPlanPersistenceProvider.notifier)
                      .deleteMealPlan(plan.id);
                  await ref
                      .read(mealPlanPersistenceProvider.notifier)
                      .saveMealPlan(updatedPlan);
                  if (currentPlan?.id == plan.id) {
                    ref
                        .read(currentMealPlanProvider.notifier)
                        .setMealPlan(updatedPlan);
                  }
                },
                onDuplicate: (nameOld, nameNew) async {
                  final plan = plans.firstWhere((p) => p.name == nameOld);
                  final newPlan = plan.copyWith(
                    id: const Uuid().v4(),
                    name: nameNew,
                  );
                  await ref
                      .read(mealPlanPersistenceProvider.notifier)
                      .saveMealPlan(newPlan);
                  ref
                      .read(currentMealPlanProvider.notifier)
                      .setMealPlan(newPlan);
                },
                onDelete: (name) async {
                  final plan = plans.firstWhere((p) => p.name == name);
                  await ref
                      .read(mealPlanPersistenceProvider.notifier)
                      .deleteMealPlan(plan.id);
                  
                  // Get remaining plans after deletion (persistence provider ensures there's at least one)
                  final remainingPlans = await ref.read(mealPlanPersistenceProvider.future);
                  ref.read(currentMealPlanProvider.notifier).setMealPlan(remainingPlans.first);
                },
              ),
            );
          },
        );
  }
}
