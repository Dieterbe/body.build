import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptc/model/programmer/level.dart';
import 'package:ptc/model/programmer/sex.dart';
import 'package:ptc/model/programmer/activity_level.dart';
import 'package:ptc/ui/programmer/widget/label_bar.dart';
import 'package:ptc/ui/programmer/widget/widgets.dart';

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

const String helpBodyFat = '''
 men:   ~3% essential body fat  
 women: ~12% essential body fat
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setup = ref.watch(setupProvider);
    final notifier = ref.read(setupProvider.notifier);

    return Column(
      children: [
        const LabelBar('Personal information'),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleText('Trainee level', context),
            const SizedBox(width: 25),
            SizedBox(
              width: 200,
              child: DropdownButton<Level>(
                value: setup.level,
                icon: const Icon(Icons.arrow_downward),
                onChanged: notifier.setLevel,
                items: Level.values.map<DropdownMenuItem<Level>>((Level value) {
                  return DropdownMenuItem<Level>(
                    value: value,
                    child: Text(value.name),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(width: 25),
            const MarkdownBody(data: helpTraineeLevel),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            titleText('Sex', context),
            const SizedBox(width: 25),
            SizedBox(
              width: 200,
              child: DropdownButton<Sex>(
                value: setup.sex,
                icon: const Icon(Icons.arrow_downward),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            titleText('Age', context),
            const SizedBox(width: 25),
            SizedBox(
              width: 200,
              child: TextFormField(
                key: keyAge,
                initialValue: setup.age.toString(),
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.always,
                validator: notifier.ageValidator,
                onChanged: notifier.setAgeMaybe,
              ),
            ),
            const SizedBox(width: 25),
            const Text('years'),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            titleText('Weight', context),
            const SizedBox(width: 25),
            SizedBox(
              width: 200,
              child: TextFormField(
                key: keyWeight,
                initialValue: setup.weight.toString(),
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.always,
                validator: notifier.weightValidator,
                onChanged: notifier.setWeightMaybe,
              ),
            ),
            const SizedBox(width: 25),
            const Text('kg'),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            titleText('Height', context),
            const SizedBox(width: 25),
            SizedBox(
              width: 200,
              child: TextFormField(
                key: keyHeight,
                initialValue: setup.height.toString(),
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.always,
                validator: notifier.heightValidator,
                onChanged: notifier.setHeightMaybe,
              ),
            ),
            const SizedBox(width: 25),
            const Text('cm'),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            titleText('Body fat %', context),
            const SizedBox(width: 25),
            SizedBox(
              width: 200,
              child: TextFormField(
                key: keyBodyFat,
                initialValue: setup.bodyFat?.toString(),
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.always,
                validator: notifier.bodyFatValidator,
                onChanged: notifier.setBodyFatMaybe,
              ),
            ),
            const SizedBox(width: 25),
            const MarkdownBody(data: helpBodyFat),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            titleText('Energy balance %', context),
            const SizedBox(width: 25),
            SizedBox(
              width: 200,
              child: TextFormField(
                key: keyEnergyBalance,
                initialValue: setup.energyBalance.toString(),
                validator: notifier.energyBalanceValidator,
                onChanged: notifier.setEnergyBalanceMaybe,
              ),
            ),
            const SizedBox(width: 25),
            const MarkdownBody(data: helpEnergyBalance),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            titleText('Recovery factor', context),
            const SizedBox(width: 25),
            SizedBox(
              width: 200,
              child: TextFormField(
                key: keyRecoveryFactor,
                initialValue: setup.recoveryFactor.toString(),
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.always,
                validator: notifier.recoveryFactorValidator,
                onChanged: notifier.setRecoveryFactorMaybe,
              ),
            ),
            const SizedBox(width: 25),
            const MarkdownBody(data: helpRecoveryFactor),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            titleText('Workouts per week', context),
            const SizedBox(width: 25),
            SizedBox(
              width: 200,
              child: TextFormField(
                key: keyWorkoutsPerWeek,
                initialValue: setup.workoutsPerWeek.toString(),
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.always,
                validator: notifier.workoutsPerWeekValidator,
                onChanged: notifier.setWorkoutsPerWeekMaybe,
              ),
            ),
            const SizedBox(width: 25),
            const Text('sessions per week'),
          ],
        ),
        const SizedBox(height: 20),
        Row(
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
                          title: const Text('Activity Level'),
                          content: MarkdownBody(data: helpActivityLevel),
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
                  Text('Activity Level',
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
              context,
            ),
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
          ],
        ),
        const SizedBox(height: 20),
        Row(
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
                          title: const Text('Workout Duration'),
                          content: MarkdownBody(data: helpWorkoutDuration),
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
                  Text('Workout Duration',
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
              context,
            ),
            const SizedBox(width: 25),
            SizedBox(
              width: 200,
              child: TextFormField(
                key: _durationKey,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                ),
                initialValue: setup.workoutDuration.toString(),
                autovalidateMode: AutovalidateMode.always,
                validator: notifier.workoutDurationValidator,
                onChanged: notifier.setWorkoutDurationMaybe,
              ),
            ),
            const SizedBox(width: 25),
            const Text('minutes'),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
