import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ptc/backend/movements.dart';
import 'package:ptc/ui/chart_widget.dart';
import 'package:ptc/util.dart';

class RangeWidget extends StatelessWidget {
  final List<Movement> movements;

  const RangeWidget({
    super.key,
    required this.movements,
  });

  @override
  Widget build(BuildContext context) {
    final rangeStarts =
        movements.map((m) => m.rangeBegin).whereType<int>().toList();
    final rangeEnds =
        movements.map((m) => m.rangeEnd).whereType<int>().toList();
    if (rangeStarts.length == 0 && rangeEnds.length == 0) {
      return Text('could not determine range (need 1 start and 1 end)');
    }
    final rangeStart = rangeStarts.fold(1000, min);
    final rangeEnd = rangeEnds.fold(-1000, max);
    assert(rangeEnd > rangeStart);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(builder: (context, constraints) {
        // for display purposes, we adjust the start and end such that we start at 0
        // this makes the following math more easy
        int offset = -rangeStart;

        final rangeStart2 = rangeStart + offset;
        final rangeEnd2 = rangeEnd + offset;
        final normWidth = constraints
            .maxWidth; // the width for the full range (e.g. rangeEnd2)
        print('normWidth $normWidth');
        print(' $rangeStart2 - $rangeEnd2');

        return Container(
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ...movements.map((m) {
                  if (m.rangeBegin == null || m.rangeEnd == null) {
                    return Column(
                      children: [
                        Text(m.muscle.nameWithHead(m.head)),
                        const Text('not enough range information known'),
                      ],
                    );
                  }
                  final muscleRangeEnd2 = m.rangeEnd! + offset;
                  final muscleRangeStart2 = m.rangeBegin! + offset;
                  final normMuscleRangeEnd =
                      normWidth * (muscleRangeEnd2 / rangeEnd2);
                  final normMuscleRangeStart =
                      normWidth * (muscleRangeStart2 / rangeEnd2);
                  print(
                      '> $normMuscleRangeStart - $normMuscleRangeEnd - $normWidth');
                  return Column(
                    children: [
                      // plot something like this, with $ indicating the range here
                      //         muscle name
                      // |-------$$$$$$$$$$$$----|
                      //         ^          ^    ^
                      //         |          |    normWidth
                      //         |           normMuscleRangeEnd
                      //         normMuscleRangeStart
                      // if we know the max moment, then draw a triangle pointing it out
                      Text(m.muscle.nameWithHead(m.head)),
                      if (m.momentMax == null)
                        ChartWidget(
                          height: 32,
                          width: normWidth,
                          p1: normMuscleRangeStart,
                          p2: (normMuscleRangeStart + normMuscleRangeEnd) /
                              2, // estimate!
                          p3: normMuscleRangeEnd,
                        ),
                      SizedBox(height: 16),

                      Stack(children: [
                        // onSecondaryFixedVariant is also nice, lighter
                        segment(
                            normWidth,
                            Theme.of(context)
                                .colorScheme
                                .onSecondaryFixedVariant),
                        segment(normMuscleRangeEnd,
                            Theme.of(context).colorScheme.onSecondaryContainer),
                        segment(
                            normMuscleRangeStart,
                            Theme.of(context)
                                .colorScheme
                                .onSecondaryFixedVariant),
                      ]),
                      SizedBox(height: 16),
                    ],
                  );
                }),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(rangeStart.toString()),
                    Text('overall range'),
                    Text(rangeEnd.toString()),
                  ],
                ),
                SizedBox(height: 16),
                Text('Legend'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: 16,
                        height: 16,
                        color: Theme.of(context)
                            .colorScheme
                            .onSecondaryFixedVariant),
                    SizedBox(
                      width: 16,
                    ),
                    Text('muscle inactive'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: 16,
                        height: 16,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer),
                    SizedBox(
                      width: 16,
                    ),
                    Text('muscle active'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChartWidget(height: 16, width: 16, p1: 0, p2: 8, p3: 16),
                    SizedBox(width: 16),
                    Text('muscle moment arm curve'),
                  ],
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}

Container segment(double width, Color color) {
  return Container(
    height: 16,
    width: width,
    decoration: BoxDecoration(
      color: color,
    ),
  );
}
