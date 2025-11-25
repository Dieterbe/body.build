import 'package:bodybuild/data/core/developer_mode_provider.dart';
import 'package:bodybuild/data/measurements/measurement_providers.dart';
import 'package:bodybuild/model/measurements/measurement.dart';
import 'package:bodybuild/ui/core/widget/app_navigation_drawer.dart';
import 'package:bodybuild/ui/measurements/widget/measurement_card.dart';
import 'package:bodybuild/ui/measurements/widget/measurement_chart.dart';
import 'package:bodybuild/ui/measurements/widget/measurement_dialog.dart';
import 'package:bodybuild/ui/workouts/widget/mobile_app_only_scaffold.dart';
import 'package:bodybuild/util/flutter.dart';
import 'package:bodybuild/util/measurements.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MeasurementsScreen extends ConsumerWidget {
  static const routeName = 'measurements';

  const MeasurementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devMode = ref.watch(developerModeProvider);
    if (!isMobileApp() && !devMode) {
      return const MobileAppOnlyScaffold(title: 'Measurements');
    }

    final measurementsAsync = ref.watch(measurementManagerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Measurements')),
      drawer: const AppNavigationDrawer(),
      body: measurementsAsync.when(
        data: (data) {
          final measurements = data.measurements;
          final movingAvgs7d = data.movingAverage7Day;
          if (measurements.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.monitor_weight_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text('No measurements yet', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to add your first measurement',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          final now = DateTime.now();
          final ts30DAgo = now.subtract(const Duration(days: 30));
          final ts1YrAgo = now.subtract(const Duration(days: 365));

          // Filter measurements and moving average for different time ranges
          final last30Days = measurements.where((m) => m.timestamp.isAfter(ts30DAgo)).toList();
          final last30DaysAvg = movingAvgs7d.where((m) => m.timestamp.isAfter(ts30DAgo)).toList();
          final last1Year = measurements.where((m) => m.timestamp.isAfter(ts1YrAgo)).toList();
          final last1YearAvg = movingAvgs7d.where((m) => m.timestamp.isAfter(ts1YrAgo)).toList();

          return ListView(
            children: [
              if (last30Days.length > 1) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'Last 30 Days',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                MeasurementChart(
                  measurements: last30Days,
                  movingAverage: last30DaysAvg,
                  periodChange:
                      last30Days.lastOrNull!.unit.toKg(last30Days.lastOrNull!.value) -
                      interpolateValueAt(ts30DAgo, movingAvgs7d)!.value,
                  changePeriod: last30Days.lastOrNull!.timestamp.difference(ts30DAgo),
                ),
              ],

              if (last1Year.length > last30Days.length + 2) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Text(
                    'Last 1 Year',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                MeasurementChart(
                  measurements: last1Year,
                  movingAverage: last1YearAvg,
                  periodChange:
                      last1Year.lastOrNull!.unit.toKg(last1Year.lastOrNull!.value) -
                      interpolateValueAt(ts1YrAgo, movingAvgs7d)!.value,
                  changePeriod: last1Year.lastOrNull!.timestamp.difference(ts1YrAgo),
                ),
              ],

              if (measurements.length > last1Year.length + 2) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Text(
                    'All Time',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                MeasurementChart(
                  measurements: measurements,
                  movingAverage: data.movingAverage7Day,
                  periodChange:
                      measurements.lastOrNull!.unit.toKg(measurements.lastOrNull!.value) -
                      measurements.firstOrNull!.unit.toKg(measurements.firstOrNull!.value),
                  changePeriod: measurements.lastOrNull!.timestamp.difference(
                    measurements.firstOrNull!.timestamp,
                  ),
                ),
              ],

              // Measurements list
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'History',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              ...measurements.reversed.map<Widget>(
                (measurement) => MeasurementCard(
                  measurement: measurement,
                  onEdit: () => _showEditDialog(context, ref, measurement),
                  onDelete: () => _showDeleteDialog(context, ref, measurement),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 16,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              Text('Error: $error'),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context, WidgetRef ref) async {
    // Get default unit from latest measurement
    final latestMeasurement = await ref.read(latestMeasurementProvider.future);
    final defaultUnit = latestMeasurement?.unit ?? getDefaultWeightUnitFromLocale();

    if (!context.mounted) return;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => MeasurementDialog(defaultUnit: defaultUnit),
    );

    if (result == null) {
      return;
    }
    try {
      await ref
          .read(measurementManagerProvider.notifier)
          .addMeasurement(
            timestamp: result['timestamp'] as DateTime,
            measurementType: result['type'] as MeasurementType,
            value: result['value'] as double,
            unit: result['unit'] as Unit,
            comment: result['comment'] as String?,
          );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add measurement: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _showEditDialog(BuildContext context, WidgetRef ref, Measurement measurement) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) =>
          MeasurementDialog(measurement: measurement, defaultUnit: measurement.unit),
    );

    if (result == null) {
      return;
    }
    final updated = Measurement(
      id: measurement.id,
      timestamp: result['timestamp'] as DateTime,
      timezoneOffset: getTimezoneOffsetString(result['timestamp'] as DateTime),
      measurementType: result['type'] as MeasurementType,
      value: result['value'] as double,
      unit: result['unit'] as Unit,
      comment: result['comment'] as String?,
    );

    try {
      await ref.read(measurementManagerProvider.notifier).updateMeasurement(updated);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update measurement: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _showDeleteDialog(
    BuildContext context,
    WidgetRef ref,
    Measurement measurement,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Measurement'),
        content: const Text('Are you sure you want to delete this measurement?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == null || !confirmed) {
      return;
    }
    try {
      await ref.read(measurementManagerProvider.notifier).deleteMeasurement(measurement.id);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete measurement: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}
