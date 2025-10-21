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
  Stream<List<Measurement>> build() {
    final service = ref.watch(measurementPersistenceServiceProvider);
    return service.watchAllMeasurements();
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
