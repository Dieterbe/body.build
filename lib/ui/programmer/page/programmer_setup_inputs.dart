import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptc/data/programmer/exercises.dart';
import 'package:ptc/ui/programmer/widget/equip_label.dart';
import 'package:ptc/ui/programmer/widget/label_bar.dart';
import 'package:ptc/ui/programmer/widget/widgets.dart';

import '../../../data/programmer/setup.dart';

const String helpTraineeLevel = '''
based on https://exrx.net/Testing/WeightLifting/StrengthStandards  
in the future, rather than having to consult exrx tables, this will be built-in.  
note: exrx category untrained and novice are combined into beginner,  
because some people may train for years and still be considered "untrained" by exrx standards  
also, all advice/calculations remain the same for both exrx untrained and novice anyway
''';

class ProgrammerSetupInputs extends ConsumerWidget {
  ProgrammerSetupInputs({super.key});
  // keys for TextFormField's that don't use Form. see TextFormField docs
  final keyAge = GlobalKey<FormFieldState>();
  final keyWeight = GlobalKey<FormFieldState>();
  final keyLength = GlobalKey<FormFieldState>();

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
            const SizedBox(width: 25),
            SizedBox(
              width: 200,
              child: DropdownButton<Level>(
                value: setup.level,
                icon: const Icon(Icons.arrow_downward),
                onChanged: notifier.setLevel,
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
            ),
            const SizedBox(width: 25),
            const MarkdownBody(data: helpTraineeLevel),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleText('Sex', context),
            const SizedBox(width: 25),
            SizedBox(
              width: 200,
              child: DropdownButton<Sex>(
                value: setup.sex,
                icon: const Icon(Icons.arrow_downward),
                onChanged: notifier.setSex,
                items: Sex.values.map<DropdownMenuItem<Sex>>((Sex value) {
                  return DropdownMenuItem<Sex>(
                    value: value,
                    child: Text(value.name),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleText('Age', context),
            const SizedBox(width: 25),
            SizedBox(
              width: 200,
              child: TextFormField(
                key: keyAge,
                initialValue: setup.age.toString(),
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.always,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                validator: notifier.ageValidator,
                onChanged: notifier.setAgeMaybe,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleText('Weight', context),
            const SizedBox(width: 25),
            SizedBox(
              width: 200,
              child: TextFormField(
                key: keyWeight,
                initialValue: setup.weight.toString(),
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.always,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                validator: notifier.weightValidator,
                onChanged: notifier.setWeightMaybe,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleText('Length', context),
            const SizedBox(width: 25),
            SizedBox(
              width: 200,
              child: TextFormField(
                key: keyLength,
                initialValue: setup.length.toString(),
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.always,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                validator: notifier.lengthValidator,
                onChanged: notifier.setLengthMaybe,
              ),
            ),
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
            titleText('Energy balance %', context),
            Text(
                '100 = maintenance\n70 for cut 30% deficit\n110 for bulk with 10% surplus')
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleText('Recovery factor', context),
            Text(
                'Recovery quality: 0.5 - 1.2\nPrimarily based on lifestyle factors such as stress level and sleep quality')
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleText('PED\'s', context),
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
