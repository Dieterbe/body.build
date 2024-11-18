import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ptc/data/programmer/exercises.dart';
import 'package:ptc/data/programmer/groups.dart';
import 'package:ptc/model/programmer/set_group.dart';
import 'package:ptc/model/programmer/settings.dart';
import 'package:ptc/model/programmer/workout.dart';
import 'package:ptc/ui/programmer/util_groups.dart';
import 'package:ptc/ui/programmer/widget/add_set_button.dart';
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Column(children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Expanded(child: Container()),
              SizedBox(
                width: 200,
                child: Focus(
                  child: TextField(
                    controller: nameController,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      hintText: 'Workout name',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.5),
                      ),
                      filled: true,
                      fillColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                    ),
                    onSubmitted: (value) {
                      onChange(workout.copyWith(name: value));
                    },
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
              IconButton(
                onPressed: () {
                  onChange(null);
                },
                icon: Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: Theme.of(context).colorScheme.error.withOpacity(0.8),
                ),
                style: IconButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              Expanded(child: Container()),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                    SetGroup(setup.paramFinal.intensities.first)
                  ]));
                },
              ),
              const SizedBox(width: 16),
              Text(
                'Add set for muscle',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  letterSpacing: 0.3,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
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
                                    return exes
                                        .where((e) => e.id
                                            .toLowerCase()
                                            .contains(textEditingValue.text
                                                .toLowerCase()))
                                        .toList();
                                  },
                                  onSelected: (Ex e) {
                                    onChange(workout.copyWith(setGroups: [
                                      ...workout.setGroups,
                                      SetGroup(
                                          setup.paramFinal.intensities.first)
                                    ]));
                                    context.pop();
                                  }),
                            ],
                          );
                        },
                      );
                    },
                    child: const SizedBox(
                        width: 30, child: Icon(Icons.add, size: 16)),
                  ),
                ),
              ),
            ],
          ),
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: BuilderTotalsWidget(workout.setGroups),
        ),
      ]),
    );
  }
}
