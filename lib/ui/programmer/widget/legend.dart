import 'package:flutter/material.dart';
import 'package:bodybuild/ui/programmer/widget/widgets.dart';

/* 
// this is unused for now (in the program builder)
// our legend doesn't render well and is not particularly useful
// (it gets confusing because the volume totals don't follow the same color scheme)
// so let's just disable it for now.
// better would be to have tooltips over the musclemarks, but they don't work well on flutter web - they don't respond to clicks
*/
class Legend extends StatelessWidget {
  const Legend({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      const Spacer(),
      const Text('Legend'),
      const SizedBox(width: 30),
      const Text('0.25'),
      const SizedBox(width: 4),
      muscleMark(0.25, context),
      const SizedBox(width: 30),
      const Text('0.5'),
      const SizedBox(width: 4),
      muscleMark(0.5, context),
      const SizedBox(width: 30),
      const Text('0.75'),
      const SizedBox(width: 4),
      muscleMark(0.75, context),
      const SizedBox(width: 30),
      const Text('1.0'),
      const SizedBox(width: 4),
      muscleMark(1.0, context),
    ]);
  }
}
