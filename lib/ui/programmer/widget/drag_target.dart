import 'package:flutter/material.dart';
import 'package:bodybuild/model/programmer/set_group.dart';
import 'package:bodybuild/model/programmer/workout.dart';

class DragTargetWidget extends StatelessWidget {
  final Workout workout;
  final int pos;
  final Sets? reject;
  final Workout Function(Sets)
      onDrop; // note: callbacks receive a *copy* of the original set
  final Function(Workout) onChange;
  final DragTargetBuilder builder;

  const DragTargetWidget(this.workout, this.pos, this.reject,
      {required this.onDrop,
      required this.onChange,
      required this.builder,
      super.key});

  @override
  Widget build(BuildContext context) {
    return DragTarget<MapEntry<Workout, Sets>>(
      key: ValueKey(MapEntry(workout, reject)),
      onWillAcceptWithDetails: (details) {
        return (reject == null || details.data.value != reject);
      },
      onAcceptWithDetails: (details) {
        final draggedSet = details.data.value;

        // give the callback a *copy* of the dragged set, which they can use
        // to modify the workout (e.g. insert the set somewhere) ...
        final workout = onDrop(draggedSet.copyWith());
        // ... so that we can then update the state to remove the original set from
        // its original location
        onChange(
          workout.copyWith(
            setGroups: workout.setGroups
                .map((sg) => sg.copyWith(
                    sets: sg.sets.where((s) => s != draggedSet).toList()))
                .where((sg) => sg.sets.isNotEmpty)
                .toList(),
          ),
        );
      },
      builder: builder,
    );
  }
}
