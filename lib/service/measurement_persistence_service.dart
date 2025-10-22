import 'package:bodybuild/data/workouts/workout_database.dart' as db;
import 'package:bodybuild/model/measurements/measurement.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class MeasurementPersistenceService {
  final db.WorkoutDatabase _database;
  final Uuid _uuid = const Uuid();

  MeasurementPersistenceService(this._database);

  // Convert Drift Measurement to model Measurement
  Measurement _toModel(db.Measurement dbMeasurement) {
    return Measurement(
      id: dbMeasurement.id,
      timestamp: dbMeasurement.timestamp,
      timezoneOffset: dbMeasurement.timezoneOffset,
      measurementType: MeasurementType.values.firstWhere(
        (e) => e.name == dbMeasurement.measurementType,
      ),
      value: dbMeasurement.value,
      unit: Unit.values.firstWhere((e) => e.name == dbMeasurement.unit),
      comment: dbMeasurement.comment,
    );
  }

  // Get all measurements
  Future<List<Measurement>> getAllMeasurements() async {
    final dbMeasurements = await _database.getAllMeasurements();
    return dbMeasurements.map(_toModel).toList();
  }

  // Watch all measurements (stream)
  Stream<List<Measurement>> watchAllMeasurements() {
    return _database.watchAllMeasurements().map((dbMeasurements) {
      return dbMeasurements.map(_toModel).toList();
    });
  }

  // Get measurements by type
  Future<List<Measurement>> getMeasurementsByType(MeasurementType type) async {
    final dbMeasurements = await _database.getMeasurementsByType(type.name);
    return dbMeasurements.map(_toModel).toList();
  }

  // Watch measurements by type (stream)
  Stream<List<Measurement>> watchMeasurementsByType(MeasurementType type) {
    return _database.watchMeasurementsByType(type.name).map((dbMeasurements) {
      return dbMeasurements.map(_toModel).toList();
    });
  }

  // Get latest measurement
  Future<Measurement?> getLatestMeasurement() async {
    final dbMeasurement = await _database.getLatestMeasurement();
    if (dbMeasurement == null) return null;
    return _toModel(dbMeasurement);
  }

  // Get latest measurement by type
  Future<Measurement?> getLatestMeasurementByType(MeasurementType type) async {
    final dbMeasurement = await _database.getLatestMeasurementByType(type.name);
    if (dbMeasurement == null) return null;
    return _toModel(dbMeasurement);
  }

  // Add new measurement
  Future<String> addMeasurement({
    required DateTime timestamp,
    required MeasurementType measurementType,
    required double value,
    required Unit unit,
    String? comment,
  }) async {
    final id = _uuid.v4();
    final timezoneOffset = getTimezoneOffsetString(timestamp);

    final companion = db.MeasurementsCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      timezoneOffset: Value(timezoneOffset),
      measurementType: Value(measurementType.name),
      value: Value(value),
      unit: Value(unit.name),
      comment: Value(comment),
    );

    await _database.insertMeasurement(companion);
    return id;
  }

  // Batch insert measurements (more efficient for bulk imports)
  // duplicates cause replacement
  Future<void> addMeasurementsBatch(
    List<
      ({
        DateTime timestamp,
        MeasurementType measurementType,
        double value,
        Unit unit,
        String? comment,
      })
    >
    measurements,
  ) async {
    await _database.batch((batch) {
      for (final measurement in measurements) {
        final id = _uuid.v4();
        final timezoneOffset = getTimezoneOffsetString(measurement.timestamp);

        batch.insert(
          _database.measurements,
          db.MeasurementsCompanion(
            id: Value(id),
            timestamp: Value(measurement.timestamp),
            timezoneOffset: Value(timezoneOffset),
            measurementType: Value(measurement.measurementType.name),
            value: Value(measurement.value),
            unit: Value(measurement.unit.name),
            comment: Value(measurement.comment),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  // Update existing measurement
  Future<void> updateMeasurement(Measurement measurement) async {
    final companion = db.MeasurementsCompanion(
      id: Value(measurement.id),
      timestamp: Value(measurement.timestamp),
      timezoneOffset: Value(measurement.timezoneOffset),
      measurementType: Value(measurement.measurementType.name),
      value: Value(measurement.value),
      unit: Value(measurement.unit.name),
      comment: Value(measurement.comment),
    );

    await _database.updateMeasurement(companion);
  }

  // Delete measurement
  Future<void> deleteMeasurement(String id) async {
    await _database.deleteMeasurement(id);
  }
}
