import 'package:flutter/material.dart';
import 'package:ptc/ui/programmer/widget/widgets.dart';

class Legend extends StatelessWidget {
  const Legend({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      const Spacer(),
      const Text('Legend'),
      const SizedBox(width: 30),
      const Text('0.25'),
      const SizedBox(width: 4),
      muscleMark(0.25, context),
      const SizedBox(width: 30),
      const Text('0.5'),
      const SizedBox(width: 4),
      muscleMark(0.5, context),
      const SizedBox(width: 30),
      const Text('0.75'),
      const SizedBox(width: 4),
      muscleMark(0.75, context),
      const SizedBox(width: 30),
      const Text('1.0'),
      const SizedBox(width: 4),
      muscleMark(1.0, context),
    ]);
  }
}
