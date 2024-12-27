import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptc/model/mealplanner/meal_plan.dart';
import 'package:ptc/ui/core/widget/editable_header.dart';
import 'package:ptc/ui/core/widget/editable_header.dart';
import 'package:uuid/uuid.dart';

class MealPlannerResults extends ConsumerWidget {
  const MealPlannerResults({super.key});

  void _updateAndSavePlan(WidgetRef ref, MealPlan updatedPlan) {
    ref.read(currentMealPlanProvider.notifier).setMealPlan(updatedPlan);
    ref.read(mealPlanPersistenceProvider.notifier).saveMealPlan(updatedPlan);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPlan = ref.watch(currentMealPlanProvider);
    if (currentPlan == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                final newDay = DayPlan(
                  desc: 'New Day',
                  targets: currentPlan.dayplans.isEmpty
                      ? Targets(
                          minProtein: 150,
                          maxProtein: 200,
                          minCarbs: 200,
                          maxCarbs: 300,
                          minFats: 50,
                          maxFats: 80,
                          kCal: 2000,
                        )
                      : currentPlan.dayplans.last.targets,
                  events: [],
                );

                final updatedPlan = currentPlan.copyWith(
                  dayplans: [...currentPlan.dayplans, newDay],
                );
                _updateAndSavePlan(ref, updatedPlan);
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
            children: [
              ...currentPlan.dayplans.asMap().entries.map(
                    (entry) => _buildDayColumn(
                        context, ref, currentPlan, entry.key, entry.value),
                  ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDayColumn(BuildContext context, WidgetRef ref, MealPlan plan,
      int index, DayPlan day) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EditableHeader(
              text: day.desc,
              hintText: 'Day name',
              onTextChanged: (newDesc) {
                if (newDesc.isEmpty) return;
                final updatedDay = day.copyWith(desc: newDesc);
                final updatedDays = List<DayPlan>.from(plan.dayplans)
                  ..[index] = updatedDay;
                final updatedPlan = plan.copyWith(dayplans: updatedDays);
                _updateAndSavePlan(ref, updatedPlan);
              },
              onDelete: () {
                final updatedDays = List<DayPlan>.from(plan.dayplans)
                  ..removeAt(index);
                final updatedPlan = plan.copyWith(dayplans: updatedDays);
                _updateAndSavePlan(ref, updatedPlan);
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMacroTargetsRow(context, day.targets),
                  const SizedBox(height: 16),
                  Text(
                    'Events',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ...day.events.map((event) => _buildEventRow(context, event)),
                  const SizedBox(height: 8),
                  Center(
                    child: IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {
                        // TODO: Show dialog to add new event
                      },
                      tooltip: 'Add Event',
                    ),
                  ),
                ],
              ),
            ),
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

  Widget _buildEventRow(BuildContext context, Event event) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: event.when(
          meal: (desc, targets) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                desc,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(
                'P: ${targets.minProtein.round()}-${targets.maxProtein.round()}g '
                'C: ${targets.minCarbs.round()}-${targets.maxCarbs.round()}g '
                'F: ${targets.minFats.round()}-${targets.maxFats.round()}g',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          strengthWorkout: (desc, estimatedKcal) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                desc,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              Text(
                'Estimated burn: ${estimatedKcal.round()} kcal',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
