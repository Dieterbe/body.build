import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptc/ui/programmer/widget/label_bar.dart';
import 'package:ptc/ui/programmer/widget/widgets.dart';
import 'package:ptc/util/formulas.dart';

import '../../../data/programmer/setup.dart';

class ProgrammerSetupParamOverrides extends ConsumerWidget {
  ProgrammerSetupParamOverrides({super.key});
  // keys for TextFormField's that don't use Form. see TextFormField docs
  final keyIntensities = GlobalKey<FormFieldState>();
  final keyWeeklyVolume = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setup = ref.watch(setupProvider);
    final notifier = ref.read(setupProvider.notifier);
    final bmi = calcBMI(setup.weight, setup.length);
    return Column(
      children: [
        const LabelBar('Overrides'),
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
          SizedBox(
            width: 100,
            child: TextFormField(
              key: keyIntensities,
              initialValue: (setup.paramOverrides.intensities == null)
                  ? ''
                  : setup.paramOverrides.intensities!
                      .map((i) => i.toString())
                      .join(','),
              keyboardType: TextInputType.number,
              autovalidateMode: AutovalidateMode.always,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              validator: notifier.intensitiesValidator,
              onChanged: notifier.setIntensitiesMaybe,
            ),
          ),
        ]),
        const SizedBox(height: 20),
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          titleText('Sets per week per muscle group', context),
          const SizedBox(width: 25),
          SizedBox(
            width: 100,
            child: TextFormField(
              key: keyWeeklyVolume,
              initialValue:
                  setup.paramOverrides.setsPerweekPerMuscleGroup?.toString() ??
                      '',
              keyboardType: TextInputType.number,
              autovalidateMode: AutovalidateMode.always,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              validator: notifier.setsPerWeekPerMuscleGroupValidator,
              onChanged: notifier.setSetsPerWeekPerMuscleGroupMaybe,
            ),
          ),
        ]),
      ],
    );
  }
}
