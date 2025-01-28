import 'package:bodybuild/data/programmer/groups.dart';
import 'package:bodybuild/model/programgen_v2/generator.dart';
import 'package:bodybuild/ui/programmer/widget/pulse_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bodybuild/data/programmer/current_program_provider.dart';
import 'package:bodybuild/data/programmer/program.dart';
import 'package:bodybuild/data/programmer/program_list_provider.dart';
import 'package:bodybuild/data/programmer/program_persistence_provider.dart';
import 'package:bodybuild/data/programmer/setup.dart';
import 'package:bodybuild/model/programmer/program_state.dart';
import 'package:bodybuild/model/programmer/workout.dart';
import 'package:bodybuild/ui/core/widget/data_manager.dart';
import 'package:bodybuild/data/developer_mode_provider.dart';

class ProgramHeader extends ConsumerWidget {
  const ProgramHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setup = ref.watch(setupProvider);
    final notifier = ref.read(programProvider.notifier);
    final currentProgramId = ref.watch(currentProgramProvider);

// returns all the keys of programs, the first one being currentId
    List<String> getOpts(String currentId, Map<String, ProgramState> programs) {
      final currentName = programs[currentId]!.name;
      final otherNames = programs.entries
          .where((e) => e.key != currentId)
          .map((e) => e.value.name)
          .toList();
      return [currentName, ...otherNames];
    }

    onSelect(String name, Map<String, ProgramState> programs) {
      final entry = programs.entries.firstWhere(
        (e) => e.value.name == name,
      );
      ref.read(currentProgramProvider.notifier).select(entry.key);
    }

    onCreate(String id, String name) async {
      final service = await ref.read(programPersistenceProvider.future);

      // Get existing programs to check for name conflicts
      final programs = await service.loadPrograms();

      // If name is empty or already exists, generate a new unique name
      if (name.isEmpty || programs.values.any((p) => p.name == name)) {
        final newProgramNames = programs.values
            .map((p) => p.name)
            .where((name) => name.startsWith('New Program'))
            .toList();

        // Determine the new program name
        String newName = 'New Program';
        if (newProgramNames.isNotEmpty) {
          // Find the highest number used
          int maxNumber = 1;
          for (final name in newProgramNames) {
            if (name == 'New Program') continue;
            final match = RegExp(r'New Program (\d+)').firstMatch(name);
            if (match != null) {
              final number = int.parse(match.group(1)!);
              maxNumber = number > maxNumber ? number : maxNumber;
            }
          }
          name = 'New Program ${maxNumber + 1}';
        } else {
          name = newName;
        }
      }

      final newId = DateTime.now().millisecondsSinceEpoch.toString();
      await service.saveProgram(
        newId,
        ProgramState(name: name),
      );
      ref.invalidate(programListProvider);
      ref.read(currentProgramProvider.notifier).select(newId);
    }

    onRename(String oldName, String newName) async {
      // First update the name in the current program
      notifier.updateName(newName);

      // Wait for the name to be saved
      await ref.read(programPersistenceProvider.future);

      // Then refresh the program list
      ref.invalidate(programListProvider);
    }

    onDuplicate(String oldName, String newName) async {
      final service = await ref.read(programPersistenceProvider.future);
      final currentId = await ref.read(currentProgramProvider.future);
      final currentProgram = await service.loadProgram(currentId);
      if (currentProgram == null) return;

      // Get all programs to check for existing copies
      final programs = await service.loadPrograms();
      final baseName = currentProgram.name;

      // Find all copies of this program
      final copies = programs.values
          .map((p) => p.name)
          .where((name) => name.startsWith(baseName))
          .toList();

      // Determine the new name
      String newName;
      if (copies.isEmpty) {
        newName = '$baseName (Copy)';
      } else {
        // Find highest copy number
        int maxNumber = 1;
        for (final name in copies) {
          final match = RegExp(r'\(Copy (\d+)\)').firstMatch(name);
          if (match != null) {
            final number = int.parse(match.group(1)!);
            maxNumber = number > maxNumber ? number : maxNumber;
          } else {
            // If we find a plain "(Copy)", treat it as number 1
            maxNumber = maxNumber > 1 ? maxNumber : 1;
          }
        }
        newName = '$baseName (Copy ${maxNumber + 1})';
      }

      final newId = DateTime.now().millisecondsSinceEpoch.toString();
      await service.saveProgram(
        newId,
        currentProgram.copyWith(name: newName),
      );
      ref.invalidate(programListProvider);
      ref.read(currentProgramProvider.notifier).select(newId);
    }

    onDelete(String name) async {
      final service = await ref.read(programPersistenceProvider.future);
      final currentId = await ref.read(currentProgramProvider.future);
      await service.deleteProgram(currentId);

      // Get updated program list
      final programs = await service.loadPrograms();
      ref.invalidate(programListProvider);

      // If no programs exist, create a new default one
      if (programs.isEmpty) {
        final newId = DateTime.now().millisecondsSinceEpoch.toString();
        await service.saveProgram(
          newId,
          const ProgramState(name: 'New Program'),
        );
        ref.invalidate(programListProvider);
        ref.read(currentProgramProvider.notifier).select(newId);
      } else {
        // Select the first available program
        ref.read(currentProgramProvider.notifier).select(programs.keys.first);
      }
    }

    return setup.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (setup) => ref.watch(programListProvider).when(
            loading: () => const LinearProgressIndicator(),
            error: (error, stack) => Text('Error: $error'),
            data: (programs) => currentProgramId.when(
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('Error: $error'),
              data: (currentId) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DataManager(
                      opts: getOpts(currentId, programs),
                      onSelect: (name) => onSelect(name, programs),
                      onCreate: onCreate,
                      onRename: onRename,
                      onDuplicate: onDuplicate,
                      onDelete: onDelete,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        PulseMessageWidget(
                            pulse: ref.watch(programProvider).when(
                                  data: (program) => program.workouts.isEmpty,
                                  loading: () => false,
                                  error: (_, __) => false,
                                ),
                            msg: 'No workouts yet. Add one!',
                            child: ElevatedButton(
                              onPressed: () {
                                notifier.add(const Workout());
                              },
                              child: const Row(
                                children: [
                                  Icon(Icons.add),
                                  Text('add workout')
                                ],
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
                                notifier.add(oldWorkout);

                                // Listen to stream of solutions and update the workout
                                await for (final setGroup
                                    in generateOptimalSetGroup(target, setup)) {
                                  final newWorkout = Workout(setGroups: [setGroup]);
                                  notifier.updateWorkout(oldWorkout, newWorkout);
                                  await Future.delayed(
                                      const Duration(milliseconds: 100));
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
                  ],
                );
              },
            ),
          ),
    );
  }
}
