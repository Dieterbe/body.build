import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptc/ui/mealplanner/widget/meal_plan_header.dart';
import '../../../model/mealplanner/meal_plan.dart';
import 'package:uuid/uuid.dart';

class MealPlannerSetup extends ConsumerWidget {
  const MealPlannerSetup({super.key});

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
      spacing: 24,
      children: [
        const MealPlanHeader(),
        _buildWeeklyKcalInput(context, ref, setup),
        _buildCalorieCyclingSelector(context, ref, setup),
        _buildMealsPerDayInput(context, ref, setup),
        _buildEnergyBalanceInput(context, ref, setup),
        _buildTrainingDaysInput(context, ref, setup),
      ],
    );
  }

  MealPlan _generateMealPlan(MealPlanSetup setup) {
    final dailyKcal = setup.weeklyKcal / 7;
    const uuid = Uuid();

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
        events: _generateEvents(setup.mealsPerDay, dayTargets, isTrainingDay),
      ));
    }

    return days;
  }

  List<Event> _generateEvents(
      int mealsPerDay, Targets dayTargets, bool isTrainingDay) {
    final events = <Event>[];
    double remainingKcal = dayTargets.kCal;

    // If it's a training day, add a workout event first
    if (isTrainingDay) {
      const workoutKcal = 300.0; // Estimated calorie burn for strength training
      events.add(Event.strengthWorkout(
        desc: 'Strength Training',
        estimatedKcal: workoutKcal,
      ));
      // Add these calories back to account for the workout
      remainingKcal += workoutKcal;
    }

    // Calculate calories per meal after accounting for workout
    final mealKcal = remainingKcal / mealsPerDay;

    for (var i = 0; i < mealsPerDay; i++) {
      final isMainMeal =
          i == 0 || i == mealsPerDay - 1 || i == (mealsPerDay / 2).floor();
      final factor = isMainMeal ? 1.2 : 0.8; // Main meals get 20% more calories
      final adjustedKcal = mealKcal * factor;

      // Calculate macro targets for this meal
      final mealTargets = Targets(
        minProtein: (dayTargets.minProtein * factor) / mealsPerDay,
        maxProtein: (dayTargets.maxProtein * factor) / mealsPerDay,
        minCarbs: (dayTargets.minCarbs * factor) / mealsPerDay,
        maxCarbs: (dayTargets.maxCarbs * factor) / mealsPerDay,
        minFats: (dayTargets.minFats * factor) / mealsPerDay,
        maxFats: (dayTargets.maxFats * factor) / mealsPerDay,
        kCal: adjustedKcal,
      );

      events.add(Event.meal(
        desc: 'Meal ${i + 1}',
        targets: mealTargets,
      ));
    }

    return events;
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
                  suffixText: 'kcal/week',
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
