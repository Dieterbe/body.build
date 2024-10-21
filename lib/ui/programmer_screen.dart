import 'package:flutter/material.dart';

class ProgrammerScreen extends StatefulWidget {
  const ProgrammerScreen({super.key});

  static const routeName = 'programmer';

  @override
  State<ProgrammerScreen> createState() => _ProgrammerScreenState();
}

class _ProgrammerScreenState extends State<ProgrammerScreen> {
  String dropdownValue = 'beginner';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Programmer'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
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
            )
          ]),
          Text(
              'based on https://exrx.net/Testing/WeightLifting/StrengthStandards'),
          Text(
              'in the future, we will help you figure this out more elegantly rather than consulting exrx tables'),
          Text(
              'note: exrx category untrained and novice are combined into beginner, because some people may train for years and still be considered "untrained" by exrx standards'),
          Text(
              'also, all advice/calculations remain the same for both exrx untrained and novice anyway'),
        ],
      ),
    );
  }
}
