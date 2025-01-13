import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bodybuild/data/programmer/exercises.dart';
import 'package:bodybuild/data/programmer/groups.dart';
import 'package:bodybuild/model/programmer/set_group.dart';
import 'package:bodybuild/model/programmer/settings.dart';
import 'package:bodybuild/model/programmer/workout.dart';
import 'package:bodybuild/ui/programmer/util_groups.dart';

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
      margin: const EdgeInsets.symmetric(horizontal: 16), // affects alignment
      child: Row(
        children: [
          Flexible(
              flex: 45,
              child: Row(
                children: [
                  Flexible(flex: 15, child: _setsLabel(context)),
                  Flexible(flex: 15, child: _intensityLabel(context)),
                  Flexible(flex: 20, child: Container()),
                  Flexible(flex: 70, child: _exerciseLabel(context)),
                  Flexible(flex: 35, child: _equipmentLabel(context)),
                ],
              )),
          Flexible(flex: 55, child: _recruitmentLabels(context)),
        ],
      ),
    );
  }

  Widget _setsLabel(BuildContext context) => Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Sets',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: MediaQuery.sizeOf(context).width / 80,
            letterSpacing: 0.3,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );

  Widget _intensityLabel(BuildContext context) => Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '%1RM',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: MediaQuery.sizeOf(context).width / 80,
            letterSpacing: 0.3,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );

  Widget _exerciseLabel(BuildContext context) => Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Exercise',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: MediaQuery.sizeOf(context).width / 80,
            letterSpacing: 0.3,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );

  Widget _equipmentLabel(BuildContext context) => Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Equipment',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: MediaQuery.sizeOf(context).width / 80,
            letterSpacing: 0.3,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );

  Widget _recruitmentLabels(BuildContext context) => Row(
        children: ProgramGroup.values
            .map(
              (g) => Expanded(
                child: Container(
                  height: 40,
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
                                        .where(
                                            (e) => e.recruitment(g).volume > 0)
                                        .where((e) => e.id
                                            .toLowerCase()
                                            .contains(textEditingValue.text
                                                .toLowerCase()))
                                        .toList();
                                    opts.sort((a, b) => (b
                                            .recruitment(g)
                                            .volume)
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
                    child: Icon(
                      Icons.add_circle_outline,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      );
}
