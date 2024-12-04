import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptc/data/programmer/program.dart';
import 'package:ptc/data/programmer/setup.dart';
import 'package:ptc/model/programmer/program_state.dart';
import 'package:ptc/model/programmer/workout.dart';
import 'package:ptc/ui/programmer/widget/builder_workout.dart';
import 'package:ptc/ui/programmer/widget/headers.dart';
import 'package:ptc/ui/programmer/widget/builder_totals.dart';
import 'package:ptc/data/programmer/groups.dart';
import 'package:ptc/model/programgen_v2/generator.dart';
import 'package:ptc/data/programmer/current_program_provider.dart';
import 'package:ptc/data/programmer/program_list_provider.dart';
import 'package:ptc/data/programmer/program_persistence_provider.dart';

class ProgrammerBuilder extends ConsumerWidget {
  const ProgrammerBuilder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final program = ref.watch(programProvider);
    final setup = ref.watch(setupProvider);
    final notifier = ref.read(programProvider.notifier);
    final currentProgramId = ref.watch(currentProgramProvider);
    final programList = ref.watch(programListProvider);

    return Column(children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            children: [
              Row(
                children: [
                  // Program selector dropdown
                  programList.when(
                    loading: () => const SizedBox(
                      width: 200,
                      child: LinearProgressIndicator(),
                    ),
                    error: (error, stack) => Text('Error: $error'),
                    data: (programs) => DropdownButton<String>(
                      value: currentProgramId,
                      items: programs.keys.map((id) {
                        return DropdownMenuItem(
                          value: id,
                          child: Text(programs[id]?.name ?? 'Unnamed Program'),
                        );
                      }).toList(),
                      onChanged: (id) {
                        if (id != null) {
                          ref.read(currentProgramProvider.notifier).select(id);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  // New program button
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () async {
                      final service =
                          await ref.read(programPersistenceProvider.future);
                      final newId =
                          DateTime.now().millisecondsSinceEpoch.toString();
                      await service.saveProgram(
                        newId,
                        const ProgramState(name: 'New Program'),
                      );
                      ref.invalidate(programListProvider);
                      ref.read(currentProgramProvider.notifier).select(newId);
                    },
                  ),
                  // Delete program button
                  if (currentProgramId != CurrentProgram.defaultId)
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        final service =
                            await ref.read(programPersistenceProvider.future);
                        await service.deleteProgram(currentProgramId);
                        ref.invalidate(programListProvider);
                        ref
                            .read(currentProgramProvider.notifier)
                            .select(CurrentProgram.defaultId);
                      },
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 200,
                  child: TextFormField(
                    key: ValueKey(program.name),
                    initialValue: program.name,
                    decoration: const InputDecoration(
                      labelText: 'Program Name',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      notifier.updateName(value);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      notifier.add(Workout());
                    },
                    child: const Row(
                      children: [Icon(Icons.add), Text('add workout')],
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      // Create map of target recruitments from setup parameters
                      final target = <ProgramGroup, double>{};
                      for (final group in ProgramGroup.values) {
                        target[group] = setup.paramFinal
                                .getSetsPerWeekPerMuscleGroupFor(group) *
                            1.0;
                      }

                      // Create a workout to hold our evolving solution
                      var oldWorkout = Workout();
                      notifier.add(oldWorkout);

                      // Listen to stream of solutions and update the workout
                      await for (final setGroup in generateOptimalSetGroup(
                        target,
                        excludedExercises:
                            setup.paramOverrides.excludedExercises,
                        excludedBases: setup.paramOverrides.excludedBases,
                      )) {
                        final newWorkout = Workout(setGroups: [setGroup]);
                        notifier.updateWorkout(oldWorkout, newWorkout);
                        await Future.delayed(const Duration(milliseconds: 100));
                        oldWorkout = newWorkout;
                      }
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.auto_awesome),
                        Text('generate workout')
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Expanded(child: Container()),
          /* our legend doesn't render well and is not particularly useful
          // (it gets confusing because the volume totals don't follow the same color scheme)
          // so let's just disable it for now.
          // better would be to have tooltips over the musclemarks, but they don't work well on flutter web - they don't respond to clicks
          const Legend(),
          */
          const SizedBox(width: 30),
          headers(),
          const SizedBox(width: 20),
        ],
      ),
      ...program.workouts.map((w) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: BuilderWorkoutWidget(setup, w, (Workout? wNew) {
              notifier.updateWorkout(w, wNew);
            }),
          )),
      if (program.workouts.isNotEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          child: BuilderTotalsWidget(
              //   multiplier: 2,
              program.workouts.fold([], (e, w) => [...e, ...w.setGroups]),
              setup: setup),
        ),
      if (program.workouts.isNotEmpty) const SizedBox(height: 20),
      if (program.workouts.isNotEmpty)
        Row(
          children: [
            Expanded(child: Container()),
            const Text("Note: total only counts volumes >=0.5"),
          ],
        )
    ]);
  }
}
