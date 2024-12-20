import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptc/ui/programmer/widget/label_bar.dart';
import 'package:ptc/ui/programmer/widget/widgets.dart';
import 'package:ptc/util/formulas.dart';

import '../../../data/programmer/setup.dart';

class ProgrammerSetupFacts extends ConsumerWidget {
  const ProgrammerSetupFacts({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setup = ref.watch(setupProvider);
    final bmi = calcBMI(setup.weight, setup.height);

    return Column(
      children: [
        const LabelBar('Resulting Facts'),
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          titleText('BMI', context),
          const SizedBox(width: 25),
          Text(bmi.toStringAsFixed(2)),
        ]),
      ],
    );
  }
}
