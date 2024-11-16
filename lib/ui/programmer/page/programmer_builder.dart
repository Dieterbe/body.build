import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptc/data/programmer/program.dart';
import 'package:ptc/data/programmer/setup.dart';
import 'package:ptc/model/programmer/workout.dart';
import 'package:ptc/ui/programmer/widget/builder_workout.dart';
import 'package:ptc/ui/programmer/widget/headers.dart';
import 'package:ptc/ui/programmer/widget/builder_totals.dart';

class ProgrammerBuilder extends ConsumerWidget {
  const ProgrammerBuilder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final program = ref.watch(programProvider);
    final setup = ref.watch(setupProvider);
    final notifier = ref.read(programProvider.notifier);
    return Column(children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {
              notifier.add(Workout());
            },
            child: const Row(
              children: [Icon(Icons.add), Text('add workout')],
            ),
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
        ],
      ),
      ...program.workouts.map((w) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: BuilderWorkoutWidget(setup, w, (Workout? wNew) {
              notifier.updateWorkout(w, wNew);
            }),
          )),
      if (program.workouts.isNotEmpty)
        BuilderTotalsWidget(
            program.workouts.fold([], (e, w) => [...e, ...w.setGroups])),
      if (program.workouts.isNotEmpty) const SizedBox(height: 30),
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
