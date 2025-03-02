import 'package:bodybuild/ui/core/widget/version.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bodybuild/data/programmer/program.dart';
import 'package:bodybuild/data/programmer/setup.dart';
import 'package:bodybuild/model/programmer/program_state.dart';

import 'package:bodybuild/model/programmer/workout.dart';
import 'package:bodybuild/ui/programmer/widget/builder_workout.dart';
import 'package:bodybuild/ui/programmer/widget/headers.dart';
import 'package:bodybuild/ui/programmer/widget/builder_totals.dart';
import 'package:bodybuild/ui/programmer/widget/program_breakdown.dart';
import 'package:bodybuild/ui/programmer/widget/program_header.dart';

class ProgrammerBuilder extends ConsumerWidget {
  const ProgrammerBuilder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final program = ref.watch(programProvider);
    final setup = ref.watch(setupProvider);
    final notifier = ref.read(programProvider.notifier);

    /*
      To make sure the programGroup indicators are all aligned, between the top
      headers, 'add set' buttons, and actual sets (which may be combosets), which
      are inside of workout containers, we need to apply a consistent padding on left and right.
      at a high level, the divisions are like so:
      | <20px>< 45% left section >< 55% right section > <20px>
      and within the left section we use these flex factors:
      <15 sets><15 intensity><10 edit><10 delete><70 exercise name><35 equipment>
*/

    return setup.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) =>
          Center(child: Text('Error loading settings: $error')),
      data: (setup) => program.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Error loading program: $error')),
        data: (program) {
          //   dumpProgram(program);

          return Column(children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(width: 20),
                const Flexible(flex: 45, child: ProgramHeader()),
                Flexible(
                    flex: 55,
                    child: program.workouts.isEmpty ? Container() : headers()),
                const SizedBox(width: 20),
              ],
            ),
            // visual aid for debugging
            /*    Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(width: 20),
                Flexible(
                  flex: 45,
                  child: Container(color: Colors.blueGrey, height: 20),
                ),
                Flexible(
                  flex: 55,
                  child: Row(children: [
                    ...ProgramGroup.values.map(
                      (g) => Expanded(
                        // Expanded is IMPORTANT to take up the whole width
                        child: Container(
                            color: bgColorForProgramGroup(g), height: 20),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(width: 20),
              ],
            ),
            */

            ...program.workouts.map((w) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: BuilderWorkoutWidget(setup, w, (Workout? wNew) {
                    notifier.updateWorkout(w, wNew);
                  }),
                )),
            if (program.workouts.isNotEmpty)
              BuilderTotalsWidget(
                program.workouts,
                setup: setup,
              ),
            if (program.workouts.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _showBreakdownDialog(context, program),
                      icon: const Icon(Icons.analytics),
                      label: const Text('View Program Breakdown'),
                    ),
                  ],
                ),
              ),
            const VersionWidget(),
          ]);
        },
      ),
    );
  }

  void _showBreakdownDialog(BuildContext context, ProgramState program) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Program Breakdown',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ProgramBreakdown(program),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

void dumpProgram(ProgramState program) {
  // print the whole program to stdout
  print("PROGRAM ${program.name}");
  for (var w in program.workouts) {
    print("  WORKOUT ${w.name}");
    for (var sg in w.setGroups) {
      print("    SetGroup with ${sg.sets.length} sets");
      for (var s in sg.sets) {
        print("      ${s.n} sets of ${s.ex?.id} @ ${s.intensity}");
      }
    }
  }
}
