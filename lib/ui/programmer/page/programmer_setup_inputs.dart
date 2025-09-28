import 'package:bodybuild/ui/core/text_style.dart';
import 'package:bodybuild/ui/programmer/widget/kv_row.dart';
import 'package:bodybuild/ui/programmer/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bodybuild/model/programmer/level.dart';
import 'package:bodybuild/model/programmer/sex.dart';
import 'package:bodybuild/model/programmer/activity_level.dart';
import 'package:bodybuild/ui/programmer/widget/label_bar.dart';
import 'package:bodybuild/ui/programmer/widget/setup_profile_header.dart';
import 'package:bodybuild/util/formulas.dart';

import '../../../data/programmer/setup.dart';
import '../../../data/programmer/current_setup_profile_provider.dart';

const String helpTraineeLevel = '''
Use the strength-based Kilgore-Rippetoe-Pendlay strength standards.  
On https://exrx.net/Testing/WeightLifting/StrengthStandards look up how you classify  
based on your age, sex, weight and performance for common exercises. 
''';
/*In the future, rather than having to consult exrx tables, this will be built-in.  
note: exrx category untrained and novice are combined into beginner,  
because some people may train for years and still be considered "untrained" by exrx standards  
also, all advice/calculations remain the same for both exrx untrained and novice anyway
*/

const String helpEnergyBalance = '''
Energy Balance describes the kcal intake (with deficit or surplus) as percentage of maintenance.

## Bulking recommendations

For lean bulking (with zero to minimal fat gain)

| Training Status | Energy Balance | Planned weekly weight gain as bodyweight % |
|----------------|----------------|----------------------|
| Beginner       | 105-115%       | 0.5 - 1              |
| Intermediate   | 102-107%       | 0.2 - 0.5            |
| Advanced       | 101-103%       | whatever you can get |

## Cutting recommendations

For fast cutting (with zero muscle loss)

| Category     | Fat % (male) | Fat % (female) | Energy Balance | Max weekly weight loss as bodyweight % |
|--------------|--------------|----------------|----------------|---------------------------------------|
| Contest prep | <8           | <14            | 92.5- 97.5     | 0.5 |
| Athletic     | 8-15         | 14-24          | 75 - 95        | 0.7 |
| Average      | 15-21        | 24-33          | 65 - 80        | 1 |
| Overweight   | 21-26        | 33-39          | 50-70          | 1.5 |
| Obese        | 26+          | 39+            | PSMF           | N.A. |
''';

String helpBodyFat(double bfDeurenberg) =>
    '''
## Men
~3% essential body fat

## Women
~12% essential body fat

## Estimate via BMI
${bfDeurenberg.toStringAsFixed(1)}  
Computed based on BMI, age, and sex, according to Deurenberg et al. (1991)  
Not accurate for trained individuals with a good amount of lean body mass.  
But useful ballpark for untrained individuals. I would not rely on this to calculate BMR, however.
''';

const String helpRecoveryFactor = '''
Recovery quality: 0.5 - 1.2  
Primarily based on lifestyle factors such as stress level and sleep quality
''';

const String helpActivityLevel = '''
Physical Activity Level (PAL) describes your daily activity level **outside of workouts**:

### Sedentary:
- Office job with standard life chores
- Mostly sitting throughout the day
- Limited physical activity outside of workouts (walking the dog, groceries, etc)

### Somewhat active:
- Part-time physical job (e.g. part time personal trainer)
- Long daily bicycle commute
- Regular standing or walking throughout the day

### Active:
- Full-time physical job (e.g. full-time personal trainer)
- On your feet most of the day
- Regular physical tasks or movement

### Very active:
- Full day of manual labor
- Constant physical activity
''';

const String helpWorkoutDuration = '''
Duration of strength training sessions.

Be conservative and use the time you could perform the workout in if pushing
through it efficiently and intensely, with shorter, cardio-conditioned rest periods.

Rule of thumb: count 2.5 minutes per work set.  
**For most people, this duration ends up considerably shorter than their actual workout duration**.
''';

