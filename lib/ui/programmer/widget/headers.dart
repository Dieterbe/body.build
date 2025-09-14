import 'dart:math';

import 'package:flutter/material.dart';
import 'package:bodybuild/data/programmer/groups.dart';
import 'package:bodybuild/ui/programmer/util_groups.dart';

Widget headers() {
  // when column headers are horizontal, they take too much space
  // when they are vertical, you have to twist your neck to read them
  // so we want 45 degree rotation to make them more compact horizontally, but still readable.
  // However:
  // * RotationTransition(turns: AlwaysStoppedAnimation(7/8)) and Transform.rotate keep the original width (making the rotation pointless)
  // * RotatedBox uses width/height afer rotation, during layout - perfect for what we need - but only supports 90degree rotations, not 45.
  // * OverflowBox(Transform.rotate) results in errors
  // So the solution is to first vertically rotate the with RotatedBox, so the layout engine uses the constraints of tall&narrow text boxes,
  // and after layouting, turn it by 45 degrees to make it more legible
//
// hack: create a stack of (invisible) text boxes on top of each other
// the resulting widget will have the width of whichever is the longest of the text boxes
// therefore, by stacking each entry on top of this stack, they all have the same length
// and therefore, consistent rotation origins
  /* final all = ProgramGroup.values
      .map((e) => Opacity(
            opacity: 0,
            child: Text(
              e.name.camelToTitle(),
            ),
          ))
      .toList();
      */
  // better hack which reduces the number of widgets: just manually define the longest one...
  const dummy = Opacity(
    opacity: 0,
    child: HeaderLabel('Ham Long H. & semis'),
  );
  return Transform.translate(
    offset: const Offset(0, -10), // because we pivot around bottom center, raise text up a bit
    child: Row(
        children: ProgramGroup.values
            .map((e) => Expanded(
                  child: Transform.rotate(
                      alignment: Alignment.bottomCenter,
                      angle: pi / 4,
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: Container(
                          color: bgColorForProgramGroup(e),
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Stack(children: [
                              HeaderLabel(e.displayName),
                              dummy,
                            ]),
                          ),
                        ),
                      )),
                ))
            .toList()),
  );
}

class HeaderLabel extends StatelessWidget {
  final String title;
  const HeaderLabel(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: MediaQuery.sizeOf(context).width / 100,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.3,
      ),
    );
  }
}
