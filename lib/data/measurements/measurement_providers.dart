import 'package:bodybuild/data/workouts/workout_providers.dart';
import 'package:bodybuild/model/measurements/measurement.dart';
import 'package:bodybuild/service/measurement_persistence_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'measurement_providers.g.dart';

// Persistence service provider - uses the same database as workouts
@Riverpod(keepAlive: true)
MeasurementPersistenceService measurementPersistenceService(Ref ref) {
  final database = ref.watch(workoutDatabaseProvider);
  return MeasurementPersistenceService(database);
}

/// Measurement manager - single source of truth for all measurement state
/// Uses Drift streams to automatically update when measurement data changes
@riverpod
class MeasurementManager extends _$MeasurementManager {
  @override
  Stream<MeasurementData> build() {
    final service = ref.watch(measurementPersistenceServiceProvider);
    return service.watchAllMeasurements().map((measurements) {
      return MeasurementData(
        measurements: measurements,
        movingAverage7Day: _calculate7DayMovingAverage(measurements),
      );
    });
  }

  /// Calculate 7-day moving average for measurements
  /// Each point represents the average of all measurements in the 7 days preceding it
  List<MovingAveragePoint> _calculate7DayMovingAverage(List<Measurement> sorted) {
    if (sorted.isEmpty) return [];

    final movingAverage = <MovingAveragePoint>[];

    for (int i = 0; i < sorted.length; i++) {
      final currentMeasurement = sorted[i];
      final currentDate = currentMeasurement.timestamp;

      // Find all measurements within 7 days before current measurement (inclusive)
      final sevenDaysAgo = currentDate.subtract(const Duration(days: 7));
      final measurementsInWindow = sorted.where((m) {
        return m.timestamp.isAfter(sevenDaysAgo) &&
            m.timestamp.isBefore(currentDate.add(const Duration(seconds: 1)));
      }).toList();

      if (measurementsInWindow.isNotEmpty) {
        // Convert all to kg and calculate average
        final valuesInKg = measurementsInWindow.map((m) => m.unit.toKg(m.value)).toList();
        final average = valuesInKg.reduce((a, b) => a + b) / valuesInKg.length;

        movingAverage.add(MovingAveragePoint(timestamp: currentDate, value: average));
      }
    }

    return movingAverage;
  }

  Future<String> addMeasurement({
    required DateTime timestamp,
    required MeasurementType measurementType,
    required double value,
    required Unit unit,
    String? comment,
  }) async {
    final service = ref.read(measurementPersistenceServiceProvider);
    return await service.addMeasurement(
      timestamp: timestamp,
      measurementType: measurementType,
      value: value,
      unit: unit,
      comment: comment,
    );
  }

  Future<void> updateMeasurement(Measurement measurement) async {
    final service = ref.read(measurementPersistenceServiceProvider);
    await service.updateMeasurement(measurement);
  }

  Future<void> deleteMeasurement(String id) async {
    final service = ref.read(measurementPersistenceServiceProvider);
    await service.deleteMeasurement(id);
  }
}

/// Provider to get measurements filtered by type
@riverpod
Stream<List<Measurement>> measurementsByType(Ref ref, MeasurementType type) {
  final service = ref.watch(measurementPersistenceServiceProvider);
  return service.watchMeasurementsByType(type);
}

/// Provider to get the latest measurement (for determining default unit)
@riverpod
Future<Measurement?> latestMeasurement(Ref ref) async {
  final service = ref.watch(measurementPersistenceServiceProvider);
  return await service.getLatestMeasurement();
}

/// Provider to get the latest measurement by type
@riverpod
Future<Measurement?> latestMeasurementByType(Ref ref, MeasurementType type) async {
  final service = ref.watch(measurementPersistenceServiceProvider);
  return await service.getLatestMeasurementByType(type);
}
