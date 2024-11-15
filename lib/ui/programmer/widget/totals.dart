import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ptc/model/programmer/set_group.dart';
import 'package:ptc/data/programmer/groups.dart';
import 'package:ptc/ui/programmer/util_groups.dart';

class TotalsWidget extends StatelessWidget {
  final List<SetGroup> setGroups;
  const TotalsWidget(this.setGroups, {super.key});

// return a map with for each program group, the volume, summed from all the exercises found in our sets
// volumes < cutoff are counted as 0
  (double, Map<ProgramGroup, double>) _compute(double cutoff) {
    final totals =
        setGroups.where((s) => s.ex != null).fold<Map<ProgramGroup, double>>(
            {for (var group in ProgramGroup.values) group: 0.0},
            (totals, sg) => {
                  for (var group in ProgramGroup.values)
                    group: totals[group]! +
                        (sg.ex!.recruitment(group) >= cutoff
                            ? sg.ex!.recruitment(group) * sg.n
                            : 0.0)
                });
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
        Row(
          children: [
            Expanded(child: Container()),
            const Text(
              "Total volume\n(only counts volumes >=0.5)",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(width: 30),
            ...ProgramGroup.values
                .map((g) => Stack(alignment: Alignment.bottomCenter, children: [
                      Container(
                        width: 30,
                        // "background" height.
                        // if maxVal < 1 -> should be 40
                        // if 1 < maxVal < limit: should be 40 * maxVal
                        // if maxVal > limit: should be 40 * limit
//                        height: max(40 * maxVal / limit, 40),
                        height: 40 * max(1, min(maxVal, limit)),
                        color: bgColorForProgramGroup(g),
                      ),
                      Container(
                        width: 30,
                        height: 40 *
                            (maxVal > limit
                                ? totals[g]! / maxVal * limit
                                : totals[g]!),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ]))
          ],
        ),
        Row(
          children: [
            Expanded(child: Container()),
            ...ProgramGroup.values.map((g) => Container(
                  width: 30,
                  height: 40,
                  color: bgColorForProgramGroup(g),
                  child: totals[g]! == 0
                      ? const Offstage()
                      : Center(
                          child: Text(
                          totals[g]!.toStringAsFixed(1),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        )),
                ))
          ],
        )
      ],
    );
  }
}
