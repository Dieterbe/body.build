import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptc/data/programmer/groups.dart';
import 'package:ptc/ui/programmer/widget/label_bar.dart';
import 'package:ptc/ui/programmer/widget/widgets.dart';
import 'package:ptc/util/formulas.dart';

import '../../../data/programmer/setup.dart';

class ProgrammerSetupParamOverrides extends ConsumerWidget {
  ProgrammerSetupParamOverrides({super.key});
  // keys for TextFormField's that don't use Form. see TextFormField docs
  final keyIntensities = GlobalKey<FormFieldState>();
  final keyWeeklyVolume = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setup = ref.watch(setupProvider);
    final notifier = ref.read(setupProvider.notifier);
    final bmi = calcBMI(setup.weight, setup.length);

    // Get the list of available program groups (those not already overridden)
    final availableGroups =
        setup.paramOverrides.setsPerWeekPerMuscleGroupIndividual == null
            ? ProgramGroup.values
            : ProgramGroup.values.where((group) => !setup
                .paramOverrides.setsPerWeekPerMuscleGroupIndividual!
                .any((override) => override.group == group));

    return Column(
      children: [
        const LabelBar('Overrides'),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleTextLarge('Facts', context),
          ],
        ),
        const SizedBox(height: 20),
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          titleText('BMI', context),
          const SizedBox(width: 25),
          Text(bmi.toStringAsFixed(2)),
        ]),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleTextLarge('Parameters', context),
          ],
        ),
        const SizedBox(height: 20),
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          titleText('Intensity', context),
          const SizedBox(width: 25),
          SizedBox(
            width: 100,
            child: TextFormField(
              key: keyIntensities,
              initialValue: (setup.paramOverrides.intensities == null)
                  ? ''
                  : setup.paramOverrides.intensities!
                      .map((i) => i.toString())
                      .join(','),
              keyboardType: TextInputType.number,
              autovalidateMode: AutovalidateMode.always,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              validator: notifier.intensitiesValidator,
              onChanged: notifier.setIntensitiesMaybe,
            ),
          ),
        ]),
        const SizedBox(height: 20),
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          titleText('Sets per week per muscle group', context),
          const SizedBox(width: 25),
          SizedBox(
            width: 100,
            child: TextFormField(
              key: keyWeeklyVolume,
              initialValue:
                  setup.paramOverrides.setsPerweekPerMuscleGroup?.toString() ??
                      '',
              keyboardType: TextInputType.number,
              autovalidateMode: AutovalidateMode.always,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              validator: notifier.setsPerWeekPerMuscleGroupValidator,
              onChanged: notifier.setSetsPerWeekPerMuscleGroupMaybe,
            ),
          ),
        ]),
        const SizedBox(height: 10),
        // Muscle group overrides section
        const Text('Muscle Group specific Overrides:'),

        if (availableGroups.isNotEmpty) ...[
          const SizedBox(height: 20),
          Row(
            children: [
              const Text('Add for: '),
              DropdownButton<ProgramGroup>(
                value: null,
                hint: const Text('Select muscle group'),
                items: availableGroups
                    .map((group) => DropdownMenuItem(
                          value: group,
                          child: Text(group.name),
                        ))
                    .toList(),
                onChanged: (group) {
                  if (group != null) {
                    notifier.addMuscleGroupOverride(group);
                  }
                },
              ),
            ],
          ),
        ],
        if (setup.paramOverrides.setsPerWeekPerMuscleGroupIndividual
                ?.isNotEmpty ==
            true) ...[
          const SizedBox(height: 10),
          const SizedBox(height: 10),
          ...setup.paramOverrides.setsPerWeekPerMuscleGroupIndividual!.map(
            (override) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 140,
                    child: Text('  ${override.group.name}'),
                  ),
                  const SizedBox(width: 25),
                  SizedBox(
                    width: 100,
                    child: TextFormField(
                      initialValue: override.sets.toString(),
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.always,
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                      validator: notifier.setsPerWeekPerMuscleGroupValidator,
                      onChanged: (value) => notifier.updateMuscleGroupOverride(
                          override.group, value),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () =>
                        notifier.removeMuscleGroupOverride(override.group),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
/*
TODO: generator section with:
- exercises families to exclude to injuries also makes sense i guess
- exercises to exclude due to injuries
*/