import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptc/data/programmer/current_program_provider.dart';
import 'package:ptc/data/programmer/groups.dart';
import 'package:ptc/data/programmer/program.dart';
import 'package:ptc/data/programmer/program_list_provider.dart';
import 'package:ptc/data/programmer/program_persistence_provider.dart';
import 'package:ptc/data/programmer/setup.dart';
import 'package:ptc/model/programgen_v2/generator.dart';
import 'package:ptc/model/programmer/program_state.dart';
import 'package:ptc/model/programmer/workout.dart';

class ProgramHeader extends ConsumerWidget {
  final ProgramState program;

  const ProgramHeader({super.key, required this.program});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setup = ref.watch(setupProvider);
    final notifier = ref.read(programProvider.notifier);
    final currentProgramId = ref.watch(currentProgramProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Combined program selector and name editor
              ref.watch(programListProvider).when(
                    loading: () => const SizedBox(
                      width: 200,
                      child: LinearProgressIndicator(),
                    ),
                    error: (error, stack) => Text('Error: $error'),
                    data: (programs) => currentProgramId.when(
                      loading: () => const CircularProgressIndicator(),
                      error: (error, stack) => Text('Error: $error'),
                      data: (currentId) {
                        // Watch the current program to rebuild when it changes
                        final currentProgram = ref.watch(programProvider);
                        return currentProgram.when(
                          loading: () => const CircularProgressIndicator(),
                          error: (error, stack) => Text('Error: $error'),
                          data: (program) => SizedBox(
                            width: 400,
                            child: DropdownButtonFormField<String>(
                              value: currentId,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                                ),
                                filled: true,
                                fillColor:
                                    Theme.of(context).colorScheme.surface,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              style: Theme.of(context).textTheme.bodyLarge,
                              items: programs.keys.map((id) {
                                // Always use the programs map for consistency
                                final programName =
                                    programs[id]?.name ?? 'Unnamed Program';
                                return DropdownMenuItem(
                                  value: id,
                                  child: Text(
                                    programName,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              onChanged: (id) {
                                if (id != null) {
                                  ref
                                      .read(currentProgramProvider.notifier)
                                      .select(id);
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              const SizedBox(width: 16),
              // Program management buttons
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    IconButton(
                      style: IconButton.styleFrom(
                        shape: const RoundedRectangleBorder(),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: Icon(
                        Icons.edit,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      tooltip: 'Rename Program',
                      onPressed: () {
                        final controller =
                            TextEditingController(text: program.name);
                        showDialog<String>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Rename Program'),
                            content: TextField(
                              controller: controller,
                              autofocus: true,
                              decoration: const InputDecoration(
                                labelText: 'Program Name',
                              ),
                              onSubmitted: (value) =>
                                  Navigator.of(context).pop(value),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async =>
                                    Navigator.of(context).pop(controller.text),
                                child: const Text('Rename'),
                              ),
                            ],
                          ),
                        ).then((newName) async {
                          if (newName != null && newName.isNotEmpty) {
                            // First update the name in the current program
                            notifier.updateName(newName);

                            // Wait for the name to be saved
                            await ref.read(programPersistenceProvider.future);

                            // Then refresh the program list
                            ref.invalidate(programListProvider);
                          }
                        });
                      },
                    ),
                    // New program button
                    IconButton(
                      style: IconButton.styleFrom(
                        shape: const RoundedRectangleBorder(),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: Icon(
                        Icons.add,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      tooltip: 'New Program',
                      onPressed: () async {
                        final service =
                            await ref.read(programPersistenceProvider.future);

                        // Get existing programs to determine the new name
                        final programs = await service.loadPrograms();
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
                            final match =
                                RegExp(r'New Program (\d+)').firstMatch(name);
                            if (match != null) {
                              final number = int.parse(match.group(1)!);
                              maxNumber =
                                  number > maxNumber ? number : maxNumber;
                            }
                          }
                          newName = 'New Program ${maxNumber + 1}';
                        }

                        final newId =
                            DateTime.now().millisecondsSinceEpoch.toString();
                        await service.saveProgram(
                          newId,
                          ProgramState(name: newName),
                        );
                        ref.invalidate(programListProvider);
                        ref.read(currentProgramProvider.notifier).select(newId);
                      },
                    ),
                    // Duplicate program button
                    IconButton(
                      style: IconButton.styleFrom(
                        shape: const RoundedRectangleBorder(),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: Icon(
                        Icons.content_copy,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      tooltip: 'Duplicate Program',
                      onPressed: () async {
                        final service =
                            await ref.read(programPersistenceProvider.future);
                        final currentId =
                            await ref.read(currentProgramProvider.future);
                        final currentProgram =
                            await service.loadProgram(currentId);
                        if (currentProgram != null) {
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
                              final match =
                                  RegExp(r'\(Copy (\d+)\)').firstMatch(name);
                              if (match != null) {
                                final number = int.parse(match.group(1)!);
                                maxNumber =
                                    number > maxNumber ? number : maxNumber;
                              } else {
                                // If we find a plain "(Copy)", treat it as number 1
                                maxNumber = maxNumber > 1 ? maxNumber : 1;
                              }
                            }
                            newName = '$baseName (Copy ${maxNumber + 1})';
                          }

                          final newId =
                              DateTime.now().millisecondsSinceEpoch.toString();
                          await service.saveProgram(
                            newId,
                            currentProgram.copyWith(name: newName),
                          );
                          ref.invalidate(programListProvider);
                          ref
                              .read(currentProgramProvider.notifier)
                              .select(newId);
                        }
                      },
                    ),
                    // Delete program button
                    IconButton(
                      style: IconButton.styleFrom(
                        shape: const RoundedRectangleBorder(),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      tooltip: 'Delete Program',
                      onPressed: () async {
                        final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Program'),
                            content: const Text(
                                'Are you sure you want to delete this program? This action cannot be undone.'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );

                        if (shouldDelete == true) {
                          final service =
                              await ref.read(programPersistenceProvider.future);
                          final currentId =
                              await ref.read(currentProgramProvider.future);
                          await service.deleteProgram(currentId);

                          // Get updated program list
                          final programs = await service.loadPrograms();
                          ref.invalidate(programListProvider);

                          // If no programs exist, create a new default one
                          if (programs.isEmpty) {
                            final newId = DateTime.now()
                                .millisecondsSinceEpoch
                                .toString();
                            await service.saveProgram(
                              newId,
                              const ProgramState(name: 'New Program'),
                            );
                            ref.invalidate(programListProvider);
                            ref
                                .read(currentProgramProvider.notifier)
                                .select(newId);
                          } else {
                            // Select the first available program
                            ref
                                .read(currentProgramProvider.notifier)
                                .select(programs.keys.first);
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  notifier.add(const Workout());
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
                  var oldWorkout = const Workout();
                  notifier.add(oldWorkout);

                  // Listen to stream of solutions and update the workout
                  await for (final setGroup in generateOptimalSetGroup(
                    target,
                    excludedExercises: setup.paramOverrides.excludedExercises,
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
    );
  }
}
