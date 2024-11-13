import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ptc/programming/ex_set.dart';
import 'package:ptc/programming/groups.dart';
import 'package:ptc/ui/programmer/groups.dart';

class TotalsWidget extends StatelessWidget {
  final List<ExSet> sets;
  const TotalsWidget(this.sets, {super.key});

// return a map with for each program group, the volume, summed from all the exercises found in our sets
// if any of the values exceeds `normalize`, we normalize wrt. to that value
// volumes < cutoff are counted as 0
  (double, Map<ProgramGroup, double>) _compute(
      double cutoff, double normalize) {
    final assignments =
        sets.where((s) => s.ex != null).map((s) => s.ex!.va.assign);
    final totals = assignments.fold<Map<ProgramGroup, double>>(
        {for (var group in ProgramGroup.values) group: 0.0},
        (totals, assign) => {
              for (var group in ProgramGroup.values)
                group: totals[group]! +
                    ((assign[group] ?? 0.0) >= cutoff ? assign[group]! : 0.0)
            });
    final maxVal = totals.values.reduce(max);
    if (maxVal <= normalize) {
      return (maxVal, totals);
    }
    // if maxVal is 6 and normalize is 3, we need to divide every value by 2
    // i.o.w. each value in totals needs to be divided by `maxVal` and multiplied by `normalize`
    return (
      normalize,
      Map.fromEntries(totals.entries
          .map((e) => MapEntry(e.key, (e.value / maxVal) * normalize)))
    );
  }

  @override
  Widget build(BuildContext context) {
    final (maxVal, totals) = _compute(0.5, 2);
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
                        height: max(40 * maxVal, 40),
                        color: bgColorForProgramGroup(g),
                      ),
                      Container(
                        width: 30,
                        height: 40 * totals[g]!,
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
