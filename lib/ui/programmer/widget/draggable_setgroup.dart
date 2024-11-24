import 'package:flutter/material.dart';
import 'package:ptc/model/programmer/set_group.dart';
import 'package:ptc/model/programmer/settings.dart';
import 'package:ptc/model/programmer/workout.dart';
import 'package:ptc/ui/programmer/state/drag_state.dart';
import 'package:ptc/ui/programmer/widget/builder_sets.dart';

class DraggableSets extends StatelessWidget {
  final Workout workout;
  final SetGroup sg;
  final Sets sets;
  final Settings setup;
  final bool isDragging;
  final bool hasNewComboButton;
  final Function(Workout) onChange;
  const DraggableSets(this.setup, this.workout, this.sg, this.sets,
      this.isDragging, this.hasNewComboButton, this.onChange,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final builderSets = BuilderSets(setup, sets, hasNewComboButton, (sNew) {
      if (sNew == null && sg.sets.length == 1) {
        // special case: if sNew needs to be removed, and it's the only one in the setgroup,
        // then the whole setGroup should be deleted
        onChange(workout.copyWith(
            setGroups: workout.setGroups.where((e) => (e != sg)).toList()));
        return;
      }
      final SetGroup sg2;
      if (sNew == null) {
        // remove this element from the setGroup:
        sg2 = SetGroup(
          sg.sets.where((s) => (s != sets)).toList(),
        );
      } else {
        sg2 = SetGroup(
          sg.sets.map((s) => (s == sets) ? sNew : s).toList(),
        );
      }
      onChange(workout.copyWith(
          setGroups:
              workout.setGroups.map((e) => (e == sg) ? sg2 : e).toList()));
    });

    return Container(
      /*  decoration: isDragging
          ? BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                width: 2,
                style: BorderStyle.solid,
              ),
            )
          : null, */
      child: Draggable<MapEntry<Workout, Sets>>(
        data: MapEntry(workout, sets),
        onDragStarted: () {
          dragInProgressNotifier.value = true;
        },
        onDragEnd: (_) {
          dragInProgressNotifier.value = false;
        },
        onDraggableCanceled: (_, __) {
          dragInProgressNotifier.value = false;
        },
        feedback: Material(
          elevation: 4,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            color: Theme.of(context).colorScheme.surface,
            child: builderSets,
          ),
        ),
        childWhenDragging: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onDragCompleted: () {
          // Remove from this workout when successfully dropped elsewhere
          // TODO: i think this means we can delete twice, if it's within same workout
          // then destination DragTarget also deletes
          dragInProgressNotifier.value = false;

          onChange(workout.copyWith(
            setGroups:
                workout.setGroups.where((sg) => sg != sets).toList(), // FIXME
          ));
        },
        child: builderSets,
      ),
    );
  }
}
