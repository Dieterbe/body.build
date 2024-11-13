//  const MarkdownBody(data: markdownSource),
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptc/programming/exercises.dart';
import 'package:ptc/programming/setup.dart';
import 'package:ptc/ui/equip_label.dart';

const String help = '''
based on https://exrx.net/Testing/WeightLifting/StrengthStandards  
in the future, rather than having to consult exrx tables, this will be built-in.  
note: exrx category untrained and novice are combined into beginner,  
because some people may train for years and still be considered "untrained" by exrx standards  
also, all advice/calculations remain the same for both exrx untrained and novice anyway
''';

class ProgrammerSetup extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setup = ref.watch(setupProvider);
    return Column(
      children: [
        Row(children: [
          const Text('Trainee level'),
          DropdownButton<Level>(
            value: setup.level,
            icon: const Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurple,
            ),
            onChanged: (Level? newValue) {
              ref.read(setupProvider.notifier).setLevel(newValue!);
            },
            items: Level.values.map<DropdownMenuItem<Level>>((Level value) {
              return DropdownMenuItem<Level>(
                value: value,
                child: Column(
                  children: [
                    Text(value.name),
                    const SizedBox(height: 8),
                    Text(switch (value) {
                      Level.beginner => 'bench 1RM > 0kg',
                      Level.intermediate => 'bench 1RM > 90kg',
                      Level.advanced => 'bench 1RM > 125kg',
                      Level.elite => 'bench 1RM > 160kg',
                    }),
                  ],
                ),
              );
            }).toList(),
          ),
          SizedBox(width: 40),
          const MarkdownBody(data: help),
        ]),
        SizedBox(height: 20),
        Row(
          children: [
            const MarkdownBody(data: '''
other parameters that influence the program design will go here.  
like sex, age, body fat %, muscle memory, steroids, etc
'''),
            Expanded(child: Container()),
          ],
        ),
        Row(
          children: [
            const Text('Available Equipment'),
            Expanded(
              child: Wrap(
                spacing: 8.0,
                children: Equipment.values.map((equipment) {
                  return FilterChip(
                    label: EquipmentLabel(equipment),
                    side: const BorderSide(width: 0),
                    selected: setup.selectedEquipment.contains(equipment),
                    onSelected: (bool selected) {
                      if (selected) {
                        ref
                            .read(setupProvider.notifier)
                            .addEquipment(equipment);
                      } else {
                        ref
                            .read(setupProvider.notifier)
                            .removeEquipment(equipment);
                      }
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
