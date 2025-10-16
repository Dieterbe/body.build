import 'dart:math';

import 'package:flutter/material.dart';

// Note: this is very similar to the core HistogramWidget, but a bit of a different design
// at some point, we should probably merge the two
class HistogramWidget extends StatelessWidget {
  final Map<int, int> data;
  final EdgeInsets rowPadding;
  final EdgeInsets containerPadding;

  const HistogramWidget({
    super.key,
    required this.data,
    this.rowPadding = const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    this.containerPadding = const EdgeInsets.all(8),
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    final maxValue = data.values.reduce((a, b) => a > b ? a : b).toDouble();
    final sortedEntries = data.entries.toList()..sort((a, b) => a.key.compareTo(b.key));

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableHeight = constraints.maxHeight - containerPadding.vertical;

        // if there's only 1 bar, we wouldn't want it to take up all vertical space, so for
        // height calculation purpose, pretend there's at least 2.5 bars
        final assumeNum = max(sortedEntries.length, 2.5);
        final barHeight = (availableHeight - (assumeNum) * rowPadding.vertical) / assumeNum;

        // make sure text widget is not taller than the bar. this is a bit rough but seems to work
        final fontSize = 2 * barHeight / 3;
        // make sure we have consistent width for all text widgets above each other
        // also a bit rough but seems to work
        final textWidth = fontSize * 6;

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: containerPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...sortedEntries.map((e) {
                return Padding(
                  padding: rowPadding,
                  child: Row(
                    children: [
                      SizedBox(
                        width: textWidth,
                        child: Align(
                          // e.g. "12 sets of 3" and "2 sets of 5" should correspond visually
                          // it's more likely that num sets > 10 than the num of muscle groups
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${e.value} sets of ${e.key}',
                            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        height: barHeight,
                        width: (constraints.maxWidth - textWidth - 40) * (e.value / maxValue),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
