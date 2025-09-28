import 'dart:math';

import 'package:bodybuild/model/programmer/workout.dart';
import 'package:bodybuild/model/programmer/workout_stats.dart';
import 'package:bodybuild/ui/programmer/widget/histogram.dart';
import 'package:bodybuild/ui/programmer/widget/kv_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bodybuild/data/programmer/groups.dart';
import 'package:bodybuild/ui/programmer/util_groups.dart';
import 'package:bodybuild/data/developer_mode_provider.dart';

import '../../../model/programmer/settings.dart';

const helpMsg = '''
## Set Counts per musclegroup

In line with scientific research:
* we use fractional (partial) volume counting
* we count recruitment only if it meets a minimum value of roughly 40% (we use 50% as a threshold).

Examples:
* 2 sets of rows are counted as 1 set of bicep recruitment (because a row recruits the bicep for about 50%)
* a single set of pull-ups or bicep curls counts as 1 set of bicep recruitment. (because it recruits 100%)
* a set of squats counts as 0% volume for hamstrings (because squats recruit hamstrings less than 40%)

## Set Counts per musclegroup in Workout analysis vs Program analysis

* Workout analysis set counts: the sum of all recruitments of all sets within a single workout (session).
* Program analysis set counts: the sum of all workout totals in the program, adjusted for each workout's frequency (times per period in weeks), and compared to the volume goals from the set-up tab.

Example: a workout with 4 sets of bicep curls will have a workout total volume of 4 for biceps.  
If that workout repeats 3 times in 2 weeks, it will contribute `4 * (3/2) = 6` to the program total.  
The program total considers all workouts this way.  If the number of sets for biceps is equal or more than what is configured via the set-up tab,
it will be shown in green. Otherwise, in red.

''';

class BuilderTotalsWidget extends ConsumerWidget {
  final List<Workout> workouts;
  final Settings? setup; // to validate the totals against desired volumes

  const BuilderTotalsWidget(this.workouts, {this.setup, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ws = WorkoutsStats(setup, workouts, 0.5);

    // to normalize the values, reducing the amount of vertical space needed if (some of) the volumes become high
    const limit = 2.0;
    var title = '${setup == null ? 'Workout' : 'Program'} analysis';

    final devMode = ref.watch(developerModeProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: MediaQuery.sizeOf(context).width / 80,
                letterSpacing: 0.3,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
        const Divider(thickness: 2),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side stats
              Expanded(
                flex: 45,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (setup != null && devMode)
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Program Volume Score', style: TextStyle(fontSize: 12)),
                                Text(
                                  '${(ws.score * 100).toStringAsFixed(1)}%',
                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        Expanded(
                          child: KVRow(
                            Text(
                              'Number of sets per number of involved muscle groups',
                              style: TextStyle(
                                fontSize: MediaQuery.sizeOf(context).width / 100,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            helpTitle: 'Number of sets per number of involved muscle groups',
                            help: '''
Shows how many sets target 1 muscle group (isolations), how many hit 2, 3 etc (compounds).  
This enables you to see and optimize the balance between isolation and compound exercises.
''',
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 8,
                      ), // a bit of a hack, to create some space against the viz on the right
                      child: SizedBox(
                        height: 40 + 40 * max(1, min(ws.maxVal, limit)),
                        child: HistogramWidget(data: ws.setsHisto),
                      ),
                    ),
                  ],
                ),
              ),
              // Right side volume bars
              Expanded(
                flex: 55,
                child: Column(
                  children: [
                    KVRow(
                      Text(
                        'Set counts per musclegroup',
                        style: TextStyle(
                          fontSize: MediaQuery.sizeOf(context).width / 100,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      helpTitle: title,
                      help: helpMsg,
                    ),
                    SizedBox(
                      // width: 40,
                      // "background" height.
                      // if maxVal < 1 -> should be 40
                      // if 1 < maxVal < limit: should be 40 * maxVal
                      // if maxVal > limit: should be 40 * limit
                      height: 40 * max(1, min(ws.maxVal, limit)),
                      child: Row(
                        children: ProgramGroup.values
                            .map(
                              (g) => Expanded(
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Container(
                                      height: double.infinity,
                                      color: bgColorForProgramGroup(g),
                                    ),
                                    Container(
                                      height:
                                          40 *
                                          (ws.maxVal > limit
                                              ? ws.totals[g]! / ws.maxVal * limit
                                              : ws.totals[g]!),
                                      color: Theme.of(context).colorScheme.tertiary,
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        children: ProgramGroup.values
                            .map(
                              (g) => Expanded(
                                child: Container(
                                  color: bgColorForProgramGroup(g),
                                  child: Center(
                                    child: Text(
                                      ws.totals[g]!.toStringAsFixed(1),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: MediaQuery.of(context).size.width / 100,
                                        color: (setup == null)
                                            ? Colors.black
                                            : (ws.totals[g]! >=
                                                      setup!.paramFinal
                                                          .getSetsPerWeekPerMuscleGroupFor(g)
                                                  ? Colors.green
                                                  : Colors.red),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
