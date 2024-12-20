import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptc/model/programmer/bmr_method.dart';
import 'package:ptc/ui/programmer/widget/label_bar.dart';
import 'package:ptc/ui/programmer/widget/widgets.dart';
import 'package:ptc/util/formulas.dart';
import 'package:ptc/data/programmer/setup.dart';

const String helpBMR = '''
Three different formulas for calculating Basal Metabolic Rate (BMR):

Cunningham (1991):
Validated in a wide range of populations from untrained individuals to athletes.
Uses fat-free mass for better accuracy, but requires a good estimate of body fat percentage.
Aka Katch-McArdle formula.

Tinsley (2018):
Particularly accurate for physique athletes, high-level athletes, and bodybuilders on AAS.
Purely weight based.

Ten Haaf (2014):
Well-suited for athletes when body fat percentage is unknown. Uses weight, height, age, and sex.
''';

class ProgrammerSetupFacts extends ConsumerWidget {
  const ProgrammerSetupFacts({super.key});

  Widget _buildBMRRow(
    BuildContext context,
    BMRMethod method,
    double? value,
    bool isSelected,
    VoidCallback onSelect, {
    String? errorMessage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Radio<bool>(
              value: true,
              groupValue: isSelected,
              onChanged: (_) => onSelect(),
            ),
            Text(
                '${value == null ? 'N/A' : value.round().toString()} (${method.displayName})',
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                )),
          ],
        ),
        if (isSelected && errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: Text(
              errorMessage,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setup = ref.watch(setupProvider);
    final notifier = ref.read(setupProvider.notifier);
    final bmi = calcBMI(setup.weight, setup.height);
    final bmrCH = setup.bodyFat == null
        ? null
        : bmrCunningham(setup.weight, setup.bodyFat!);
    final bmrT = bmrTinsley(setup.weight);
    final bmrTH = bmrTenHaaf(setup.weight, setup.height, setup.age, setup.sex);

    final bmrMethods = [
      (
        BMRMethod.cunningham,
        bmrCH,
        setup.bodyFat == null ? 'Enter body fat % to use this formula' : null,
      ),
      (BMRMethod.tinsley, bmrT, null),
      (BMRMethod.tenHaaf, bmrTH, null),
    ];

    return Column(
      children: [
        const LabelBar('Resulting Facts'),
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          titleText('BMI', context),
          const SizedBox(width: 25),
          Text(bmi.toStringAsFixed(2)),
        ]),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleWidget(
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.info_outline, size: 18),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Basal Metabolic Rate (BMR)'),
                          content: Text(helpBMR),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Text('BMR', style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
              context,
            ),
            const SizedBox(width: 25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final (method, value, error) in bmrMethods) ...[
                  _buildBMRRow(
                    context,
                    method,
                    value,
                    setup.bmrMethod == method,
                    () => notifier.setBMRMethod(method),
                    errorMessage: error,
                  ),
                  const SizedBox(height: 8),
                ],
              ],
            ),
          ],
        ),
      ],
    );
  }
}
