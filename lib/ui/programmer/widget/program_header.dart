import 'package:bodybuild/data/programmer/groups.dart';
import 'package:bodybuild/data/programmer/program_manager.dart';
import 'package:bodybuild/model/programgen_v2/generator.dart';
import 'package:bodybuild/ui/programmer/widget/pulse_widget.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bodybuild/data/programmer/setup.dart';
import 'package:bodybuild/model/programmer/workout.dart';
import 'package:bodybuild/ui/core/widget/data_manager.dart';
import 'package:bodybuild/data/developer_mode_provider.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

class ProgramHeader extends ConsumerWidget {
  const ProgramHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setup = ref.watch(setupProvider);
    final programManagerState = ref.watch(programManagerProvider);

    // returns all the keys of programs, the first one being currentId
    List<String> getOpts(ProgramManagerState state) {
      final currentName = state.currentProgram.name;
      final otherNames = state.programs.entries
          .where((e) => e.key != state.currentProgramId)
          .map((e) => e.value.name)
          .toList();
      return [currentName, ...otherNames];
    }

    void onSelect(String name, ProgramManagerState state) {
      final entry =
          state.programs.entries.firstWhere((e) => e.value.name == name);
      ref.read(programManagerProvider.notifier).selectProgram(entry.key);
    }

    dynamic onCreate(String id, String name) {
      ref.read(programManagerProvider.notifier).createProgram(name);
      return null;
    }

    dynamic onRename(String oldName, String newName) {
      ref.read(programManagerProvider.notifier).updateProgramName(newName);
      return null;
    }

    dynamic onDuplicate(String name) {
      final state = programManagerState.value!;
      final currentProgram = state.currentProgram;

      // Generate a new unique name based on the current program's name
      final baseName = currentProgram.name;
      var newName = 'Copy of $baseName';
      var counter = 1;

      while (state.programs.values.any((p) => p.name == newName)) {
        counter++;
        newName = 'Copy $counter of $baseName';
      }

      ref.read(programManagerProvider.notifier).createProgram(newName);
      return null;
    }

    dynamic onDelete(String name) {
      final state = programManagerState.value!;
      ref
          .read(programManagerProvider.notifier)
          .deleteProgram(state.currentProgramId);
      return null;
    }

    return setup.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Text('Error: $error'),
      data: (setup) => programManagerState.when(
        loading: () => const CircularProgressIndicator(),
        error: (error, stack) => Text('Error: $error'),
        data: (state) => Column(children: [
          DataManager(
            opts: getOpts(state),
            onSelect: (name) => onSelect(name, state),
            onCreate: onCreate,
            onRename: onRename,
            onDuplicate: (_, name) => onDuplicate(name),
            onDelete: onDelete,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              PulseMessageWidget(
                  pulse: state.currentProgram.workouts.isEmpty,
                  msg: 'No workouts yet. Add one!',
                  child: ElevatedButton(
                    onPressed: () async {
                      ref
                          .read(programManagerProvider.notifier)
                          .addWorkout(const Workout());
                      if (kIsWeb) {
                        await Posthog().capture(
                          eventName: 'AddWorkoutButtonClicked',
                          properties: {
                            'workouts':
                                state.currentProgram.workouts.length + 1,
                          },
                        );
                      }
                    },
                    child: const Row(
                      children: [Icon(Icons.add), Text('add workout')],
                    ),
                  )),
              const SizedBox(width: 10),
              Consumer(
                builder: (context, ref, child) {
                  final isDevMode = ref.watch(developerModeProvider);
                  if (!isDevMode) return const SizedBox.shrink();

                  return ElevatedButton(
                    onPressed: () async {
                      // Create map of target recruitments from setup parameters
                      final target = <ProgramGroup, double>{};
                      for (final group in ProgramGroup.values) {
                        target[group] = setup.paramFinal
                                .getSetsPerWeekPerMuscleGroupFor(group) *
                            1.0;
                      }

                      // Create a workout to hold our evolving solution
                      var oldWorkout = const Workout();
                      ref
                          .read(programManagerProvider.notifier)
                          .addWorkout(oldWorkout);

                      // Listen to stream of solutions and update the workout
                      await for (final setGroup
                          in generateOptimalSetGroup(target, setup)) {
                        final newWorkout = Workout(setGroups: [setGroup]);
                        ref
                            .read(programManagerProvider.notifier)
                            .updateWorkout(oldWorkout, newWorkout);
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
                  );
                },
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
