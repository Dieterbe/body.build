import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ptc/data/programmer/exercises.dart';
import 'package:ptc/data/programmer/groups.dart';
import 'package:ptc/model/programmer/set_group.dart';
import 'package:ptc/model/programmer/settings.dart';
import 'package:ptc/model/programmer/workout.dart';
import 'package:ptc/ui/programmer/util_groups.dart';
import 'package:ptc/ui/programmer/widget/builder_setgroup.dart';
import 'package:ptc/ui/programmer/widget/builder_totals.dart';

class BuilderWorkoutWidget extends StatelessWidget {
  final Workout workout;
  final Settings setup;
  final Function(Workout? w) onChange;

  const BuilderWorkoutWidget(this.setup, this.workout, this.onChange,
      {super.key});
  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: workout.name);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.secondary),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(children: [
        Row(
          children: [
            const SizedBox(width: 10),
            const SizedBox(width: 45, child: Text('sets')),
            const SizedBox(width: 10),
            const SizedBox(width: 45, child: Text('%1RM')),
            const SizedBox(width: 80),
            Align(alignment: Alignment.center, child: const Text('Exercise')),
            Expanded(child: Container()),
            IconButton(
              onPressed: () {
                onChange(null);
              },
              icon: const Icon(Icons.delete),
              style: IconButton.styleFrom(
                  //  minimumSize: const Size(40, 40), -- used to work
                  ),
            ),
            SizedBox(
              width: 200,
              height: 36,
              child: Focus(
                child: TextField(
                  controller: nameController,
                  /*  onSubmitted: (v) {
                    onChange(workout.copyWith(name: v));
                  },
                  */
                ),
                onFocusChange: (focus) {
                  if (focus) {
                    return;
                  }
                  // when you leave the textfield, update the state
                  // if we update the state in the textFiled itself, the whole tree
                  // constantly refreshes and the editing experience is subbar
                  onChange(workout.copyWith(name: nameController.text));
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                onChange(workout.copyWith(setGroups: [
                  ...workout.setGroups,
                  SetGroup(setup.paramFinal.intensities.first)
                ]));
              },
              child: const Text('Add any set'),
            ),
            const Text('add set for muscle ->'),
            ...ProgramGroup.values.map((g) => Container(
                height: 30,
                // width: 30,
                color: bgColorForProgramGroup(g),
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
                            // ideally, user wants to preview the possible exercises within the program volume stats, so we could plonk them there
                            // in a special "WIP" section (e.g. hatched background)
                            // on the other hand, they also probably want to do a search to narrow it down to specific exercises, so they would
                            // need a text filter, and in the future maybe future filters
                            // putting all of that in the main UI seems a bit too much. let's just use a simple selection for now
                            Autocomplete<Ex>(
                              displayStringForOption: (e) => e.id,
                              optionsBuilder: (textEditingValue) {
                                final opts = exes
                                    .where((e) => e.recruitment(g) > 0)
                                    .where((e) => e.id.toLowerCase().contains(
                                        textEditingValue.text.toLowerCase()))
                                    .toList();
                                opts.sort((a, b) => (b.recruitment(g))
                                    .compareTo(a.recruitment(g)));
                                return opts;
                              },
                              onSelected: (e) {
                                context.pop();
                                onChange(workout.copyWith(setGroups: [
                                  ...workout.setGroups,
                                  SetGroup(setup.paramFinal.intensities.first,
                                      ex: e)
                                ]));
                              },
                            )
                          ],
                        );
                      },
                    );
                  },
                  child: const SizedBox(
                      width: 30, child: Icon(Icons.add, size: 16)),
                  //style: IconButton.styleFrom(
                  //  maximumSize: const Size(30, 30),
                  //),
                )))
          ],
        ),
        // TODO: support combo sets
        // TODO: support drag and dropping of sets, even across workouts
        ...workout.setGroups
            .map((s) => BuilderSetGroup(setup, s, (SetGroup? sNew) {
                  onChange(workout.copyWith(
                    setGroups: (sNew == null)
                        ? workout.setGroups.where((sg) => sg != s).toList()
                        : workout.setGroups
                            .map((sg) => sg == s ? sNew : sg)
                            .toList(),
                  ));
                })),
        BuilderTotalsWidget(workout.setGroups),
      ]),
    );
  }
}
