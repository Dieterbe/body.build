import 'package:flutter/material.dart';
import 'package:bodybuild/data/dataset/ex.dart';
import 'package:bodybuild/data/dataset/program_group.dart';
import 'package:bodybuild/model/programmer/program_state.dart';

class ProgramBreakdown extends StatelessWidget {
  const ProgramBreakdown(this.program, {super.key});
  final ProgramState program;

  @override
  Widget build(BuildContext context) {
    // pg -> modality -> Ex (hitting pg with recruitment >= 0.5) -> number of sets of that ex
    final Map<ProgramGroup, Map<String, Map<Ex, int>>> tree = Map.fromEntries(
      ProgramGroup.values.map((group) => MapEntry(group, {})),
    );

    // Go through the program and build the structure
    for (final workout in program.workouts) {
      for (final setGroup in workout.setGroups) {
        for (final sets in setGroup.sets) {
          if (sets.ex != null) {
            for (final group in ProgramGroup.values) {
              final r = sets.ex!.recruitment(group, sets.tweakOptions);
              final modality = r.modality ?? 'UNKNOWN';
              if (r.volume >= 0.5) {
                tree[group]![modality] ??= {};
                tree[group]![modality]!.update(
                  sets.ex!,
                  (value) => value + sets.n,
                  ifAbsent: () => sets.n,
                );
              }
            }
          }
        }
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Muscle modalities", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          const Text(
            'Note: the purpose is understanding the different ways in which the muscle is stimulated',
          ),
          const Text(
            'for a given muscle, only the relevant articulations of used exercises are shown',
          ),
          const Text(
            'this section is a WORK IN PROGRESS. does not include many details yet like leverage curve, unilateral vs bilateral, eccentric overloading, etc',
          ),
          const Text(
            'For this to make any sense, make sure to have added several sets of exercises. Note. many exercises are not added yet to this analysis',
          ),
          const SizedBox(height: 16),
          ...ProgramGroup.values.map((group) {
            final modalities = tree[group]!;
            if (modalities.isEmpty) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.displayNameShort,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 16, top: 8),
                      child: Text('No exercises with recruitment ≥ 0.5'),
                    ),
                  ],
                ),
              );
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.displayNameShort,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  ...modalities.entries.map((modalityGroup) {
                    final description = modalityGroup.key;
                    final exerciseList = modalityGroup.value;
                    final exerciseText = exerciseList.entries
                        .map((e) => '${e.value}x ${e.key.id}')
                        .join(', ');

                    return Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 300,
                              padding: const EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Theme.of(context).colorScheme.outlineVariant,
                                  ),
                                ),
                              ),
                              child: Text(
                                description,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(
                                  exerciseText,
                                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
