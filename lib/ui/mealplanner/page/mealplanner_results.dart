import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptc/data/mealplanner/meal_plan.dart';
import 'package:ptc/data/mealplanner/meal_plan_persistence_provider.dart';
import 'package:ptc/data/mealplanner/meal_plan_provider.dart';
import 'package:ptc/ui/mealplanner/widget/meal_plan_header.dart';

class MealPlannerResults extends ConsumerWidget {
  const MealPlannerResults({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPlan = ref.watch(currentMealPlanProvider);
    final savedPlans = ref.watch(mealPlanPersistenceProvider);

    return savedPlans.when(
      data: (plans) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MealPlanHeader(),
          if (currentPlan != null) ...[
            const SizedBox(height: 24),
            Text(
              currentPlan.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  currentPlan.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () {
                    ref
                        .read(mealPlanPersistenceProvider.notifier)
                        .saveMealPlan(currentPlan);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Meal plan saved!')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            ...currentPlan.dayplans.map((day) => _buildDayCard(context, day)),
          ],
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildDayCard(BuildContext context, DayPlan day) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  day.desc,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '${day.targets.kCal.round()} kcal',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildMacroTargetsRow(context, day.targets),
            const Divider(),
            ...day.meals.map((meal) => _buildMealRow(context, meal)),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroTargetsRow(BuildContext context, Targets targets) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildMacroColumn('Protein', targets.minProtein, targets.maxProtein),
        _buildMacroColumn('Carbs', targets.minCarbs, targets.maxCarbs),
        _buildMacroColumn('Fats', targets.minFats, targets.maxFats),
      ],
    );
  }

  Widget _buildMacroColumn(String name, double min, double max) {
    return Column(
      children: [
        Text(name),
        Text('${min.round()}-${max.round()}g'),
      ],
    );
  }

  Widget _buildMealRow(BuildContext context, Meal meal) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.desc,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  'P: ${meal.targets.minProtein.round()}-${meal.targets.maxProtein.round()}g '
                  'C: ${meal.targets.minCarbs.round()}-${meal.targets.maxCarbs.round()}g '
                  'F: ${meal.targets.minFats.round()}-${meal.targets.maxFats.round()}g',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Text(
            '${meal.targets.kCal.round()} kcal',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
