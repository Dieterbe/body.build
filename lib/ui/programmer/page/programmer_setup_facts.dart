import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptc/model/programmer/activity_level.dart';
import 'package:ptc/model/programmer/bmr_method.dart';
import 'package:ptc/ui/core/info_button.dart';
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

    return setup.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (setup) {
          final bmi = calcBMI(setup.weight, setup.height);

          final bmrCH = setup.bodyFat == null
              ? null
              : bmrCunningham(setup.weight, setup.bodyFat!);
          final bmrT = bmrTinsley(setup.weight);
          final bmrTH =
              bmrTenHaaf(setup.weight, setup.height, setup.age, setup.sex);

          final bmrMethods = [
            (
              BMRMethod.cunningham,
              bmrCH,
              setup.bodyFat == null
                  ? 'Enter body fat % to use this formula'
                  : null,
            ),
            (BMRMethod.tinsley, bmrT, null),
            (BMRMethod.tenHaaf, bmrTH, null),
          ];

// for most people, not counting the EPOC is okay because we count the basal expenditure
// during workouts twice.  However for highly physically active people,
// the displaced resting EE is rather significant, so account for it.
          final displacedEE =
              (setup.getBMR() * setup.getPAL() * setup.atFactor) /
                  (24 * 60) *
                  setup.workoutDuration;
          const epoc = 50; // roughly true for most workouts
          final baseRT = 0.1 * setup.weight * setup.workoutDuration;
          final (trainingEE, adjusted) =
              (setup.activityLevel == ActivityLevel.veryActive)
                  ? (baseRT - displacedEE + epoc, true)
                  : (baseRT, false);
          print(
              'RT EE $baseRT adjusted $adjusted (displaced $displacedEE epoc $epoc)');
          final restingDayEE = setup.getBMR() *
              setup.getPAL() *
              setup.tefFactor *
              setup.atFactor;
          final trainingDayEE = (setup.getBMR() * setup.getPAL() + trainingEE) *
              setup.tefFactor *
              setup.atFactor;

          final averageDayEE = (restingDayEE * (7 - setup.workoutsPerWeek) +
                  trainingDayEE * setup.workoutsPerWeek) /
              7;
          final targetIntake = averageDayEE * setup.energyBalance / 100;
          return Column(
            children: [
              const LabelBar('Resulting Facts'),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
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
                                const InfoButton(
                                  title: 'Basal Metabolic Rate (BMR)',
                                  child: Text(helpBMR),
                                ),
                                Text('BMR',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                              ],
                            ),
                            context,
                          ),
                          const SizedBox(width: 25),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (final (method, value, error)
                                  in bmrMethods) ...[
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
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        titleText('Training EE', context),
                        const SizedBox(width: 25),
                        Text(trainingEE.round().toString()),
                      ]),
                      const SizedBox(height: 20),
                      Row(children: [
                        titleText('Displaced EE', context),
                        const SizedBox(width: 25),
                        Text(displacedEE.round().toString()),
                        const SizedBox(width: 25),
                        Text(adjusted ? '(accounted for)' : '(ignored)'),
                      ]),
                      const SizedBox(height: 20),
                      Row(children: [
                        titleText('Resting Day EE', context),
                        const SizedBox(width: 25),
                        Text(restingDayEE.round().toString()),
                      ]),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          titleText('Training Day EE', context),
                          const SizedBox(width: 25),
                          Text(trainingDayEE.round().toString()),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          titleText('Average Day EE', context),
                          const SizedBox(width: 25),
                          Text(averageDayEE.round().toString()),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          titleText('Target Intake', context),
                          const SizedBox(width: 25),
                          Text(targetIntake.round().toString()),
                        ],
                      ),
                    ],
                  )
                ],
              )
            ],
          );
        });
  }
}
