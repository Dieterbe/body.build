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
        DragTarget<MapEntry<Workout, SetGroup>>(
          onWillAcceptWithDetails: (details) => true,
          onAcceptWithDetails: (details) {
            onChange(workout.copyWith(setGroups: [details.data.value]));
          },
          builder: (context, candidateData, rejectedData) {
            return ValueListenableBuilder<bool>(
              valueListenable: dragInProgressNotifier,
              builder: (context, isDragging, child) {
                return BuilderWorkoutSetsHeader(
                  workout,
                  setup,
                  // only apply the decoration when the workout is empty
                  // this makes it clear that you can drag a set to the workout
                  // to add it. However, when the workout does have sets,
                  // it looks a bit weird to do this, so in that case we don't
                  // do the decoration. but the target is still useful so that
                  // users don't have to be super precise with where they drop,
                  // as you need to be really precise otherwise.
                  // also, we similarly don't decorate the bottom target.
                  (isDragging && workout.setGroups.isEmpty),
                  onChange: onChange,
                );
              },
            );
          },
        ),
        Column(
          children: [
            ...workout.setGroups.mapIndexed((i, s) {
              return Column(
                children: [
                  DragTargetWidget(workout, i, s, false, onChange: onChange,
                      builder: (context, candidateData, rejectedData) {
                    return ValueListenableBuilder<bool>(
                      valueListenable: dragInProgressNotifier,
                      builder: (context, isDragging, child) {
                        return DragTargetWidget(workout, i, s, true,
                            onChange: onChange,
                            builder: (context, candidateData, rejectedData) {
                          return DraggableSetGroup(
                              setup, workout, s, isDragging, onChange);
                        });
                      },
                    );
                  }),
                ],
              );
            }),
            // Add drop target for the end of the list, in case you want to add a set as the very last one
            // we don't want to make a appear a new region to drag onto, as that would waste space
            // and also shift the UI arround, which is annoying.
            // instead, we can just use the totals widget as the target. but we don't decorate it,
            // since that would look a bit weird
            DragTargetWidget(
              workout,
              workout.setGroups.length,
              null,
              false,
              onChange: onChange,
              builder: (context, candidateData, rejectedData) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: BuilderTotalsWidget(workout.setGroups),
                );
              },
            ),
          ],
        ),
      ]),
    );
  }
}
