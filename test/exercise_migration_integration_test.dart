import 'dart:convert';
import 'dart:io';

import 'package:bodybuild/data/dataset/exercise_versioning.dart';
import 'package:bodybuild/data/dataset/exercises.dart';
import 'package:bodybuild/service/program_persistence_service.dart';
import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

String loadFixture(String filename) => File('test/fixtures/$filename').readAsStringSync();

Map<String, Object> loadSharedPreferencesFixture(String filename) {
  final content = loadFixture(filename);
  final decoded = json.decode(content) as Map<String, dynamic>;
  return decoded.map((key, value) => MapEntry(key, value as Object));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SharedPreferences-backed exercise migration', () {
    test('runs migration end-to-end for legacy program payload', () async {
      SharedPreferences.setMockInitialValues(
        loadSharedPreferencesFixture('shared_preferences-just-bsq-1-2-2.json'),
      );

      final prefs = await SharedPreferences.getInstance();
      final service = ProgramPersistenceService(prefs);

      final report = await service.runExerciseMigration();

      expect(report, isNotNull);
      expect(report!.error, isNull);
      expect(report.from, 1);
      expect(report.to, exerciseDatasetVersion);
      expect(prefs.getInt('exercise_dataset_version_programs'), exerciseDatasetVersion);
      expect(service.getCurrentExerciseVersion(), exerciseDatasetVersion);
      final program = service.loadProgram("demo1");
      expect(program?.workouts.length, 1);
      expect(program?.workouts.firstOrNull!.setGroups.length, 1);
      expect(program?.workouts.firstOrNull!.setGroups.firstOrNull!.sets.length, 1);
      expect(
        program?.workouts.firstOrNull!.setGroups.firstOrNull!.sets.firstOrNull!.ex!.id,
        'bulgarian split squat',
      );
      expect(
        program?.workouts.firstOrNull!.setGroups.firstOrNull!.sets.firstOrNull!.ex!.tweaks,
        exes.firstWhereOrNull((ex) => ex.id == 'bulgarian split squat')!.tweaks,
      );
    });
  });
}
