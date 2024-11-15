import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptc/ui/programmer/widget/label_bar.dart';
import 'package:ptc/ui/programmer/widget/widgets.dart';

import '../../../data/programmer/setup.dart';

class ProgrammerSetupParams extends ConsumerWidget {
  ProgrammerSetupParams({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setup = ref.watch(setupProvider);
    final bmi = setup.weight / pow(setup.length * 0.01, 2);
    return Column(
      children: [
        const LabelBar('Resulting parameters'),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleTextLarge('Facts', context),
          ],
        ),
        SizedBox(height: 20),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          titleText('BMI', context),
          const SizedBox(width: 25),
          Text(bmi.toStringAsFixed(2)),
        ]),
        SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleTextLarge('Parameters', context),
          ],
        ),
        SizedBox(height: 20),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          titleText('Intensity', context),
          const SizedBox(width: 25),
          Text(setup.paramSuggest.intensities
              .map((i) => i.toString())
              .join(',')),
        ]),
      ],
    );
  }
}
