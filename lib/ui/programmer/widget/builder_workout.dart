import 'package:bodybuild/ui/programmer/widget/add_set_button.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:bodybuild/model/programmer/set_group.dart';
import 'package:bodybuild/model/programmer/settings.dart';
import 'package:bodybuild/model/programmer/workout.dart';
import 'package:bodybuild/ui/programmer/state/drag_state.dart';
import 'package:bodybuild/ui/programmer/widget/builder_totals.dart';
import 'package:bodybuild/ui/programmer/widget/builder_workout_sets_header.dart';
import 'package:bodybuild/ui/programmer/widget/drag_target.dart';
import 'package:bodybuild/ui/programmer/widget/draggable_setgroup.dart';
import 'package:bodybuild/ui/programmer/widget/drop_bar.dart';
import 'package:bodybuild/util.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

class BuilderWorkoutWidget extends StatelessWidget {
  final Workout workout;
  final Settings setup;
  final Function(Workout? w) onChange;

  const BuilderWorkoutWidget(this.setup, this.workout, this.onChange, {super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: workout.name);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      // looks like "around" the container
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4), // affects alignment
      child: Column(children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              // Left side: Name and frequency
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Name field
                  SizedBox(
                    width: 200,
                    child: Focus(
                      child: TextField(
                        controller: nameController,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          hintText: 'Workout name',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
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
                              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                              width: 2,
                            ),
                          ),
                        ),
                        onSubmitted: (value) {
                          onChange(workout.copyWith(name: value));
                        },
                      ),
                      onFocusChange: (focus) {
                        if (focus) return;
                        onChange(workout.copyWith(name: nameController.text));
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Frequency settings
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: DropdownButton<int>(
                      value: workout.timesPerPeriod,
                      underline: Container(),
                      items: List.generate(7, (i) => i + 1)
                          .map((i) => DropdownMenuItem(
                                value: i,
                                child: Text(i.toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    )),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          onChange(workout.copyWith(timesPerPeriod: value));
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('per',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      )),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: DropdownButton<int>(
                      value: workout.periodWeeks,
                      underline: Container(),
                      items: List.generate(4, (i) => i + 1)
                          .map((i) => DropdownMenuItem(
                                value: i,
                                child: Text(i == 1 ? 'week' : '$i weeks',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    )),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          onChange(workout.copyWith(periodWeeks: value));
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 4),
                  Tooltip(
                    message:
                        'This frequency will be used to correctly calculate the total sets for the program per week',
                    child: IconButton(
                      icon: Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                      constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Right side: Action buttons
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AddSetButton(
                    () async {
                      onChange(workout.copyWith(setGroups: [
                        ...workout.setGroups,
                        SetGroup([Sets(setup.paramFinal.intensities.first)])
                      ]));
                      await Posthog().capture(
                        eventName: 'AddSetButtonClicked',
                        properties: {
                          'muscle': 'any',
                          'setgroups': workout.setGroups.length,
                        },
                      );
                    },
                    isEmpty: workout.setGroups.isEmpty,
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      onChange(null);
                    },
                    icon: Icon(
                      Icons.delete_outline,
                      size: 20,
                      color: Theme.of(context).colorScheme.error.withValues(alpha: 0.8),
                    ),
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        BuilderWorkoutSetsHeader(
          workout,
          setup,
          onChange: onChange,
        ),
        //     const SizedBox(height: 3),
        //       const SizedBox(height: 3),
        ...workout.setGroups
            .mapIndexed((i, sg) => setGroupSection(context, setup, sg, workout, onChange))
            .insertBeforeBetweenAfter(
              // if you drop a set in between setgroups (or at the start or end),
              // it becomes a new setgroup
              (i) => DropBar(
                // colorInactive: Colors.cyan,
                colorActive: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3),
                workout,
                onChange,
                (Sets sNew) {
                  var newSetGroups = List<SetGroup>.from(workout.setGroups);
                  newSetGroups.insert(i, SetGroup([sNew]));
                  return workout.copyWith(setGroups: newSetGroups);
                },
              ),
            ),

        // SizedBox(height: 12)), // to separate combosets from each other
        // SizedBox(height: 3),

        // const SizedBox(height: 3),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: BuilderTotalsWidget([workout.copyWith(periodWeeks: 1, timesPerPeriod: 1)]),
        ),
      ]),
    );
  }
}

Widget setGroupSection(
  BuildContext context,
  Settings setup,
  SetGroup sg,
  Workout workout,
  Function(Workout? w) onChange,
) {
  if (sg.sets.length == 1) {
    // if this setgroup only contains 1 set,
    // then we can turn it into a comboset by dragging another set onto it
    return ValueListenableBuilder<bool>(
      valueListenable: dragInProgressNotifier,
      builder: (context, isDragging, child) {
        final widget = DraggableSets(
            setup, workout, sg, sg.sets.first, isDragging && sg.sets.length == 1, onChange);
        if (isDragging && sg.sets.length == 1) {
          return DragTargetWidget(
            workout,
            0,
            null,
            onChange: onChange,
            onDrop: (Sets sNew) => workout.copyWith(
                setGroups: workout.setGroups
                    .map((e) => (e == sg)
                        ? e.copyWith(sets: [
                            ...e.sets,
                            sNew,
                          ])
                        : e)
                    .toList()),
            builder: (context, candidateData, rejectedData) => widget,
          );
        } else {
          return widget;
        }
      },
    );
  }
  // if sets > 1, then we already have a comboset.
  // we want widget.insertBeforeBetweenAfter(dropbar) with dropbars to add a set
  // to the existing comboset in the correct spot.
  // dragging onto the set itself does nothing

  return Container(
    padding: const EdgeInsets.all(8.0),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
        width: 2,
      ),
    ),
    child: Stack(
      children: [
        const RotatedBox(
          quarterTurns: 1,
          child: Text(
            'COMBO',
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Column(
          children: sg.sets
              .mapIndexed<Widget>(
                  (i, sets) => DraggableSets(setup, workout, sg, sets, false, onChange))
              .insertBeforeBetweenAfter((i) => DropBar(
                    colorActive: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2),
                    workout,
                    onChange,
                    (Sets sNew) {
                      var newSets = List<Sets>.from(sg.sets);
                      newSets.insert(i, sNew);
                      return workout.copyWith(
                          setGroups: workout.setGroups
                              .map((e) => (e == sg) ? SetGroup(newSets) : e)
                              .toList());
                    },
                  ))
              .toList(),
        ),
      ],
    ),
  );
}
