import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptc/model/programmer/level.dart';
import 'package:ptc/model/programmer/sex.dart';
import 'package:ptc/model/programmer/activity_level.dart';
import 'package:ptc/ui/core/info_button.dart';
import 'package:ptc/ui/programmer/widget/label_bar.dart';
import 'package:ptc/ui/programmer/widget/widgets.dart';
import 'package:ptc/util/formulas.dart';

import '../../../data/programmer/setup.dart';

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
examples:
* 70  for cut with 30% deficit
* 100 for maintenance
* 110 for bulk with 10% surplus
''';

String helpBodyFat(double bfDeurenberg) => '''
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
For most people, this duration ends up considerably shorter than their actual workout duration.
''';

const String helpThermicEffect = '''
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

For very lean athletes, such as body builders in contest prep, a factor of 0.8 to 1 is appropriate.

Note that meal frequency is not relevant, and salt intake is insignificant.
''';

class ProgrammerSetupInputs extends ConsumerWidget {
  ProgrammerSetupInputs({super.key});
  // keys for TextFormField's that don't use Form. see TextFormField docs
  final keyAge = GlobalKey<FormFieldState>();
  final keyWeight = GlobalKey<FormFieldState>();
  final keyHeight = GlobalKey<FormFieldState>();
  final keyBodyFat = GlobalKey<FormFieldState>();
  final keyEnergyBalance = GlobalKey<FormFieldState>();
  final keyRecoveryFactor = GlobalKey<FormFieldState>();
  final keyWorkoutsPerWeek = GlobalKey<FormFieldState>();
  final _durationKey = GlobalKey<FormFieldState>();
  final keyThermicEffect = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setup = ref.watch(setupProvider);
    final notifier = ref.read(setupProvider.notifier);

    final bmi = calcBMI(setup.weight, setup.height);
    final bfDeurenberg = BfDeurenberg(bmi, setup.age, setup.sex);

    return Column(
      children: [
        const LabelBar('Personal information'),
        Row(
          children: [
            titleText('Trainee level', context),
            const SizedBox(width: 25),
            SizedBox(
              width: 200,
              child: DropdownButton<Level>(
                value: setup.level,
                isExpanded: true,
                onChanged: notifier.setLevel,
                items: Level.values.map<DropdownMenuItem<Level>>((Level value) {
                  return DropdownMenuItem<Level>(
                    value: value,
                    child: Text(value.name),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(width: 12),
            const InfoButton(
              title: 'Trainee Level',
              child: MarkdownBody(data: helpTraineeLevel),
            )
          ],
        ),
        Row(
          children: [
            titleText('Sex', context),
            const SizedBox(width: 25),
            SizedBox(
              width: 200,
              child: DropdownButton<Sex>(
                value: setup.sex,
                isExpanded: true,
                onChanged: notifier.setSex,
                items: Sex.values.map<DropdownMenuItem<Sex>>((Sex value) {
                  return DropdownMenuItem<Sex>(
                    value: value,
                    child: Text(value.name),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        Row(
          children: [
            titleText('Age', context),
            const SizedBox(width: 25),
            numInput(
              keyAge,
              'years',
              setup.age.toString(),
              validator: notifier.ageValidator,
              onChanged: notifier.setAgeMaybe,
            ),
          ],
        ),
        Row(
          children: [
            titleText('Weight', context),
            const SizedBox(width: 25),
            numInput(
              keyWeight,
              'kg',
              setup.weight.toString(),
              validator: notifier.weightValidator,
              onChanged: notifier.setWeightMaybe,
            ),
          ],
        ),
        Row(
          children: [
            titleText('Height', context),
            const SizedBox(width: 25),
            numInput(
              keyHeight,
              'cm',
              setup.height.toString(),
              validator: notifier.heightValidator,
              onChanged: notifier.setHeightMaybe,
            ),
          ],
        ),
        Row(
          children: [
            titleText('Body Fat', context),
            const SizedBox(width: 25),
            numInput(
              keyBodyFat,
              '%',
              setup.bodyFat?.toStringAsFixed(1) ?? '',
              validator: notifier.bodyFatValidator,
              onChanged: notifier.setBodyFatMaybe,
            ),
            const SizedBox(width: 12),
            InfoButton(
              title: 'Body Fat',
              child: MarkdownBody(data: helpBodyFat(bfDeurenberg)),
            )
          ],
        ),
        Row(
          children: [
            titleText('Energy balance', context),
            const SizedBox(width: 25),
            numInput(
              keyEnergyBalance,
              '%',
              setup.energyBalance.toString(),
              validator: notifier.energyBalanceValidator,
              onChanged: notifier.setEnergyBalanceMaybe,
            ),
            const SizedBox(width: 12),
            const InfoButton(
              title: 'Energy Balance %',
              child: MarkdownBody(data: helpEnergyBalance),
            ),
          ],
        ),
        Row(
          children: [
            titleText(
              'Recovery Factor',
              context,
            ),
            const SizedBox(width: 25),
            numInput(
              keyRecoveryFactor,
              '',
              setup.recoveryFactor.toStringAsFixed(1),
              validator: notifier.recoveryFactorValidator,
              onChanged: notifier.setRecoveryFactorMaybe,
            ),
            const SizedBox(width: 12),
            const InfoButton(
              title: 'Recovery Factor',
              child: MarkdownBody(data: helpRecoveryFactor),
            ),
          ],
        ),
        Row(
          children: [
            titleText('Workouts', context),
            const SizedBox(width: 25),
            numInput(
              keyWorkoutsPerWeek,
              'per week',
              setup.workoutsPerWeek.toString(),
              validator: notifier.workoutsPerWeekValidator,
              onChanged: notifier.setWorkoutsPerWeekMaybe,
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            titleText('Activity Level', context),
            const SizedBox(width: 25),
            SizedBox(
              width: 200,
              child: DropdownButton<ActivityLevel>(
                value: setup.activityLevel,
                isExpanded: true,
                onChanged: (ActivityLevel? level) {
                  if (level != null) {
                    notifier.setActivityLevel(level);
                  }
                },
                items: ActivityLevel.values
                    .map((level) => DropdownMenuItem(
                          value: level,
                          child: Text(level.displayName),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(width: 12),
            const InfoButton(
              title: 'Activity Level',
              child: MarkdownBody(data: helpActivityLevel),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            titleText('TEF', context),
            const SizedBox(width: 25),
            numInput(
              keyThermicEffect,
              '',
              setup.thermicEffect.toStringAsFixed(2),
              validator: notifier.thermicEffectValidator,
              onChanged: notifier.setThermicEffectMaybe,
            ),
            const SizedBox(width: 12),
            const InfoButton(
              title: 'Thermic Effect of Food',
              child: MarkdownBody(data: helpThermicEffect),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            titleText(
              'Workout Duration',
              context,
            ),
            const SizedBox(width: 25),
            numInput(
              _durationKey,
              'min',
              setup.workoutDuration.toString(),
              validator: notifier.workoutDurationValidator,
              onChanged: notifier.setWorkoutDurationMaybe,
            ),
            const SizedBox(width: 12),
            const InfoButton(
              title: 'Workout Duration',
              child: MarkdownBody(data: helpWorkoutDuration),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

Widget numInput(
  GlobalKey key,
  String suffix,
  String value, {
  required String? Function(String?)? validator,
  required void Function(String)? onChanged,
}) =>
    SizedBox(
      width: 200,
      child: TextFormField(
        key: key,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          suffixText: suffix,
        ),
        initialValue: value,
        autovalidateMode: AutovalidateMode.always,
        validator: validator,
        onChanged: onChanged,
      ),
    );
