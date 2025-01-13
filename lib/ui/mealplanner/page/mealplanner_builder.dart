import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bodybuild/data/mealplan/mealplan.dart';
import 'package:bodybuild/model/mealplanner/meal_plan.dart';
import 'package:bodybuild/ui/mealplanner/widget/day_column.dart';

class MealPlannerBuilder extends ConsumerWidget {
  const MealPlannerBuilder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(mealplanProvider);
    final notifier = ref.watch(mealplanProvider.notifier);

    return plan.when(
      error: (error, stack) =>
          Center(child: Text('Error loading plan: $error')),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (plan) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Days',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    notifier.addDay(DayPlan(
                      desc: 'New Day',
                      targets: plan.dayplans.isEmpty
                          ? const Targets(
                              minProtein: 150,
                              maxProtein: 200,
                              minCarbs: 200,
                              maxCarbs: 300,
                              minFats: 50,
                              maxFats: 80,
                              kCal: 2000,
                            )
                          : plan.dayplans.last.targets,
                      events: [],
                    ));
                  },
                  tooltip: 'Add Day',
                ),
              ],
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: plan.dayplans
                    .map((day) => DayColumn(plan: plan, day: day))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
