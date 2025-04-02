import 'package:flutter/material.dart';

class HistogramWidget extends StatelessWidget {
  final Map<int, int> data;
  final String? title;
  final String? xAxisLabel;
  final double barHeight;
  final double maxWidth;
  final EdgeInsets padding;

  const HistogramWidget({
    super.key,
    required this.data,
    this.title,
    this.xAxisLabel,
    this.barHeight = 24,
    this.maxWidth = 200,
    this.padding = const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    final maxValue = data.values.reduce((a, b) => a > b ? a : b).toDouble();
    final sortedEntries = data.entries.toList()..sort((a, b) => a.key.compareTo(b.key));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
        ],
        ...sortedEntries.map((e) {
          return Padding(
            padding: padding,
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  child: Text(
                    '${e.key}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        height: barHeight,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Container(
                        height: barHeight,
                        width: maxWidth * (e.value / maxValue),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Positioned(
                        right: 8,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: Text(
                            e.value.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
        if (xAxisLabel != null) ...[
          const SizedBox(height: 8),
          Text(
            xAxisLabel!,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ],
    );
  }
}
