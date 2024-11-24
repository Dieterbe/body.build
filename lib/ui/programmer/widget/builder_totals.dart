import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ptc/model/programmer/set_group.dart';
import 'package:ptc/data/programmer/groups.dart';
import 'package:ptc/ui/programmer/util_groups.dart';

import '../../../model/programmer/settings.dart';

class BuilderTotalsWidget extends StatelessWidget {
  final List<SetGroup> setGroups;
  final int multiplier;
  final Settings? setup; // to validate the totals against desired volumes

  const BuilderTotalsWidget(this.setGroups,
      {this.multiplier = 1, this.setup, super.key});

// return a map with for each program group, the volume, summed from all the exercises found in our sets
// volumes < cutoff are counted as 0
  (double, Map<ProgramGroup, double>) _compute(double cutoff) {
    var totals = setGroups.fold<Map<ProgramGroup, double>>(
        {for (var group in ProgramGroup.values) group: 0.0}, (totals, sg) {
      // Process each set in the SetGroup
      for (var set in sg.sets) {
        if (set.ex != null) {
          for (var group in ProgramGroup.values) {
            totals[group] = totals[group]! +
                (set.ex!.recruitment(group) >= cutoff
                    ? set.ex!.recruitment(group) * set.n
                    : 0.0);
          }
        }
      }
      return totals;
    });

    totals = totals.map((group, value) => MapEntry(group, value * multiplier));
    final maxVal = totals.values.reduce(max);
    return (maxVal, totals);
  }

  @override
  Widget build(BuildContext context) {
    final (maxVal, totals) = _compute(0.5);
    // to normalize the values, reducing the amount of vertical space needed if (some of) the volumes become high
    const limit = 2.0;

    return Column(
      children: [
        Row(children: [
          Expanded(child: Container()),
          // "bottom line"
          SizedBox(
              width: 40.0 * ProgramGroup.values.length + 36,
              child: const Divider(
                thickness: 2,
              )),
        ]),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Container()),
            Icon(Icons.add,
                size: 24, color: Theme.of(context).colorScheme.outline),
            const SizedBox(width: 10),
            ...ProgramGroup.values
                .map((g) => Stack(alignment: Alignment.bottomCenter, children: [
                      Container(
                        width: 40,
                        // "background" height.
                        // if maxVal < 1 -> should be 40
                        // if 1 < maxVal < limit: should be 40 * maxVal
                        // if maxVal > limit: should be 40 * limit
//                        height: max(40 * maxVal / limit, 40),
                        height: 40 * max(1, min(maxVal, limit)),
                        color: bgColorForProgramGroup(g),
                      ),
                      Container(
                        width: 40,
                        height: 40 *
                            (maxVal > limit
                                ? totals[g]! / maxVal * limit
                                : totals[g]!),
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ]))
          ],
        ),
        Row(
          children: [
            Expanded(child: Container()),
            ...ProgramGroup.values.map((g) => Container(
                  width: 40,
                  height: 40,
                  color: bgColorForProgramGroup(g),
                  child: Center(
                      child: Text(
                    totals[g]!.toStringAsFixed(1),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: (setup == null)
                          ? Colors.black
                          : (totals[g]! >=
                                  setup!.paramFinal
                                      .getSetsPerWeekPerMuscleGroupFor(g)
                              ? Colors.green
                              : Colors.red),
                    ),
                  )),
                ))
          ],
        )
      ],
    );
  }
}
