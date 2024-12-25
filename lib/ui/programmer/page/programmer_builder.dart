import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptc/data/programmer/program.dart';
import 'package:ptc/data/programmer/setup.dart';

import 'package:ptc/model/programmer/workout.dart';
import 'package:ptc/ui/programmer/widget/builder_workout.dart';
import 'package:ptc/ui/programmer/widget/headers.dart';
import 'package:ptc/ui/programmer/widget/builder_totals.dart';
import 'package:ptc/ui/programmer/widget/program_header.dart';

class ProgrammerBuilder extends ConsumerWidget {
  const ProgrammerBuilder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final program = ref.watch(programProvider);
    final setup = ref.watch(setupProvider);
    final notifier = ref.read(programProvider.notifier);

    return setup.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) =>
          Center(child: Text('Error loading settings: $error')),
      data: (setup) => program.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Error loading program: $error')),
        data: (program) => Column(children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ProgramHeader(program: program),
              Expanded(child: Container()),
              const SizedBox(width: 30),
              if (program.workouts.isNotEmpty) headers(),
              const SizedBox(width: 20),
            ],
          ),
          if (program.workouts.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  'No workouts yet in this program. Add one!',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                      ),
                ),
              ),
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
                setup: setup,
              ),
            ),
          if (program.workouts.isNotEmpty) const SizedBox(height: 20),
          if (program.workouts.isNotEmpty)
            Row(
              children: [
                Expanded(child: Container()),
                const Text("Note: total only counts volumes >=0.5"),
              ],
            )
        ]),
      ),
    );
  }
}
