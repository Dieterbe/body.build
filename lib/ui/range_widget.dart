import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/icon_park_outline.dart';
import 'package:ptc/backend/movements.dart';
import 'package:ptc/ui/chart_widget.dart';
import 'package:ptc/ui/muscle_screen.dart';

class RangeWidget extends StatelessWidget {
  final ArticulationMovements am;

  const RangeWidget(
    this.am, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(builder: (context, constraints) {
        // for display purposes, we adjust the start and end such that we start at 0
        // this makes the following math more easy..probably
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
                  if (m.rangeStart == null || m.rangeEnd == null) {
                    return Column(
                      children: [
                        Text(m.muscle.nameWithHead(m.head)),
                        const Text('not enough range information known'),
                      ],
                    );
                  }
                  final muscleRangeEnd = m.rangeEnd! + offset;
                  final muscleRangeStart = m.rangeStart! + offset;
                  final normMuscleRangeEnd =
                      normWidth * (muscleRangeEnd / rangeEnd);
                  final normMuscleRangeStart =
                      normWidth * (muscleRangeStart / rangeEnd);
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
                      ElevatedButton(
                        onPressed: () => context.pushNamed(
                          MuscleScreen.routeName,
                          pathParameters: {"id": m.muscle.name},
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Iconify(IconParkOutline.muscle, size: 20),
                            Text(m.muscle.nameWithHead(m.head)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),
                      if (m.momentMax == null)
                        ChartWidget(
                          height: 32,
                          width: normWidth,
                          p1: normMuscleRangeStart,
                          p2: (normMuscleRangeStart + normMuscleRangeEnd) /
                              2, // estimate!
                          p3: normMuscleRangeEnd,
                        ),
                      const SizedBox(height: 16),

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
                      const SizedBox(height: 16),
                    ],
                  );
                }),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(am.rangeStart.toString()),
                    const Text('overall range'),
                    Text(am.rangeEnd.toString()),
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
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryFixedVariant),
                        const SizedBox(width: 8),
                        const Text('muscle inactive'),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            width: 16,
                            height: 16,
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer),
                        const SizedBox(width: 8),
                        const Text('muscle active'),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ChartWidget(
                            height: 16, width: 16, p1: 0, p2: 8, p3: 16),
                        const SizedBox(width: 8),
                        const Text('muscle moment arm curve'),
                      ],
                    )
                  ],
                ),
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
