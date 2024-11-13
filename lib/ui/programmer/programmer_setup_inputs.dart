import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptc/programming/exercises.dart';
import 'package:ptc/ui/programmer/equip_label.dart';
import 'package:ptc/ui/programmer/label_bar.dart';
import 'package:ptc/ui/programmer/widgets.dart';

import '../../programming/setup.dart';

const String helpTraineeLevel = '''
based on https://exrx.net/Testing/WeightLifting/StrengthStandards  
in the future, rather than having to consult exrx tables, this will be built-in.  
note: exrx category untrained and novice are combined into beginner,  
because some people may train for years and still be considered "untrained" by exrx standards  
also, all advice/calculations remain the same for both exrx untrained and novice anyway
''';

class ProgrammerSetupInputs extends ConsumerWidget {
  const ProgrammerSetupInputs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setup = ref.watch(setupProvider);
    final notifier = ref.read(setupProvider.notifier);
    return Column(
      children: [
        const LabelBar('Personal information'),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleText('Trainee level', context),
            DropdownButton<Level>(
              value: setup.level,
              icon: const Icon(Icons.arrow_downward),
              iconSize: 16,
              elevation: 16,
              onChanged: (Level? newValue) {
                notifier.setLevel(newValue!);
              },
              items: Level.values.map<DropdownMenuItem<Level>>((Level value) {
                return DropdownMenuItem<Level>(
                  value: value,
                  child: Column(
                    children: [
                      Text(value.name),
                      const SizedBox(height: 4),
                      Text(
                        switch (value) {
                          Level.beginner => 'bench 1RM > 0kg',
                          Level.intermediate => 'bench 1RM > 90kg',
                          Level.advanced => 'bench 1RM > 125kg',
                          Level.elite => 'bench 1RM > 160kg',
                        },
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(width: 40),
            const MarkdownBody(data: helpTraineeLevel),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleText('Sex', context),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleText('Age', context),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleText('Weight', context),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleText('Length', context),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleText('Body fat %', context),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleText('Cut or bulk?', context),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleText('Steroids', context),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleText('Muscle memory', context),
          ],
        ),
        const SizedBox(height: 20),
        const LabelBar('Available equipment'),
        Row(
          children: [
            Expanded(
              child: Wrap(
                spacing: 8.0,
                children: Equipment.values.map((equipment) {
                  return Row(children: [
                    titleWidget(EquipmentLabel(equipment), context),
                    Checkbox(
                      value: setup.selectedEquipment.contains(equipment),
                      onChanged: (selected) {
                        if (selected == true) {
                          ref
                              .read(setupProvider.notifier)
                              .addEquipment(equipment);
                        } else {
                          ref
                              .read(setupProvider.notifier)
                              .removeEquipment(equipment);
                        }
                      },
                    ),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
