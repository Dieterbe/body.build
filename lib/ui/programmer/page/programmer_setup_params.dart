
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptc/ui/programmer/widget/label_bar.dart';
import 'package:ptc/ui/programmer/widget/widgets.dart';
import 'package:ptc/util/formulas.dart';

import '../../../data/programmer/setup.dart';

class ProgrammerSetupParams extends ConsumerWidget {
  const ProgrammerSetupParams({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setup = ref.watch(setupProvider);
    final bmi = calcBMI(setup.weight, setup.length);
    final setsPerWeekMenno = calcOptimalSetsPerWeekPerMuscleGroupMH(
        setup.sex,
        setup.level,
        setup.recoveryFactor,
        setup.energyBalance / 100,
        setup.workoutsPerWeek * 1.0);

    return Column(
      children: [
        const LabelBar('Resulting parameters'),
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
          Text(setup.paramSuggest.intensities
              .map((i) => i.toString())
              .join(',')),
        ]),
        const SizedBox(height: 20),
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          titleText(
              'Base optimal sets per week per muscle group (Menno\'s formula)',
              context),
          const SizedBox(width: 25),
          Text(setsPerWeekMenno.toStringAsFixed(0)),
        ]),
        const Text(
            'note: does not consider age, menopause, hormone replacement, diet, genetics, intensiveness, AAS/PED (indirectly via energy balance), etc.  Adjust as needed'),
        const SizedBox(height: 20),
      ],
    );
  }
}
