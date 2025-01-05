import 'package:flutter/widgets.dart';
import 'package:ptc/data/programmer/exercises.dart';
import 'package:ptc/data/programmer/groups.dart';
import 'package:ptc/model/programmer/program_state.dart';

class ProgramBreakdown extends StatelessWidget {
  const ProgramBreakdown(this.program, {super.key});
  final ProgramState program;

  @override
  Widget build(BuildContext context) {
    // Create a map to store exercises that hit each program group with recruitment >= 0.5
    final Map<ProgramGroup, Map<Ex, int>> groupExercises = {};

    // Initialize empty maps for each program group
    for (final group in ProgramGroup.values) {
      groupExercises[group] = {};
    }

    // Go through all workouts and their sets to find exercises that hit each group
    for (final workout in program.workouts) {
      for (final setGroup in workout.setGroups) {
        for (final sets in setGroup.sets) {
          if (sets.ex != null) {
            for (final group in ProgramGroup.values) {
              if (sets.ex!.recruitment(group) >= 0.5) {
                groupExercises[group]!.update(
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Program breakdown",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...ProgramGroup.values.map((group) {
          final exercises = groupExercises[group]!;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Text(
                  group.displayName,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (exercises.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: exercises.entries.map((e) {
                            var assignDesc = e.key.va.assignDesc[group];
                            assignDesc =
                                (assignDesc != null) ? ' ($assignDesc)' : '';
                            return Text(
                                '${e.value} sets of ${e.key.id} $assignDesc');
                          }).toList(),
                        ),
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text('No exercises with recruitment ≥ 0.5'),
                      ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
