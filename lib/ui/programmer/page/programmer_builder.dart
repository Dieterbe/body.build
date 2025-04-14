import 'package:bodybuild/data/programmer/current_program_provider.dart';
import 'package:bodybuild/data/programmer/exercises.dart';
import 'package:bodybuild/data/programmer/program_list_provider.dart';
import 'package:bodybuild/data/programmer/program_persistence_provider.dart';
import 'package:bodybuild/model/programmer/set_group.dart';
import 'package:bodybuild/ui/core/markdown.dart';
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

  Future<void> _createEmptyProgram(BuildContext context, WidgetRef ref) async {
    final service = await ref.read(programPersistenceProvider.future);
    final newId = DateTime.now().millisecondsSinceEpoch.toString();

    const newProgram = ProgramState(
      name: 'New Program',
    );

    await service.saveProgram(newId, newProgram);
    await service.saveLastProgramId(newId);
    ref.invalidate(programListProvider);
    ref.invalidate(currentProgramProvider);
  }

  Future<void> _createDemoProgram(BuildContext context, WidgetRef ref) async {
    final service = await ref.read(programPersistenceProvider.future);
    final newId = DateTime.now().millisecondsSinceEpoch.toString();

    // Create a demo full-body workout program
    final demoProgram = ProgramState(
      name: 'Demo Full-Body Program',
      workouts: [
        Workout(
          name: 'Full Body Workout A',
          timesPerPeriod: 2,
          periodWeeks: 1,
          setGroups: [
            SetGroup([
              Sets(
                70,
                ex: exes
                    .firstWhere((e) => e.id == "standing barbell bicep curl"),
              ),
            ]),
            SetGroup([
              Sets(
                70,
                ex: exes.firstWhere((e) => e.id == "pullup"),
              ),
            ]),
            SetGroup([
              Sets(
                70,
                ex: exes.firstWhere(
                    (e) => e.id == "standing dumbbell good morning"),
              ),
            ]),
            SetGroup([
              Sets(
                70,
                ex: exes.firstWhere((e) => e.id == "ab crunch machine"),
              ),
            ]),
          ],
        ),
      ],
    );

    await service.saveProgram(newId, demoProgram);
    await service.saveLastProgramId(newId);
    ref.invalidate(programListProvider);
    ref.invalidate(currentProgramProvider);
  }

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
        error: (error, stack) {
          if (error.toString().contains('No programs found')) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Welcome to Body.build!'),
                    content: markdown("""You have no workout programs defined.  
                        Would you like to load a demo workout program to help you get started?""",
                        context),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _createDemoProgram(context, ref);
                          },
                          icon: const Icon(Icons.auto_awesome),
                          label: const Text('Create demo program'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _createEmptyProgram(context, ref);
                        },
                        icon: const Icon(Icons.create),
                        label: const Text('Start from scratch'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          foregroundColor:
                              Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  );
                },
              );
            });
            return const SizedBox.shrink();
          } else {
            return Center(child: Text('Error loading program: $error'));
          }
        },
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
