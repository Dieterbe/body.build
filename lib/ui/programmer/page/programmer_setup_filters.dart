import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptc/data/programmer/equipment.dart';
import 'package:ptc/data/programmer/exercise_base.dart';
import 'package:ptc/data/programmer/exercises.dart';
import 'package:ptc/data/programmer/setup.dart';
import 'package:ptc/ui/programmer/widget/equip_label.dart';
import 'package:ptc/ui/programmer/widget/label_bar.dart';
import 'package:ptc/ui/programmer/widget/widgets.dart';
import 'package:ptc/util.dart';

class ProgrammerSetupFilters extends ConsumerWidget {
  const ProgrammerSetupFilters({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setup = ref.watch(setupProvider);
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              flex: 2,
              child: LabelBar(
                'Available equipment',
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () =>
                        ref.read(setupProvider.notifier).setEquipment({}),
                    child: const Text('None'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final notifier = ref.read(setupProvider.notifier);
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
                      final notifier = ref.read(setupProvider.notifier);
                      notifier.setEquipment(Equipment.values.toSet());
                    },
                    child: const Text('All'),
                  ),
                ].insertBetween(const SizedBox(width: 8)).toList(),
              ),
            ),
            const Flexible(flex: 1, child: LabelBar('Exercise exclusion')),
          ],
        ),
        Row(
          children: [
            Flexible(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final category in EquipmentCategory.values) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.displayName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ...Equipment.values
                            .where(
                                (equipment) => equipment.category == category)
                            .map((equipment) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              titleWidget(EquipmentLabel(equipment), context),
                              Checkbox(
                                value: setup.availEquipment.contains(equipment),
                                onChanged: (selected) {
                                  if (selected == true) {
                                    return ref
                                        .read(setupProvider.notifier)
                                        .addEquipment(equipment);
                                  }
                                  ref
                                      .read(setupProvider.notifier)
                                      .removeEquipment(equipment);
                                },
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Flexible(
              flex: 1,
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
                            .where((e) => e.id
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase()))
                            .toList();
                      },
                      onSelected: (Ex exercise) {
                        ref
                            .read(setupProvider.notifier)
                            .addExcludedExercise(exercise);
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
                                onDeleted: () => ref
                                    .read(setupProvider.notifier)
                                    .removeExcludedExercise(exercise),
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
                            .where((base) => base.name
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase()))
                            .toList();
                      },
                      onSelected: (EBase base) {
                        ref.read(setupProvider.notifier).addExcludedBase(base);
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
                                onDeleted: () => ref
                                    .read(setupProvider.notifier)
                                    .removeExcludedBase(base),
                              ))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
