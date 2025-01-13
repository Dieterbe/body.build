import 'package:flutter/material.dart';
import 'package:bodybuild/data/anatomy/articulations.dart';
import 'package:bodybuild/data/anatomy/muscles.dart';
import 'package:bodybuild/ui/anatomy/widget/articulation_button.dart';

class InsufficiencyWidget extends StatelessWidget {
  const InsufficiencyWidget(
      {super.key, required this.insufficiency, this.articulation});
  final Insufficiency insufficiency;
  // the articulation we may be looking at, disables nav
  final Articulation? articulation;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Conditions:',
            style: TextStyle(fontWeight: FontWeight.bold)),
        ...insufficiency.factors.map((i) => Row(
              children: [
                Text(i.degrees == 361 ? 'max ° ' : '${i.degrees}° '),
                ArticulationButton(i.articulation,
                    nav: i.articulation != articulation),
              ],
            )),
        if (insufficiency.comment != null)
          const Text('Comment', style: TextStyle(fontWeight: FontWeight.bold)),
        if (insufficiency.comment != null) Text('(${insufficiency.comment!})'),
      ],
    );
  }
}
