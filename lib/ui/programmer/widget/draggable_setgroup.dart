import 'package:flutter/material.dart';
import 'package:ptc/model/programmer/set_group.dart';
import 'package:ptc/model/programmer/settings.dart';
import 'package:ptc/model/programmer/workout.dart';
import 'package:ptc/ui/programmer/state/drag_state.dart';
import 'package:ptc/ui/programmer/widget/builder_setgroup.dart';

class DraggableSetGroup extends StatelessWidget {
  final Workout workout;
  final SetGroup s;
  final Settings setup;
  final bool isDragging;
  final Function(Workout) onChange;
  const DraggableSetGroup(
      this.setup, this.workout, this.s, this.isDragging, this.onChange,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final builderSetGroup = BuilderSetGroup(
      setup,
      s,
      (SetGroup? sNew) {
        onChange(workout.copyWith(
            setGroups: (sNew == null)
                ? workout.setGroups.where((sg) => sg != s).toList()
                : workout.setGroups.map((sg) => sg == s ? sNew : sg).toList()));
      },
    );

    return Container(
      decoration: isDragging
          ? BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                width: 2,
                style: BorderStyle.solid,
              ),
            )
          : null,
      child: Draggable<MapEntry<Workout, SetGroup>>(
        data: MapEntry(workout, s),
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
            width: MediaQuery.of(context).size.width * 0.95,
            color: Theme.of(context).colorScheme.surface,
            child: builderSetGroup,
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
          dragInProgressNotifier.value = false;

          onChange(workout.copyWith(
            setGroups: workout.setGroups.where((sg) => sg != s).toList(),
          ));
        },
        child: builderSetGroup,
      ),
    );
  }
}
