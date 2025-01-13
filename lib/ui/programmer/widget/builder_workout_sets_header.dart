import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ptc/data/programmer/exercises.dart';
import 'package:ptc/data/programmer/groups.dart';
import 'package:ptc/model/programmer/set_group.dart';
import 'package:ptc/model/programmer/settings.dart';
import 'package:ptc/model/programmer/workout.dart';
import 'package:ptc/ui/programmer/util_groups.dart';
import 'package:ptc/ui/programmer/widget/add_set_button.dart';

class BuilderWorkoutSetsHeader extends StatelessWidget {
  final Workout workout;
  final Settings setup;
  final Function(Workout) onChange;
  const BuilderWorkoutSetsHeader(
    this.workout,
    this.setup, {
    required this.onChange,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          SizedBox(
            width: 45,
            child: Text(
              'Sets',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                letterSpacing: 0.3,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 45,
            child: Text(
              '%1RM',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                letterSpacing: 0.3,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 80),
          SizedBox(
            width: 250,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Exercise',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 0.3,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          Expanded(child: Container()),
          AddSetButton(
            () {
              onChange(workout.copyWith(setGroups: [
                ...workout.setGroups,
                SetGroup([Sets(setup.paramFinal.intensities.first)])
              ]));
            },
          ),
          /*
          const SizedBox(width: 16),
          Text(
            'Add set for muscle',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              letterSpacing: 0.3,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.8),
            ),
          ),
          */
          const SizedBox(width: 8),
          Icon(
            Icons.arrow_forward,
            size: 18,
            color: Theme.of(context).colorScheme.primary,
          ),
          ...ProgramGroup.values.map(
            (g) => Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: bgColorForProgramGroup(g),
                borderRadius: BorderRadius.circular(8),
              ),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        title: Text('Add an exercise which recruits $g'),
                        children: [
                          const Text(
                              'below are recommended exercises in order of recruitment'),
                          const Text(
                              'exercises are only shown if the needed equipment is selected in the set-up'),
                          /*
                                 // ideally, user wants to preview the possible exercises within the program volume stats, so we could plonk them there
                        // in a special "WIP" section (e.g. hatched background)
                      // on the other hand, they also probably want to do a search to narrow it down to specific exercises, so they would
                        // need a text filter, and in the future maybe future filters
                        // putting all of that in the main UI seems a bit too much. let's just use a simple selection for now    
                                */

                          Autocomplete<Ex>(
                              displayStringForOption: (e) => e.id,
                              optionsBuilder: (textEditingValue) {
                                final opts = setup.availableExercises
                                    .where((e) => e.recruitment(g).volume > 0)
                                    .where((e) => e.id.toLowerCase().contains(
                                        textEditingValue.text.toLowerCase()))
                                    .toList();
                                opts.sort((a, b) => (b.recruitment(g).volume)
                                    .compareTo(a.recruitment(g).volume));
                                return opts;
                              },
                              onSelected: (Ex e) {
                                onChange(workout.copyWith(setGroups: [
                                  ...workout.setGroups,
                                  SetGroup([
                                    Sets(setup.paramFinal.intensities.first,
                                        ex: e)
                                  ])
                                ]));
                                context.pop();
                              }),
                        ],
                      );
                    },
                  );
                },
                child:
                    const SizedBox(width: 30, child: Icon(Icons.add, size: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
