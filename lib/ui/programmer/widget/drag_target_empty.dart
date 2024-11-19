import 'package:flutter/material.dart';
import 'package:ptc/ui/programmer/state/drag_state.dart';
import 'package:ptc/ui/programmer/widget/set_group_landing_zone.dart';

class DragTargetWidgetEmpty extends StatelessWidget {
  final bool haveCandidate;
  const DragTargetWidgetEmpty(this.haveCandidate, {super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: dragInProgressNotifier,
      builder: (context, isDragging, child) {
        if (!isDragging) {
          return Container();
        }
        return const SetGroupLandingZone();
      },
    );
  }
}
