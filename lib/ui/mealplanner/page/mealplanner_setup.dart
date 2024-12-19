import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/mealplanner/meal_plan_setup.dart';
import '../../../data/mealplanner/meal_plan.dart';
import '../../../data/mealplanner/meal_plan_provider.dart';
import 'package:uuid/uuid.dart';

class MealPlannerSetup extends ConsumerWidget {
  const MealPlannerSetup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setup = ref.watch(mealPlanSetupNotifierProvider);

    // Generate meal plan whenever setup changes
    ref.listen(mealPlanSetupNotifierProvider, (previous, next) {
      final plan = _generateMealPlan(next);
      ref.read(currentMealPlanProvider.notifier).setMealPlan(plan);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //    const LabelBar('Setup'),
        _buildWeeklyKcalInput(context, ref, setup),
        const SizedBox(height: 24),
        _buildCalorieCyclingSelector(context, ref, setup),
        const SizedBox(height: 24),
        _buildMealsPerDayInput(context, ref, setup),
        const SizedBox(height: 24),
        _buildEnergyBalanceInput(context, ref, setup),
        const SizedBox(height: 24),
        _buildTrainingDaysInput(context, ref, setup),
        const SizedBox(height: 32),
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
        ),
      ],
    );
  }

  MealPlan _generateMealPlan(MealPlanSetup setup) {
    final dailyKcal = setup.weeklyKcal / 7;
    final uuid = const Uuid();

    // Create daily targets
    final baseTargets = Targets(
      minProtein: (dailyKcal * 0.3 / 4).round().toDouble(), // 30% protein
      maxProtein: (dailyKcal * 0.4 / 4).round().toDouble(), // 40% protein
      minCarbs: (dailyKcal * 0.3 / 4).round().toDouble(), // 30% carbs
      maxCarbs: (dailyKcal * 0.5 / 4).round().toDouble(), // 50% carbs
      minFats: (dailyKcal * 0.2 / 9).round().toDouble(), // 20% fats
      maxFats: (dailyKcal * 0.35 / 9).round().toDouble(), // 35% fats
      kCal: dailyKcal,
    );

    // Generate day plans based on calorie cycling
    final dayPlans = _generateDayPlans(setup, baseTargets);

    return MealPlan(
      id: uuid.v4(),
      name: 'Meal Plan (${dailyKcal.round()} kcal/day)',
      dayplans: dayPlans,
    );
  }

  List<DayPlan> _generateDayPlans(MealPlanSetup setup, Targets baseTargets) {
    final days = <DayPlan>[];
    final dailyKcal = setup.weeklyKcal / 7;

    for (var i = 0; i < 7; i++) {
      final isTrainingDay = i < setup.trainingDaysPerWeek;
      final factor = isTrainingDay ? setup.energyBalanceFactor : 1.0;
      final dayKcal = dailyKcal * factor;

      // Adjust targets based on the day's calories
      final dayTargets = Targets(
        minProtein: baseTargets.minProtein * factor,
        maxProtein: baseTargets.maxProtein * factor,
        minCarbs: baseTargets.minCarbs * factor,
        maxCarbs: baseTargets.maxCarbs * factor,
        minFats: baseTargets.minFats * factor,
        maxFats: baseTargets.maxFats * factor,
        kCal: dayKcal,
      );

      days.add(DayPlan(
        desc: isTrainingDay
            ? 'Training Day ${days.where((d) => d.desc.contains('Training')).length + 1}'
            : 'Rest Day ${days.where((d) => d.desc.contains('Rest')).length + 1}',
        targets: dayTargets,
        meals: _generateMeals(setup.mealsPerDay, dayTargets),
      ));
    }

    return days;
  }

  List<Meal> _generateMeals(int mealsPerDay, Targets dayTargets) {
    final meals = <Meal>[];
    final mealKcal = dayTargets.kCal / mealsPerDay;

    for (var i = 0; i < mealsPerDay; i++) {
      final isMainMeal =
          i == 0 || i == mealsPerDay - 1 || i == (mealsPerDay / 2).floor();
      final factor = isMainMeal ? 1.2 : 0.8; // Main meals get 20% more calories
      final adjustedKcal = mealKcal * factor;

      meals.add(Meal(
        desc: isMainMeal
            ? i == 0
                ? 'Breakfast'
                : i == mealsPerDay - 1
                    ? 'Dinner'
                    : 'Lunch'
            : 'Snack ${meals.where((m) => m.desc.contains('Snack')).length + 1}',
        targets: Targets(
          minProtein: dayTargets.minProtein / mealsPerDay * factor,
          maxProtein: dayTargets.maxProtein / mealsPerDay * factor,
          minCarbs: dayTargets.minCarbs / mealsPerDay * factor,
          maxCarbs: dayTargets.maxCarbs / mealsPerDay * factor,
          minFats: dayTargets.minFats / mealsPerDay * factor,
          maxFats: dayTargets.maxFats / mealsPerDay * factor,
          kCal: adjustedKcal,
        ),
      ));
    }

    return meals;
  }

  Widget _buildWeeklyKcalInput(
      BuildContext context, WidgetRef ref, MealPlanSetup setup) {
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
                initialValue: setup.weeklyKcal.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter weekly calories',
                  suffixText: 'kcal',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  final kcal = int.tryParse(value);
                  if (kcal != null) {
                    ref
                        .read(mealPlanSetupNotifierProvider.notifier)
                        .updateWeeklyKcal(kcal);
                  }
                },
              ),
            ),
            const SizedBox(width: 16),
            Text(
              '${(setup.weeklyKcal / 7).round()} kcal/day',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCalorieCyclingSelector(
      BuildContext context, WidgetRef ref, MealPlanSetup setup) {
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
          selected: {setup.calorieCycling},
          onSelectionChanged: (Set<CalorieCyclingType> selected) {
            ref
                .read(mealPlanSetupNotifierProvider.notifier)
                .updateCalorieCycling(selected.first);
          },
        ),
      ],
    );
  }

  Widget _buildMealsPerDayInput(
      BuildContext context, WidgetRef ref, MealPlanSetup setup) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Meals per Day',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Slider(
          value: setup.mealsPerDay.toDouble(),
          min: 2,
          max: 6,
          divisions: 4,
          label: setup.mealsPerDay.toString(),
          onChanged: (value) {
            ref
                .read(mealPlanSetupNotifierProvider.notifier)
                .updateMealsPerDay(value.round());
          },
        ),
        Center(
          child: Text(
            '${setup.mealsPerDay} meals',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildEnergyBalanceInput(
      BuildContext context, WidgetRef ref, MealPlanSetup setup) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Energy Balance Factor',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Slider(
          value: setup.energyBalanceFactor,
          min: 0.5,
          max: 1.5,
          divisions: 20,
          label: setup.energyBalanceFactor.toStringAsFixed(2),
          onChanged: (value) {
            ref
                .read(mealPlanSetupNotifierProvider.notifier)
                .updateEnergyBalanceFactor(value);
          },
        ),
        Center(
          child: Text(
            '${(setup.energyBalanceFactor > 1 ? '+' : '')}${((setup.energyBalanceFactor - 1) * 100).round()}% from maintenance',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildTrainingDaysInput(
      BuildContext context, WidgetRef ref, MealPlanSetup setup) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Training Days per Week',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Slider(
          value: setup.trainingDaysPerWeek.toDouble(),
          min: 1,
          max: 6,
          divisions: 5,
          label: setup.trainingDaysPerWeek.toString(),
          onChanged: (value) {
            ref
                .read(mealPlanSetupNotifierProvider.notifier)
                .updateTrainingDays(value.round());
          },
        ),
        Center(
          child: Text(
            '${setup.trainingDaysPerWeek} days',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
