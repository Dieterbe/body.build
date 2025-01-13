import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bodybuild/data/mealplan/mealplan.dart';
import 'package:bodybuild/data/programmer/program.dart';
import 'package:bodybuild/data/programmer/setup.dart';
import 'package:bodybuild/model/mealplanner/meal_plan.dart';
import 'package:bodybuild/model/programmer/settings.dart';
import 'package:bodybuild/model/programmer/workout.dart';
import 'package:bodybuild/ui/core/widget/editable_header.dart';

class DayColumn extends ConsumerWidget {
  final MealPlan plan;
  final DayPlan day;

  const DayColumn({
    super.key,
    required this.plan,
    required this.day,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(mealplanProvider.notifier);
    final setup = ref.watch(setupProvider);

    return setup.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) =>
          Center(child: Text('Error loading settings: $error')),
      data: (setup) => _build(context, ref, notifier, setup),
    );
  }

  Widget _build(
      BuildContext context, WidgetRef ref, Mealplan notifier, Settings setup) {
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
                if (newDesc.isNotEmpty) {
                  notifier.updateDay(day, day.copyWith(desc: newDesc));
                }
              },
              onDelete: () {
                notifier.deleteDay(day);
              },
              n: day.num,
              onNumChanged: (newNumber) {
                notifier.updateDay(day, day.copyWith(num: newNumber));
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
                  if (day.events.isEmpty)
                    const Center(
                      child: Text('No events yet'),
                    )
                  else
                    ReorderableListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: day.events.length,
                      onReorder: (oldIndex, newIndex) {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        final List<Event> newEvents = List.from(day.events);
                        final Event item = newEvents.removeAt(oldIndex);
                        newEvents.insert(newIndex, item);
                        notifier.updateDay(
                            day, day.copyWith(events: newEvents));
                      },
                      itemBuilder: (context, index) {
                        final event = day.events[index];
                        return Dismissible(
                          key: ValueKey(event),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Theme.of(context).colorScheme.error,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Icon(
                              Icons.delete,
                              color: Theme.of(context).colorScheme.onError,
                            ),
                          ),
                          onDismissed: (direction) {
                            final List<Event> newEvents = List.from(day.events)
                              ..removeAt(index);
                            notifier.updateDay(
                                day, day.copyWith(events: newEvents));
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.drag_handle),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: event.when(
                                      meal: (desc, targets) => Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            desc,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall,
                                          ),
                                          Text(
                                            'Kcal: ${targets.kCal.round()}'
                                            'P: ${targets.minProtein.round()}-${targets.maxProtein.round()}g '
                                            'C: ${targets.minCarbs.round()}-${targets.maxCarbs.round()}g '
                                            'F: ${targets.minFats.round()}-${targets.maxFats.round()}g',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ],
                                      ),
                                      strengthWorkout: (desc, estimatedKcal) =>
                                          Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            desc,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                ),
                                          ),
                                          Text(
                                            'Estimated burn: ${estimatedKcal.round()} kcal',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 8),
                  Center(
                    child: IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () =>
                          _showAddEventDialog(context, ref, day, notifier),
                      tooltip: 'Add Event',
                    ),
                  ),
                ],
              ),
            ),
            // Energy balance section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Energy Balance',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Builder(
                    builder: (context) {
                      double totalKcalIn = 0;
                      double totalKcalSpentRT = 0;

                      for (final event in day.events) {
                        event.when(
                          meal: (desc, targets) {
                            totalKcalIn += targets.kCal;
                          },
                          strengthWorkout: (desc, estimatedKcal) {
                            totalKcalSpentRT += estimatedKcal;
                          },
                        );
                      }
                      final dailyEE = setup.getDailyEE(totalKcalSpentRT);

                      final balance = totalKcalIn - dailyEE;
                      final color = balance > 0
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.error;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('E expend: ${dailyEE.round()} kcal'),
                          Text('E ingest: ${totalKcalIn.round()} kcal'),
                          Text(
                            'Balance : ${balance.round()} kcal',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(color: color),
                          )
                        ],
                      );
                    },
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

  void _showAddEventDialog(
      BuildContext context, WidgetRef ref, DayPlan day, Mealplan notifier) {
    showDialog(
      context: context,
      builder: (context) {
        String eventType = 'meal'; // Default to meal
        String description = '';
        double? kcal;
        Targets? targets;
        String workoutType = 'existing'; // Default to existing workout
        Workout? selectedWorkout;

        return AlertDialog(
          title: const Text('Add Event'),
          content: StatefulBuilder(
            builder: (context, setState) {
              final programState = ref.watch(programProvider);

              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'meal', label: Text('Meal')),
                        ButtonSegment(value: 'workout', label: Text('Workout')),
                      ],
                      selected: {eventType},
                      onSelectionChanged: (Set<String> newSelection) {
                        setState(() {
                          eventType = newSelection.first;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    if (eventType == 'workout') ...[
                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(
                              value: 'existing',
                              label: Text('Existing Workout')),
                          ButtonSegment(value: 'custom', label: Text('Custom')),
                        ],
                        selected: {workoutType},
                        onSelectionChanged: (Set<String> newSelection) {
                          setState(() {
                            workoutType = newSelection.first;
                            // Reset values when switching types
                            description = '';
                            kcal = null;
                            selectedWorkout = null;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      if (workoutType == 'existing') ...[
                        programState.when(
                          data: (program) {
                            if (program.workouts.isEmpty) {
                              return const Text(
                                  'No workouts available. Create workouts in the Program Builder first.');
                            }
                            return DropdownButtonFormField<Workout>(
                              decoration: const InputDecoration(
                                labelText: 'Select Workout',
                              ),
                              value: selectedWorkout,
                              items: program.workouts.map((workout) {
                                return DropdownMenuItem(
                                  value: workout,
                                  child: Text(workout.name),
                                );
                              }).toList(),
                              onChanged: (Workout? value) async {
                                selectedWorkout = value;
                                if (value != null) {
                                  description = value.name;
                                  int totalSets = value.setGroups.fold(
                                      0,
                                      (sum, group) =>
                                          sum +
                                          group.sets.fold(0,
                                              (setSum, set) => setSum + set.n));
                                  final min = (totalSets * 2.5).round();
                                  final setup =
                                      await ref.read(setupProvider.future);
                                  final (trainingEE, adjusted) =
                                      setup.getTrainingEE(min);
                                  setState(() {
                                    kcal = trainingEE;
                                  });
                                }
                              },
                            );
                          },
                          loading: () => const CircularProgressIndicator(),
                          error: (error, stack) => Text('Error: $error'),
                        ),
                      ] else ...[
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            hintText: 'Enter workout description',
                          ),
                          onChanged: (value) => description = value,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Estimated Calories',
                            hintText: 'Enter estimated calories burned',
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) => kcal = double.tryParse(value),
                        ),
                      ],
                    ] else ...[
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          hintText: 'Enter meal description',
                        ),
                        onChanged: (value) => description = value,
                      ),
                      const SizedBox(height: 16),
                      // Meal targets input fields
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                labelText: 'Min Protein',
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                targets ??= const Targets(
                                  minProtein: 0,
                                  maxProtein: 0,
                                  minCarbs: 0,
                                  maxCarbs: 0,
                                  minFats: 0,
                                  maxFats: 0,
                                  kCal: 0,
                                );
                                targets = targets!.copyWith(
                                  minProtein: double.tryParse(value) ?? 0,
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                labelText: 'Max Protein',
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                targets ??= const Targets(
                                  minProtein: 0,
                                  maxProtein: 0,
                                  minCarbs: 0,
                                  maxCarbs: 0,
                                  minFats: 0,
                                  maxFats: 0,
                                  kCal: 0,
                                );
                                targets = targets!.copyWith(
                                  maxProtein: double.tryParse(value) ?? 0,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                labelText: 'Min Carbs',
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                targets ??= const Targets(
                                  minProtein: 0,
                                  maxProtein: 0,
                                  minCarbs: 0,
                                  maxCarbs: 0,
                                  minFats: 0,
                                  maxFats: 0,
                                  kCal: 0,
                                );
                                targets = targets!.copyWith(
                                  minCarbs: double.tryParse(value) ?? 0,
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                labelText: 'Max Carbs',
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                targets ??= const Targets(
                                  minProtein: 0,
                                  maxProtein: 0,
                                  minCarbs: 0,
                                  maxCarbs: 0,
                                  minFats: 0,
                                  maxFats: 0,
                                  kCal: 0,
                                );
                                targets = targets!.copyWith(
                                  maxCarbs: double.tryParse(value) ?? 0,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                labelText: 'Min Fats',
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                targets ??= const Targets(
                                  minProtein: 0,
                                  maxProtein: 0,
                                  minCarbs: 0,
                                  maxCarbs: 0,
                                  minFats: 0,
                                  maxFats: 0,
                                  kCal: 0,
                                );
                                targets = targets!.copyWith(
                                  minFats: double.tryParse(value) ?? 0,
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                labelText: 'Max Fats',
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                targets ??= const Targets(
                                  minProtein: 0,
                                  maxProtein: 0,
                                  minCarbs: 0,
                                  maxCarbs: 0,
                                  minFats: 0,
                                  maxFats: 0,
                                  kCal: 0,
                                );
                                targets = targets!.copyWith(
                                  maxFats: double.tryParse(value) ?? 0,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Target Calories',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          targets ??= const Targets(
                            minProtein: 0,
                            maxProtein: 0,
                            minCarbs: 0,
                            maxCarbs: 0,
                            minFats: 0,
                            maxFats: 0,
                            kCal: 0,
                          );
                          targets = targets!.copyWith(
                            kCal: double.tryParse(value) ?? 0,
                          );
                        },
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (description.isEmpty) {
                  return;
                }

                Event newEvent;
                if (eventType == 'meal') {
                  if (targets == null) {
                    return;
                  }
                  newEvent = Event.meal(
                    desc: description,
                    targets: targets!,
                  );
                } else {
                  if (kcal == null) {
                    return;
                  }
                  newEvent = Event.strengthWorkout(
                    desc: description,
                    estimatedKcal: kcal!,
                  );
                }

                final updatedEvents = [...day.events, newEvent];
                notifier.updateDay(day, day.copyWith(events: updatedEvents));
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