const String helpTefFactor = '''
The Thermic Effect of Food (TEF) aka diet induced thermogenesis (DIT) is:  
the energy expended during metabolizing of food.  
It is a multiplier, typically between 1 and 1.25.
A higher TEF can significantly increase energy expenditure, and thereby support fat loss.

## In isolation (not very practically relevant):
- dieteray fat: 1.15 for lean, 0 for overweight.
- carbs: 1.15 for lean, less if insulin resistant, and possibly based on carb tolerance.
- protein: always around 1.20

## With real meals:
- The TEF for high-fat and low-fat meals is often similar (when calorie and protein matched)
- The amount of protein does not materially affect the TEF
- mixed meals tend to have a relatively constant TEF, higher than the sum of its parts.
- for lean individuals, the TEF of a regular mixed meal is around 1.25
- Note that MCT's and omega3's, can considerably raise the TEF of a meal, and unsaturated fats have a higher TEF than saturated fats

## Food processing
food processing causes reduction around 10% in TEF


## In practice

Assuming mixed meal compositions, TEF generally varies from 1.1 to 1.25.  
The low end is for overweight people eating an average diet.
The higher end is for lean strength trainees eating a diet from whole foods that is:
* high in protein 
* plenty of unsaturated fats or MCTs
* a high volume of food
* lots of fiber

Note that meal frequency is not relevant, and salt intake is insignificant.
''';

const String helpAtFactor = '''
Adaptive Thermogenesis (AT) represents how your metabolism adapts to your bodyfat levels.

* When lean, your body can reduce your metabolic rate.
* When overweight, your body can increase your metabolic rate.

It depends on:
* your current body fat level (not your dieting or body composition history)
* your genes.

Therefore this multiplier is applied to adjust your BMR accordingly.
The effect of current inergy intake is minor.

### Guidelines:
- 0.9 to 1.1 is typical. I.o.w. a 10% change in BMR
- For some bodybuilders, it varies between 0.8 (when very lean, e.g. contest prep) and 1.2 at the end of a long bulk.
''';

class ProgrammerSetupInputs extends ConsumerWidget {
  const ProgrammerSetupInputs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setupAsync = ref.watch(setupProvider);
    final currentProfileId = ref.watch(currentSetupProfileProvider);

