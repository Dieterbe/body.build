import 'package:flutter/material.dart';
import 'package:ptc/model/programmer/set_group.dart';
import 'package:ptc/model/programmer/workout.dart';

class DragTargetWidget extends StatelessWidget {
  final Workout workout;
  final int pos;
  final SetGroup? s;
  final bool onSet;
  final Function(Workout) onChange;
  final DragTargetBuilder builder;

  const DragTargetWidget(this.workout, this.pos, this.s, this.onSet,
      {required this.onChange, required this.builder, super.key});

  @override
  Widget build(BuildContext context) {
    return DragTarget<MapEntry<Workout, SetGroup>>(
      key: ValueKey(MapEntry(workout, s)),
      onWillAcceptWithDetails: (details) {
        return details.data.value != s;
      },
      onAcceptWithDetails: (details) {
        final sourceWorkout = details.data.key;
        final draggedSet = details.data.value;

        final items = List<SetGroup>.from(workout.setGroups);
        var insertPos = pos;

        if (sourceWorkout == workout) {
          // Reordering within same workout: first remove the original
          final oldIndex = items.indexOf(draggedSet);
          items.removeAt(oldIndex);
          // All elements after the removed element are now at an index one lower.
          // If the removed element was before our 'insertPos', we need to adust
          // 'insertPos' accordingly
          if (oldIndex <= insertPos) {
            insertPos -= 1;
          }
        }
        items.insert(insertPos, draggedSet);
        onChange(workout.copyWith(setGroups: items));
      },
      builder: builder,
    );
  }
}
