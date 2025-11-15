import 'package:bodybuild/data/workouts/workout_database.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late WorkoutDatabase database;

  setUp(() {
    // Create in-memory database for testing
    database = WorkoutDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('unique constraint prevents duplicate measurements at same timestamp', () async {
    final timestamp = DateTime(2025, 1, 15, 10, 30);
    final measurement1 = MeasurementsCompanion(
      id: const Value('test-1'),
      timestamp: Value(timestamp),
      timezoneOffset: const Value('+00:00'),
      measurementType: const Value('weight'),
      value: const Value(75.0),
      unit: const Value('kg'),
      comment: const Value('First measurement'),
    );

    // First insert should succeed
    await database.insertMeasurement(measurement1);

    // Second insert with same timestamp and type should fail
    final measurement2 = MeasurementsCompanion(
      id: const Value('test-2'),
      timestamp: Value(timestamp),
      timezoneOffset: const Value('+00:00'),
      measurementType: const Value('weight'),
      value: const Value(76.0),
      unit: const Value('kg'),
      comment: const Value('Duplicate measurement'),
    );

    expect(() => database.insertMeasurement(measurement2), throwsA(isA<SqliteException>()));
  });

  test('allows different measurement types at same timestamp', () async {
    final timestamp = DateTime(2025, 1, 15, 10, 30);

    final weightMeasurement = MeasurementsCompanion(
      id: const Value('test-weight'),
      timestamp: Value(timestamp),
      timezoneOffset: const Value('+00:00'),
      measurementType: const Value('weight'),
      value: const Value(75.0),
      unit: const Value('kg'),
    );

    final bodyFatMeasurement = MeasurementsCompanion(
      id: const Value('test-bodyfat'),
      timestamp: Value(timestamp),
      timezoneOffset: const Value('+00:00'),
      measurementType: const Value('body_fat_percent'),
      value: const Value(15.0),
      unit: const Value('percent'),
    );

    // Both should succeed since they have different measurement types
    await database.insertMeasurement(weightMeasurement);
    await database.insertMeasurement(bodyFatMeasurement);

    final measurements = await database.getAllMeasurements();
    expect(measurements.length, 2);
  });

  test('allows same measurement type at different timestamps', () async {
    final measurement1 = MeasurementsCompanion(
      id: const Value('test-1'),
      timestamp: Value(DateTime(2025, 1, 15, 10, 30)),
      timezoneOffset: const Value('+00:00'),
      measurementType: const Value('weight'),
      value: const Value(75.0),
      unit: const Value('kg'),
    );

    final measurement2 = MeasurementsCompanion(
      id: const Value('test-2'),
      timestamp: Value(DateTime(2025, 1, 15, 10, 31)), // Different timestamp
      timezoneOffset: const Value('+00:00'),
      measurementType: const Value('weight'),
      value: const Value(76.0),
      unit: const Value('kg'),
    );

    // Both should succeed since they have different timestamps
    await database.insertMeasurement(measurement1);
    await database.insertMeasurement(measurement2);

    final measurements = await database.getAllMeasurements();
    expect(measurements.length, 2);
  });
}
