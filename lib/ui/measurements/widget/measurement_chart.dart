import 'package:bodybuild/model/measurements/measurement.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MeasurementChart extends StatelessWidget {
  final List<Measurement> measurements; // assumed to be sorted ASC
  final List<MovingAveragePoint> movingAverage; // assumed to be sorted ASC
  final double? periodChange;
  final Duration changePeriod;
  const MeasurementChart({
    super.key,
    required this.measurements,
    this.movingAverage = const [],
    this.periodChange,
    required this.changePeriod,
  });

  @override
  Widget build(BuildContext context) {
    if (measurements.isEmpty) {
      return const SizedBox.shrink();
    }

    // Use timestamps for X-axis to properly handle sparse data
    final firstTimestamp = measurements.first.timestamp.millisecondsSinceEpoch.toDouble();

    // Convert all measurements to kg for consistent chart display
    final spots = measurements.map((measurement) {
      final valueInKg = measurement.unit.toKg(measurement.value);
      final x = measurement.timestamp.millisecondsSinceEpoch.toDouble() - firstTimestamp;
      return FlSpot(x, valueInKg);
    }).toList();

    // Create moving average spots if available
    final movingAverageSpots = <FlSpot>[];
    if (movingAverage.isNotEmpty) {
      for (final avgPoint in movingAverage) {
        final x = avgPoint.timestamp.millisecondsSinceEpoch.toDouble() - firstTimestamp;
        movingAverageSpots.add(FlSpot(x, avgPoint.value));
      }
    }

    // Calculate Y-axis range considering both raw and moving average data
    final allYValues = [...spots.map((s) => s.y), ...movingAverageSpots.map((s) => s.y)];
    final minY = allYValues.reduce((a, b) => a < b ? a : b);
    final maxY = allYValues.reduce((a, b) => a > b ? a : b);
    final range = maxY - minY;
    final padding = range * 0.1;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: range > 0 ? range / 4 : 1,
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toStringAsFixed(1)} kg',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          // Convert X value back to timestamp
                          final timestamp = DateTime.fromMillisecondsSinceEpoch(
                            (value + firstTimestamp).toInt(),
                          );
                          final format = DateFormat('MMM d');
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              format.format(timestamp),
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                  ),
                  minY: minY - padding,
                  maxY: maxY + padding,
                  lineBarsData: [
                    // Raw measurements as dots only (no connecting line)
                    LineChartBarData(
                      spots: spots,
                      isCurved: false,
                      color: Colors.transparent,
                      barWidth: 0,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(show: false),
                    ),
                    // 7-day moving average line
                    if (movingAverageSpots.isNotEmpty)
                      LineChartBarData(
                        spots: movingAverageSpots,
                        isCurved: true,
                        color: Theme.of(context).colorScheme.primary,
                        barWidth: 3,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                        ),
                      ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          // Find the closest measurement to this X value
                          final spotTimestamp = (spot.x + firstTimestamp).toInt();
                          final measurement = measurements.reduce((a, b) {
                            final aDiff = (a.timestamp.millisecondsSinceEpoch - spotTimestamp).abs();
                            final bDiff = (b.timestamp.millisecondsSinceEpoch - spotTimestamp).abs();
                            return aDiff < bDiff ? a : b;
                          });

                          return LineTooltipItem(
                            '${measurement.value.toStringAsFixed(1)} ${measurement.unit.displayName}\n${DateFormat('MMM d, yyyy').format(measurement.timestamp)}',
                            const TextStyle(color: Colors.white),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
            // Change summary
            if (periodChange != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Overall Change',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    Row(
                      children: [
                        Icon(
                          periodChange! >= 0 ? Icons.trending_up : Icons.trending_down,
                          size: 18,
                          color: periodChange! >= 0 ? Colors.orange : Colors.green,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${periodChange! >= 0 ? '+' : ''}${periodChange!.toStringAsFixed(1)} kg',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: periodChange! >= 0 ? Colors.orange : Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
