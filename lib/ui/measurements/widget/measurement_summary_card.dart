import 'package:bodybuild/data/measurements/measurement_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class MeasurementSummaryCard extends ConsumerWidget {
  const MeasurementSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final measurementsAsync = ref.watch(measurementManagerProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return measurementsAsync.when(
      data: (data) {
        final measurements = data.measurements;
        if (measurements.isEmpty) {
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: InkWell(
              onTap: () => context.goNamed('measurements'),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.monitor_weight, color: colorScheme.primary, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Start Tracking Weight',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Log your first measurement',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final movingAvg7d = data.movingAverage7Day;
        if (movingAvg7d.isEmpty) return const SizedBox.shrink();

        // Use the most recent 7-day moving average
        final latestAvg = movingAvg7d.last;
        final latestAvgValue = latestAvg.value;

        final dateFormat = DateFormat('MMM d');

        // Calculate trend: delta between last 7d avg and 7d avg from at least a week ago
        String? trendText;
        IconData? trendIcon;
        Color? trendColor;

        final weekAgo = latestAvg.timestamp.subtract(const Duration(days: 7));
        final olderAvg = movingAvg7d.lastWhere(
          (avg) => avg.timestamp.isBefore(weekAgo) || avg.timestamp.isAtSameMomentAs(weekAgo),
          orElse: () => movingAvg7d.first,
        );

        // Only show trend if we have data from at least a week ago
        if (olderAvg.timestamp.isBefore(weekAgo) || olderAvg.timestamp.isAtSameMomentAs(weekAgo)) {
          final diff = latestAvgValue - olderAvg.value;

          if (diff.abs() > 0.1) {
            // Only show trend if difference is significant
            trendText = '${diff > 0 ? '+' : ''}${diff.toStringAsFixed(1)} kg';
            trendIcon = diff > 0 ? Icons.trending_up : Icons.trending_down;
            trendColor = diff > 0 ? Colors.orange : Colors.green;
          }
        }

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: InkWell(
            onTap: () => context.goNamed('measurements'),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.monitor_weight, color: colorScheme.primary, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Weight',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (trendIcon != null && trendText != null)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: trendColor?.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(trendIcon, size: 14, color: trendColor),
                                    const SizedBox(width: 4),
                                    Text(
                                      trendText,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: trendColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              '${latestAvgValue.toStringAsFixed(1)} kg',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '• ${dateFormat.format(latestAvg.timestamp)}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
