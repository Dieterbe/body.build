import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bodybuild/data/programmer/setup.dart';
import 'package:bodybuild/ui/core/info_button.dart';
import 'package:bodybuild/ui/programmer/widget/label_bar.dart';
import 'package:bodybuild/ui/programmer/widget/widgets.dart';

const String helpSetsPerWeekPerMuscleGroup = '''
Based on Menno's calculator.

Does not consider age, menopause, hormone replacement, diet, rest intervals, genetics, intensiveness, AAS/PED (indirectly via energy balance), etc.
Adjust as needed.

Practical tips:
* less volume for elderly TODO confirm
* more volume in follicular phase, and less in luteal phase. e.g. +- 33%
''';

class ProgrammerSetupParams extends ConsumerWidget {
  const ProgrammerSetupParams({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setup = ref.watch(setupProvider);

    return setup.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (setup) => Column(
        children: [
          const LabelBar('Resulting parameters'),
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            titleText('Intensity', context),
            const SizedBox(width: 25),
            Text(setup.paramSuggest.intensities
                .map((i) => i.toString())
                .join(',')),
          ]),
          const SizedBox(height: 20),
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            titleText('Sets Per week per muscle group', context),
            const SizedBox(width: 25),
            Text(setup.paramSuggest.setsPerweekPerMuscleGroup
                .toStringAsFixed(0)),
            const SizedBox(width: 12),
            const InfoButton(
                title: 'Sets per week per muscle group',
                child: MarkdownBody(data: helpSetsPerWeekPerMuscleGroup)),
          ]),
        ],
      ),
    );
  }
}
