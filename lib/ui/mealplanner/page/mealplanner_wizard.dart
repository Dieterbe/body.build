import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptc/data/mealplan/mealplan.dart';
import 'package:ptc/data/programmer/setup.dart';
import 'package:ptc/ui/mealplanner/widget/meal_plan_header.dart';
import '../../../model/mealplanner/meal_plan.dart';

class MealPlannerWizard extends ConsumerWidget {
  const MealPlannerWizard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(mealplanProvider);
    final setup = ref.watch(setupProvider);
    final notifier = ref.watch(mealplanProvider.notifier);

    return setup.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) =>
          Center(child: Text('Error loading settings: $error')),
      data: (setup) => plan.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Error loading plan: $error')),
        data: (plan) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 24,
          children: [
            const MealPlanHeader(),
            /*
            these don't make much sense after any modifications have been made to the days / days events
            perhaps these should become a 'wizard' to create an initial template to then modify
            or perhaps they can re-initalize/set fields across all days/events... TBDas
            */
            _buildTrainingDaysInput(context, ref, plan, notifier),
            _buildWeeklyKcalInput(context, ref, plan, notifier),
            _buildCalorieCyclingSelector(context, ref, plan, notifier),
            _buildMealsPerDayInput(context, ref, plan, notifier),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainingDaysInput(
      BuildContext context, WidgetRef ref, MealPlan plan, Mealplan notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Training Days per Week',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              plan.trainingDaysPerWeek.toString(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Slider(
              value: plan.trainingDaysPerWeek.toDouble(),
              min: 1,
              max: 6,
              divisions: 5,
              label: plan.trainingDaysPerWeek.toString(),
              onChanged: notifier.updateTrainingDaysPerWeek,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMealsPerDayInput(
      BuildContext context, WidgetRef ref, MealPlan plan, Mealplan notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Meals per Day',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              plan.mealsPerDay.toString(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Slider(
              value: 2, // plan.mealsPerDay.toDouble(),
              min: 1,
              max: 3,
              divisions: 2,
              label: plan.mealsPerDay.toString(),
              onChanged: (v) {}, //notifier.updateMealsPerDay,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeeklyKcalInput(
      BuildContext context, WidgetRef ref, MealPlan plan, Mealplan notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weekly Calories',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: plan.dayplans.isEmpty
                    ? '14000' // Default to 2000 kcal/day
                    : (plan.dayplans.fold<double>(
                              0,
                              (sum, day) => sum + day.targets.kCal,
                            ) *
                            7)
                        .round()
                        .toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter weekly calories',
                  suffixText: 'kcal/week',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) async {
                  final kcal = int.tryParse(value);
                  if (kcal != null) {
                    // TODO
                  }
                },
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildCalorieCyclingSelector(
      BuildContext context, WidgetRef ref, MealPlan plan, Mealplan notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Calorie Cycling',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        SegmentedButton<CalorieCyclingType>(
          segments: const [
            ButtonSegment(
              value: CalorieCyclingType.off,
              label: Text('Off'),
            ),
            ButtonSegment(
              value: CalorieCyclingType.on,
              label: Text('On'),
            ),
            ButtonSegment(
              value: CalorieCyclingType.psmf,
              label: Text('PSMF Days'),
            ),
          ],
          selected: {plan.calorieCycling},
          onSelectionChanged: (Set<CalorieCyclingType> selected) async {
            // TODO
          },
        ),
      ],
    );
  }
}
