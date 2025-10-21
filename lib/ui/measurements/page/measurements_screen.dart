import 'package:bodybuild/data/developer_mode_provider.dart';
import 'package:bodybuild/data/measurements/measurement_providers.dart';
import 'package:bodybuild/model/measurements/measurement.dart';
import 'package:bodybuild/ui/measurements/widget/measurement_card.dart';
import 'package:bodybuild/ui/measurements/widget/measurement_chart.dart';
import 'package:bodybuild/ui/measurements/widget/measurement_dialog.dart';
import 'package:bodybuild/ui/workouts/widget/mobile_app_only.dart';
import 'package:bodybuild/util/flutter.dart';
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
      return const MobileAppOnly(title: 'Measurements');
    }

    final measurementsAsync = ref.watch(measurementManagerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Measurements')),
      body: measurementsAsync.when(
        data: (measurements) {
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

          // Calculate data age
          final now = DateTime.now();
          final oldestDate = measurements.lastOrNull?.timestamp ?? now;
          final dataAge = now.difference(oldestDate);

          // Filter measurements for different time ranges
          final last30Days = measurements
              .where((m) => now.difference(m.timestamp).inDays <= 30)
              .toList();
          final last1Year = measurements
              .where((m) => now.difference(m.timestamp).inDays <= 365)
              .toList();

          return ListView(
            children: [
              // Last 30 Days Chart (always show if we have data)
              if (last30Days.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'Last 30 Days',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                MeasurementChart(measurements: last30Days),
              ],

              // Last 1 Year Chart (show if we have data older than 30 days)
              if (dataAge.inDays > 30 && last1Year.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Text(
                    'Last 1 Year',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                MeasurementChart(measurements: last1Year),
              ],

              // All Time Chart (show if we have data older than 1 year)
              if (dataAge.inDays > 365) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Text(
                    'All Time',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                MeasurementChart(measurements: measurements),
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
              ...measurements.map<Widget>(
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
