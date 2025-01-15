import 'package:bodybuild/ui/core/text_style.dart';
import 'package:bodybuild/ui/programmer/widget/k_string_row.dart';
import 'package:bodybuild/ui/programmer/widget/kv_row.dart';
import 'package:bodybuild/ui/programmer/widget/kv_strings_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bodybuild/model/programmer/bmr_method.dart';
import 'package:bodybuild/ui/programmer/widget/label_bar.dart';
import 'package:bodybuild/ui/programmer/widget/widgets.dart';
import 'package:bodybuild/util/formulas.dart';
import 'package:bodybuild/data/programmer/setup.dart';

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

const String helpTrainingEE = '''
Training Energy Expenditure (TEE) is the amount of energy used for weight lifting training.
It is based on:
* your training intensiveness (which we assume is high enough, therefore there is no configuration for it)
* duration of your session.
* your bodyweight

Note that it also includes the basal metabolic rate (BMR) of the body, Which can
become substantial if you are physically active, and will them automatically be adjuset for.
See "displaced EE" below.
''';

const String helpDisplacedEE = '''
The "displaced" Energy Expenditure (EE) is the amount of energy used for training that is already
included in the BMR.  If this amount is substantial, it will automatically be subtracted from the
training EE to avoid double counting. In this case, EPOC is added in.
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
      //  crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KVRow(
          Flexible(
            flex: 10,
            child: Align(
              alignment: Alignment.centerRight,
              child: Radio<bool>(
                value: true,
                groupValue: isSelected,
                onChanged: (_) => onSelect(),
              ),
            ),
          ),
          Text(
              '${value == null ? 'N/A' : value.round().toString()} (${method.displayName})',
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: MediaQuery.sizeOf(context).width / 100,
              )),
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
          final displacedEE = setup.getDisplacedEE(setup.workoutDuration);
          final (trainingEE, adjusted) =
              setup.getTrainingEE(setup.workoutDuration);

          final restingDayEE = setup.getDailyEE(0);
          final trainingDayEE = setup.getDailyEE(trainingEE);

          final averageDayEE = (restingDayEE * (7 - setup.workoutsPerWeek) +
                  trainingDayEE * setup.workoutsPerWeek) /
              7;
          final targetIntake = averageDayEE * setup.energyBalance / 100;
          final targetIntakeTraining =
              trainingDayEE * setup.energyBalance / 100;
          final targetIntakeResting = restingDayEE * setup.energyBalance / 100;
          return Column(
            children: [
              const LabelBar('Resulting Facts'),
              Row(
                children: [
                  Flexible(
                    flex: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        KVStringsRow('BMI', bmi.toStringAsFixed(2)),
                        SizedBox(height: 20),
                        KStringRow('BMR', help: helpBMR),
                        for (final (method, value, error) in bmrMethods) ...[
                          Center(
                            child: _buildBMRRow(
                              context,
                              method,
                              value,
                              setup.bmrMethod == method,
                              () => notifier.setBMRMethod(method),
                              errorMessage: error,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ],
                    ),
                  ),
                  Flexible(
                      flex: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          KVStringsRow(
                              'Training EE', trainingEE.round().toString(),
                              help: helpTrainingEE),
                          const SizedBox(height: 20),
                          KVStringsRow(
                            'Displaced EE',
                            displacedEE.round().toString() +
                                (adjusted ? ' (accounted for)' : ' (ignored)'),
                            help: helpDisplacedEE,
                          ),
                          const SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Theme.of(context)
                                    .dividerColor
                                    .withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Table(
                              defaultColumnWidth: const IntrinsicColumnWidth(),
                              border: TableBorder(
                                horizontalInside: BorderSide(
                                  color: Theme.of(context)
                                      .dividerColor
                                      .withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              children: [
                                TableRow(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceVariant
                                        .withOpacity(0.5),
                                  ),
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      alignment: Alignment.center,
                                      child: Text('Day',
                                          style: ts100(context).copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                          )),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      alignment: Alignment.center,
                                      child: Text('EE',
                                          style: ts100(context).copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                          )),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      alignment: Alignment.center,
                                      child: Text('Target kcal intake',
                                          style: ts100(context).copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                          )),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      child: Text('Resting',
                                          style: ts100(context).copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withOpacity(0.8),
                                          ),
                                          textAlign: TextAlign.left),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      alignment: Alignment.center,
                                      child: Text(
                                        restingDayEE.round().toString(),
                                        style: ts100(context),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      alignment: Alignment.center,
                                      child: Text(
                                        targetIntakeResting.round().toString(),
                                        style: ts100(context),
                                      ),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      child: Text('Training',
                                          style: ts100(context).copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withOpacity(0.8),
                                          ),
                                          textAlign: TextAlign.left),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      alignment: Alignment.center,
                                      child: Text(
                                        trainingDayEE.round().toString(),
                                        style: ts100(context),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      alignment: Alignment.center,
                                      child: Text(
                                        targetIntakeTraining.round().toString(),
                                        style: ts100(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ))
                ],
              )
            ],
          );
        });
  }
}
