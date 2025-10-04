import 'package:bodybuild/util/iterable_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bodybuild/data/programmer/equipment.dart';
import 'package:bodybuild/data/programmer/setup.dart';
import 'package:bodybuild/ui/programmer/widget/equip_label.dart';
import 'package:bodybuild/ui/programmer/widget/label_bar.dart';

class ProgrammerSetupFilters extends ConsumerWidget {
  const ProgrammerSetupFilters({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setup = ref.watch(setupProvider);
    final notifier = ref.read(setupProvider.notifier);

    return setup.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (setup) => Column(
        children: [
          Row(
            children: [
              Flexible(
                flex: 28,
                child: LabelBar(
                  'Available equipment',
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () => notifier.setEquipment({}),
                      child: const Text('None'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        notifier.setEquipment({
                          Equipment.barbell,
                          Equipment.dumbbell,
                          Equipment.cableTower,
                          Equipment.smithMachineAngled,
                          Equipment.cableTowerDual,
                          Equipment.latPullDownMachine,
                          Equipment.squatRack,
                          Equipment.legExtensionMachine,
                        });
                      },
                      child: const Text('Basic Gym'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        notifier.setEquipment(Equipment.values.toSet());
                      },
                      child: const Text('All'),
                    ),
                  ].insertBetween(const SizedBox(width: 8)).toList(),
                ),
              ),
              // const Flexible(flex: 10, child: LabelBar('Exercise exclusion')),
            ],
          ),
          Row(
            children: [
              Flexible(
                flex: 28,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final category in EquipmentCategory.values) ...[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.displayName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: MediaQuery.sizeOf(context).width / 100,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...Equipment.values
                                .where((equipment) => equipment.category == category)
                                .map((equipment) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Checkbox(
                                        value: setup.availEquipment.contains(equipment),
                                        onChanged: (selected) {
                                          if (selected == true) {
                                            notifier.addEquipment(equipment);
                                            return;
                                          }
                                          notifier.removeEquipment(equipment);
                                        },
                                      ),
                                      EquipmentLabel(equipment),
                                    ],
                                  );
                                }),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              /*
              "exclusion" is a weird word.
              nobody knows what an "exercise base" is
              the design is a bit weird with the widgets floating in either
              + bug that text is not removed after submitting
              + hint text too long
              + exercises not ordered well - i think - and needed uppercasing
              this is only used for auto-generating really, so better just hide this for now
              Flexible(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    // Individual Exercises Section
                    const Text('Individual Exercises:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: 300,
                      child: Autocomplete<Ex>(
                        displayStringForOption: (e) => e.id,
                        optionsBuilder: (textEditingValue) {
                          return setup.availableExercises
                              .where((e) => e.id.toLowerCase().contains(
                                  textEditingValue.text.toLowerCase()))
                              .toList();
                        },
                        onSelected: (Ex exercise) {
                          notifier.addExcludedExercise(exercise);
                        },
                        fieldViewBuilder:
                            (context, controller, focusNode, onFieldSubmitted) {
                          return TextFormField(
                            controller: controller,
                            focusNode: focusNode,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText:
                                  'Search for specific exercises to exclude',
                            ),
                          );
                        },
                      ),
                    ),
                    if (setup.paramOverrides.excludedExercises?.isNotEmpty ==
                        true) ...[
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: setup.paramOverrides.excludedExercises!
                            .map((exercise) => Chip(
                                  label: Text(exercise.id),
                                  onDeleted: () =>
                                      notifier.removeExcludedExercise(exercise),
                                ))
                            .toList(),
                      ),
                    ],
                    const SizedBox(height: 20),
                    // Base Exercises Section
                    const Text('Base Exercise Types:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: 300,
                      child: Autocomplete<EBase>(
                        displayStringForOption: (base) => base.name,
                        optionsBuilder: (textEditingValue) {
                          return EBase.values
                              .where((base) =>
                                  setup.paramOverrides.excludedBases
                                      ?.contains(base) !=
                                  true)
                              .where((base) => base.name.toLowerCase().contains(
                                  textEditingValue.text.toLowerCase()))
                              .toList();
                        },
                        onSelected: (EBase base) {
                          notifier.addExcludedBase(base);
                        },
                        fieldViewBuilder:
                            (context, controller, focusNode, onFieldSubmitted) {
                          return TextFormField(
                            controller: controller,
                            focusNode: focusNode,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Search for base exercises to exclude',
                            ),
                          );
                        },
                      ),
                    ),
                    if (setup.paramOverrides.excludedBases?.isNotEmpty ==
                        true) ...[
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: setup.paramOverrides.excludedBases!
                            .map((base) => Chip(
                                  label: Text(base.name),
                                  onDeleted: () =>
                                      notifier.removeExcludedBase(base),
                                ))
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
              */
            ],
          ),
        ],
      ),
    );
  }
}