    return setupAsync.when(
      data: (setup) {
        final notifier = ref.read(setupProvider.notifier);
        final bmi = calcBMI(setup.weight, setup.height);
        final bfDeur = bfDeurenberg(bmi, setup.age, setup.sex);

        return Column(
          // re-initialize all values when we switch profiles
          key: currentProfileId.maybeWhen(
            data: (profileId) => ValueKey('setup_form_$profileId'),
            orElse: () => null,
          ),
          children: [
            const Padding(padding: EdgeInsets.all(8.0), child: SetupProfileHeader()),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 10,
                  child: Column(
                    children: [
                      const LabelBar('Personal information'),
                      KVRow(
                        titleTextMedium('Sex', context),
                        v: DropdownButton<Sex>(
                          value: setup.sex,
                          isExpanded: true,
                          onChanged: notifier.setSex,
                          items: Sex.values.map<DropdownMenuItem<Sex>>((Sex value) {
                            return DropdownMenuItem<Sex>(
                              value: value,
                              child: Text(value.name, style: ts100(context)),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      KVRow(
                        titleTextMedium('Age', context),
                        v: numInput(
                          const ValueKey('age'),
                          'years',
                          setup.age.toString(),
                          context,
                          validator: notifier.ageValidator,
                          onChanged: notifier.setAgeMaybe,
                        ),
                      ),
                      const SizedBox(height: 12),
                      KVRow(
                        titleTextMedium('Weight', context),
                        v: numInput(
                          const ValueKey('weight'),
                          'kg',
                          setup.weight.toString(),
                          context,
                          validator: notifier.weightValidator,
                          onChanged: notifier.setWeightMaybe,
                        ),
                      ),
                      const SizedBox(height: 12),
                      KVRow(
                        titleTextMedium('Height', context),
                        v: numInput(
                          const ValueKey('height'),
                          'cm',
                          setup.height.toString(),
                          context,
                          validator: notifier.heightValidator,
                          onChanged: notifier.setHeightMaybe,
                        ),
                      ),
                      const SizedBox(height: 12),
                      KVRow(
                        titleTextMedium('Body Fat', context),
                        v: numInput(
                          const ValueKey('bodyFat'),
                          '%',
                          setup.bodyFat?.toStringAsFixed(1) ?? '',
                          context,
                          validator: notifier.bodyFatValidator,
                          onChanged: notifier.setBodyFatMaybe,
                        ),
                        help: helpBodyFat(bfDeur),
                        helpTitle: 'Body Fat',
                      ),
                      const SizedBox(height: 12),
                      KVRow(
                        titleTextMedium('Activity Level', context),
                        v: DropdownButton<ActivityLevel>(
                          value: setup.activityLevel,
                          isExpanded: true,
                          onChanged: (ActivityLevel? level) {
                            if (level != null) {
                              notifier.setActivityLevel(level);
                            }
                          },
                          items: ActivityLevel.values
                              .map(
                                (level) => DropdownMenuItem(
                                  value: level,
                                  child: Text(level.displayName, style: ts100(context)),
                                ),
                              )
                              .toList(),
                        ),
                        help: helpActivityLevel,
                        helpTitle: 'Activity Level',
                      ),
                      const SizedBox(height: 12),
                      KVRow(
                        titleTextMedium('Recovery Factor', context),
                        v: numInput(
                          const ValueKey('recoveryFactor'),
                          '',
                          setup.recoveryFactor.toStringAsFixed(1),
                          context,
                          validator: notifier.recoveryFactorValidator,
                          onChanged: notifier.setRecoveryFactorMaybe,
                        ),
                        help: helpRecoveryFactor,
                        helpTitle: 'Recovery Factor',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Column(
                    children: [
                      const LabelBar('Training & Nutrition'),
                      KVRow(
                        titleTextMedium('Trainee level', context),
                        v: DropdownButton<Level>(
                          value: setup.level,
                          isExpanded: true,
                          onChanged: notifier.setLevel,
                          items: Level.values.map<DropdownMenuItem<Level>>((Level value) {
                            return DropdownMenuItem<Level>(
                              value: value,
                              child: Text(value.name, style: ts100(context)),
                            );
                          }).toList(),
                        ),
                        help: helpTraineeLevel,
                        helpTitle: 'Trainee level',
                      ),
                      const SizedBox(height: 12),
                      KVRow(
                        titleTextMedium('Workouts', context),
                        v: numInput(
                          const ValueKey('workoutsPerWeek'),
                          'per week',
                          setup.workoutsPerWeek.toString(),
                          context,
                          validator: notifier.workoutsPerWeekValidator,
                          onChanged: notifier.setWorkoutsPerWeekMaybe,
                        ),
                      ),
                      const SizedBox(height: 12),
                      KVRow(
                        titleTextMedium('Normalized\nWorkout Duration', context),
                        v: numInput(
                          const ValueKey('workoutDuration'),
                          'min',
                          setup.workoutDuration.toString(),
                          context,
                          validator: notifier.workoutDurationValidator,
                          onChanged: notifier.setWorkoutDurationMaybe,
                        ),
                        help: helpWorkoutDuration,
                        helpTitle: 'Normalized Workout Duration',
                      ),
                      const SizedBox(height: 12),
                      KVRow(
                        titleTextMedium('Energy balance', context),
                        v: numInput(
                          const ValueKey('energyBalance'),
                          '%',
                          setup.energyBalance.toString(),
                          context,
                          validator: notifier.energyBalanceValidator,
                          onChanged: notifier.setEnergyBalanceMaybe,
                        ),
                        help: helpEnergyBalance,
                        helpTitle: 'Energy balance',
                      ),
                      const SizedBox(height: 12),
                      KVRow(
                        titleTextMedium('TEF multiplier', context),
                        v: numInput(
                          const ValueKey('tefFactor'),
                          '',
                          setup.tefFactor.toStringAsFixed(2),
                          context,
                          validator: notifier.tefFactorValidator,
                          onChanged: notifier.setTefFactorMaybe,
                        ),
                        help: helpTefFactor,
                        helpTitle: 'TEF multiplier',
                      ),
                      const SizedBox(height: 12),
                      KVRow(
                        titleTextMedium('AT multiplier', context),
                        v: numInput(
                          const ValueKey('atFactor'),
                          '',
                          setup.atFactor.toStringAsFixed(2),
                          context,
                          validator: notifier.atFactorValidator,
                          onChanged: notifier.setAtFactorMaybe,
                        ),
                        help: helpAtFactor,
                        helpTitle: 'AT multiplier',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
      error: (error, _) => Text('Error: $error'),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

Widget numInput(
  Key key,
  String suffix,
  String value,
  BuildContext context, {
  required String? Function(String?)? validator,
  required void Function(String)? onChanged,
}) => TextFormField(
  style: ts100(context),
  key: key,
  keyboardType: TextInputType.number,
  decoration: InputDecoration(
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    suffixText: suffix,
  ),
  initialValue: value,
  autovalidateMode: AutovalidateMode.always,
  validator: validator,
  onChanged: onChanged,
);
