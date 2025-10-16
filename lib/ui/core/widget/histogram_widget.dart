import 'dart:math';

import 'package:flutter/material.dart';

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

    final theme = Theme.of(context);
    final maxValue = data.values.reduce((a, b) => a > b ? a : b).toDouble();
    final sortedEntries = data.entries.toList()..sort((a, b) => a.key.compareTo(b.key));

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: containerPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...sortedEntries.map((e) {
            final barWidth = max(150 * (e.value / (maxValue == 0 ? 1 : maxValue)), 4.0);
            final isMaxValue = e.value == maxValue.toInt();

            return Padding(
              padding: rowPadding,
              child: Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      '${e.value} sets of ${e.key}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: isMaxValue ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 24,
                        width: barWidth,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.primary.withValues(alpha: 0.5),
                              theme.colorScheme.primary.withValues(alpha: 0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withValues(alpha: 0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: barWidth > 40
                            ? Text(
                                '${e.value}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
