import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:ptc/model/programmer/set_group.dart';
import 'package:ptc/model/programmer/settings.dart';
import 'package:ptc/model/programmer/workout.dart';
import 'package:ptc/ui/programmer/state/drag_state.dart';
import 'package:ptc/ui/programmer/widget/builder_totals.dart';
import 'package:ptc/ui/programmer/widget/builder_workout_sets_header.dart';
import 'package:ptc/ui/programmer/widget/drag_target.dart';
import 'package:ptc/ui/programmer/widget/draggable_setgroup.dart';

class BuilderWorkoutWidget extends StatelessWidget {
  final Workout workout;
  final Settings setup;
  final Function(Workout? w) onChange;

  const BuilderWorkoutWidget(this.setup, this.workout, this.onChange,
      {super.key});
  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: workout.name);
    return ValueListenableBuilder<bool>(
      // TODO: we can probably add this into DragTargetWidget's callback closure
      valueListenable: dragInProgressNotifier,
      builder: (context, isDragging, child) {
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
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    width: 1,
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
                      color:
                          Theme.of(context).colorScheme.error.withOpacity(0.8),
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
            BuilderWorkoutSetsHeader(
              workout,
              setup,
              onChange: onChange,
            ),
            DragTargetWidget(
              workout,
              0,
              null,
              onChange: (Sets sNew) {
                onChange(workout.copyWith(setGroups: [
                  SetGroup([sNew]),
                  ...workout.setGroups
                ]));
              },
              builder: (context, candidateData, rejectedData) {
                return Text(
                    'HEAD WIDGET. workout -> workout.setgroups([set, ...oldstuff]). drag in progress? $isDragging');
              },
            ),
            ...workout.setGroups.mapIndexed((i, sg) => setGroupSection(
                setup,
                sg,
                i == 0,
                i == workout.setGroups.length - 1,
                isDragging,
                workout,
                onChange)),
            DragTargetWidget(
              workout,
              0,
              null,
              onChange: (Sets sNew) {
                onChange(workout.copyWith(setGroups: [
                  ...workout.setGroups,
                  SetGroup([sNew])
                ]));
              },
              builder: (context, candidateData, rejectedData) {
                return Text(
                    'TAIL WIDGET. workout -> workout.setgroups([...oldstuff, set]). drag in progress? $isDragging');
              },
            ),
            BuilderTotalsWidget(workout.setGroups),
          ]),
        );
      },
    );
  }
}

Widget setGroupSection(Settings setup, SetGroup sg, bool isFirst, bool isLast,
    bool isDragging, Workout workout, Function(Workout? w) onChange) {
  return Column(
    children: [
      Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: (sg.sets.length > 1) ? Colors.red : Colors.green,
            width: 2,
          ),
        ),
        child: Column(children: [
          for (var (index, sets) in sg.sets.indexed) ...[
            // if we only contain a single set, then we just need a widget to drop a set into a new setgroup before us.
            // if we are the first setgroup,then the HEAD widget already takes care of this
            // if length > 1, then, we want a widget which drops a set into the same setgroup, before this set.
            if (!isFirst || sg.sets.length > 1)
              DragTargetWidget(
                workout,
                0,
                null,
                onChange: (Sets sNew) {
                  if (sg.sets.length == 1) {
                    onChange(workout.copyWith(setGroups: [
                      SetGroup([sNew]),
                      ...workout.setGroups
                    ]));
                    return;
                  }
                  onChange(workout.copyWith(
                      setGroups: workout.setGroups
                          .map((e) => (e == sg)
                              ? SetGroup([
                                  ...e.sets.sublist(0, index),
                                  sNew,
                                  ...e.sets.sublist(index)
                                ])
                              : e)
                          .toList()));
                  return;
                },
                builder: (context, candidateData, rejectedData) {
                  return Text('dropperrr PRE drag in progress? $isDragging');
                },
              ),

            DraggableSets(setup, workout, sg, sets, isDragging,
                isDragging && sg.sets.length == 1, onChange),

            // if we only contain a single set, then we just need a widget to drop a set into a new setgroup after us.
            // if we are the last setgroup,then the TAIL widget will take care of this
            // if length > 1, then, we want a widget which drops a set into the same setgroup, after this set.
            if (!isLast || sg.sets.length > 1)
              DragTargetWidget(
                workout,
                0,
                null,
                onChange: (Sets sNew) {
                  if (sg.sets.length == 1) {
                    onChange(workout.copyWith(setGroups: [
                      ...workout.setGroups,
                      SetGroup([sNew]),
                    ]));
                    return;
                  }
                  onChange(workout.copyWith(
                      setGroups: workout.setGroups
                          .map((e) => (e == sg)
                              ? SetGroup([
                                  ...e.sets.sublist(0, index + 1),
                                  sNew,
                                  ...e.sets.sublist(index + 1)
                                ])
                              : e)
                          .toList()));
                  return;
                },
                builder: (context, candidateData, rejectedData) {
                  return Text('dropperrr POST drag in progress? $isDragging');
                },
              )
          ]
        ]),
      ),
    ],
  );
}
