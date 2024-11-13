//  const MarkdownBody(data: markdownSource),
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:ptc/programming/exercises.dart';
import 'package:ptc/ui/equip_label.dart';

const String help = '''
based on https://exrx.net/Testing/WeightLifting/StrengthStandards  
in the future, rather than having to consult exrx tables, this will be built-in.  
note: exrx category untrained and novice are combined into beginner,  
because some people may train for years and still be considered "untrained" by exrx standards  
also, all advice/calculations remain the same for both exrx untrained and novice anyway
''';

class ProgrammerConfig extends StatefulWidget {
  const ProgrammerConfig({super.key});

  @override
  State<ProgrammerConfig> createState() => _ProgrammerConfigState();
}

class _ProgrammerConfigState extends State<ProgrammerConfig> {
  String dropdownValue = 'beginner';
  List<Equipment> selectedEquipment = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          const Text('Starting trainee level'),
          DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurple,
            ),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
            items: <String>['beginner', 'intermediate', 'advanced', 'elite']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Column(
                  children: [
                    Text(value),
                    const SizedBox(height: 8),
                    Text(switch (value) {
                      'beginner' => 'bench 1RM > 0kg',
                      'intermediate' => 'bench 1RM > 90kg',
                      'advanced' => 'bench 1RM > 125kg',
                      'elite' => 'bench 1RM > 160kg',
                      _ => value,
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
                    selected: selectedEquipment.contains(equipment),
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          selectedEquipment.add(equipment);
                        } else {
                          selectedEquipment.remove(equipment);
                        }
                      });
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
