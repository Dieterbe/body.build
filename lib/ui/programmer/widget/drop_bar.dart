import 'package:flutter/material.dart';
import 'package:ptc/model/programmer/set_group.dart';
import 'package:ptc/model/programmer/workout.dart';
import 'package:ptc/ui/programmer/state/drag_state.dart';
import 'package:ptc/ui/programmer/widget/drag_target.dart';

class DropBar extends StatelessWidget {
  final Workout Function(Sets) onDrop;
  final Function(Workout) onChange;
  final Workout workout;
  final Color? colorInactive;
  final Color? colorActive;
  const DropBar(this.workout, this.onChange, this.onDrop,
      {super.key, this.colorInactive, this.colorActive});

  @override
  Widget build(BuildContext context) {
    return DragTargetWidget(
      workout,
      0,
      null,
      onDrop: onDrop,
      onChange: onChange,
      builder: (context, candidateData, rejectedData) {
        return ValueListenableBuilder<bool>(
          valueListenable: dragInProgressNotifier,
          builder: (context, isDragging, child) {
            final cInactive = colorInactive ?? Colors.transparent;
            final cActive = colorActive ??
                Theme.of(context).colorScheme.secondary.withValues(alpha: 0.5);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: isDragging ? cActive : cInactive,
              ),
              height: isDragging ? 32 : 8,
            );
          },
        );
      },
    );
  }
}
