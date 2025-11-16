import 'package:flutter/material.dart';
import 'package:bodybuild/model/dataset/movements.dart';
import 'package:bodybuild/ui/anatomy/widget/chart_widget.dart';
import 'package:bodybuild/ui/anatomy/colors.dart';
import 'package:bodybuild/ui/anatomy/widget/muscle_button.dart';

class RangeWidget extends StatelessWidget {
  final ArticulationMovements am;

  const RangeWidget(this.am, {super.key});

  @override
  Widget build(BuildContext context) {
    if (!am.hasRange) {
      return Container(
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...am.moves.map((m) {
                return Column(
                  children: [
                    MuscleButton(muscle: m.muscle, head: m.head),
                    const SizedBox(height: 8),
                    const Text('not enough range information known'),
                    // we might know the strength / momentMax. so maybe we can plot something...
                  ],
                );
              }),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          print('rangeStart ${am.rangeStart}, rangeEnd ${am.rangeEnd}');
          // for display purposes, we adjust the start and end such that we start at 0
          // this makes the following math more easy..probably
          // this should work for positive ranges, e.g. 45 to 90, -20 to 30
          // as well as negative ranges, e.g. 90 to 45 or 30 to -20
          // the new rangeStart is 0 and rangeEnd is either a positive or negative number
          // the muscles rangeStart, rangeEnd and momentMax will be adjusted with the same offset
          // since rangeStart is the most "far" value, all other values will either be only positive or only negative
          // note that all values used for plotting are divided by rangeEnd to "normalize" them, which means
          // negative numbers will divide by negative and become positive, so we can use them as width integers
          int offset = -am.rangeStart;
          final rangeEnd = am.rangeEnd + offset;

          final normWidth = constraints.maxWidth; // width for the full range

          print('range ${am.range} -> width $normWidth (normWidth)');

          return Container(
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ...am.moves.map((m) {
                    if (m.mo.rangeStart == null || m.mo.rangeEnd == null) {
                      return Column(
                        children: [
                          MuscleButton(muscle: m.muscle, head: m.head),
                          const SizedBox(height: 8),
                          const Text('not enough range information known'),
                        ],
                      );
                    }
                    double? normMuscleMomentMax;
                    if (m.mo.momentMax != null) {
                      final muscleMomentMax = m.mo.momentMax! + offset;
                      normMuscleMomentMax = normWidth * (muscleMomentMax / rangeEnd);
                    }
                    final muscleRangeEnd = m.mo.rangeEnd! + offset;
                    final muscleRangeStart = m.mo.rangeStart! + offset;
                    final normMuscleRangeEnd = normWidth * (muscleRangeEnd / rangeEnd);
                    final normMuscleRangeStart = normWidth * (muscleRangeStart / rangeEnd);
                    print('> $normMuscleRangeStart - $normMuscleRangeEnd - $normWidth');
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
                        MuscleButton(muscle: m.muscle, head: m.head),
                        const SizedBox(height: 8),
                        if (m.mo.momentMax == null)
                          ChartWidget(
                            height: m.mo.strength * 6,
                            width: normWidth,
                            p1: normMuscleRangeStart,
                            p2: (normMuscleRangeStart + normMuscleRangeEnd) / 2, // estimate!
                            p3: normMuscleRangeEnd,
                          ),
                        if (m.mo.momentMax != null)
                          ChartWidget(
                            height: m.mo.strength * 6,
                            width: normWidth,
                            p1: normMuscleRangeStart,
                            p2: normMuscleMomentMax!,
                            p3: normMuscleRangeEnd,
                          ),
                        const SizedBox(height: 4),

                        Stack(
                          children: [
                            // onSecondaryFixedVariant is also nice, lighter
                            segment(
                              normWidth,
                              Theme.of(context).colorScheme.onSecondaryFixedVariant,
                            ),
                            segment(
                              normMuscleRangeEnd,
                              //  Theme.of(context).colorScheme.onSecondaryContainer
                              colorActive,
                            ),
                            segment(
                              normMuscleRangeStart,
                              Theme.of(context).colorScheme.onSecondaryFixedVariant,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${am.rangeStart} °'),
                      const Text('overall range'),
                      Text('${am.rangeEnd} °'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Legend'),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            color: Theme.of(context).colorScheme.onSecondaryFixedVariant,
                          ),
                          const SizedBox(width: 8),
                          const Text('muscle inactive'),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(width: 16, height: 16, color: colorActive),
                          const SizedBox(width: 8),
                          const Text('muscle active'),
                        ],
                      ),
                      const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ChartWidget(height: 16, width: 16, p1: 0, p2: 8, p3: 16),
                          SizedBox(width: 8),
                          Text('muscle moment arm curve'),
                        ],
                      ),
                      const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(width: 24),
                          Flexible(
                            child: Text(
                              '(height corresponds to muscle strength for this movement)',
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Container segment(double width, Color color) {
  return Container(
    height: 16,
    width: width,
    decoration: BoxDecoration(color: color),
  );
}
