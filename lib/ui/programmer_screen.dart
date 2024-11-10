import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ptc/programming/groups.dart';
import 'package:ptc/ui/muscles_screen.dart';
import 'package:ptc/util.dart';

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('exercise'),
                Expanded(child: Container()),
                Container(
                  child: headers(),
                ),
              ],
            ),
            // eventually we will show relevant exercises (e.g. part of a program)
            // for now, let's just show our volume assignment rules
            ...volumeAssignments.map((e) => Row(children: [
                  Text(e.match),
                  Expanded(child: Container()),
                  ...ProgramGroup.values
                      .map((g) => muscleMark(e.assign[g] ?? 0.0, context)),
                ])),
            const Divider(),
            // show a nice legend that displays what the muscle marks for 0.25, 0.5, 0.75 and 1.0 look like
            Row(children: [
              const Spacer(),
              Text('Legend'),
              SizedBox(width: 30),
              Text('0.25'),
              SizedBox(width: 4),
              muscleMark(0.25, context),
              SizedBox(width: 30),
              Text('0.5'),
              SizedBox(width: 4),
              muscleMark(0.5, context),
              SizedBox(width: 30),
              Text('0.75'),
              SizedBox(width: 4),
              muscleMark(0.75, context),
              SizedBox(width: 30),
              Text('1.0'),
              SizedBox(width: 4),
              muscleMark(1.0, context),
            ]),
          ]),
        ),
      ),
    );
  }
}

Widget rotatedText(String text) {
  return FittedBox(
    fit: BoxFit.cover,
    child: Transform.rotate(
      angle: 45 / 180 * 3.14,
      child: Text(text),
    ),
  );
}

Widget muscleMark(double recruitment, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(2.0),
    child: Container(
      width: 26,
      height: 26,
      color: Theme.of(context).colorScheme.primary.withOpacity(recruitment),
    ),
  );
}

Widget headers() {
  // when column headers are horizontal, they take too much space
  // when they are vertical, you have to twist your neck to read them
  // so we want 45 degree rotation to make them more compact horizontally, but still readable.
  // However:
  // * RotationTransition(turns: AlwaysStoppedAnimation(7/8)) and Transform.rotate keep the original width (making the rotation pointless)
  // * RotatedBox uses width/height afer rotation, during layout - perfect for what we need - but only supports 90degree rotations, not 45.
  // * OverflowBox(Transform.rotate) results in errors
  // So the solution is to first vertically rotate the with RotatedBox, so the layout engine uses the constraints of tall&narrow text boxes,
  // and after layouting, turn it by 45 degrees to make it more legible
//
// hack: create a stack of (invisible) text boxes on top of each other
// the resulting widget will have the width of whichever is the longest of the text boxes
// therefore, by stacking each entry on top of this stack, they all have the same length
// and therefore, consistent rotation origins
  final all = ProgramGroup.values
      .map((e) => Opacity(
            opacity: 0,
            child: Text(
              e.name.camelToSpace(),
            ),
          ))
      .toList();
  return Transform.translate(
    offset: const Offset(
        0, -10), // because we pivot around bottom center, raise text up a bit
    child: Row(
        children: ProgramGroup.values
            .map((e) => Transform.rotate(
                alignment: Alignment.bottomCenter,
                angle: pi / 4,
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Container(
                    // color: Colors.yellow,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Stack(children: [
                        SizedBox(
                            height: 26, child: Text(e.name.camelToSpace())),
                        ...all
                      ]),
                    ),
                  ),
                )))
            .toList()),
  );
}

/*
volume distribution?
menno says: equal for all muscles
Jeff nippard says back quads glutes can handle more volume. https://youtu.be/ekQxEEjYLDI?si=KtMthjzxUAl4Md50 5:13
*/