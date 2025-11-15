import 'dart:convert';
import 'dart:io';

import 'package:bodybuild/service/program_persistence_service.dart';
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

      expect(report, isNull);
      /* once we actually evolve the library, we'll need to implement something likethis for the BSQ
      expect(report!.error, isNull);
      expect(report.from, 1);
      expect(report.to, exerciseDatasetVersion);
      expect(service.getCurrentExerciseVersion(), exerciseDatasetVersion);
      expect(prefs.getString('exercise_dataset_version'), exerciseDatasetVersion.toString());
      final program = service.loadProgram("demo1");
      expect(program?.workouts.length, 1);
      expect(program?.workouts.firstOrNull!.setGroups.length, 1);
      expect(program?.workouts.firstOrNull!.setGroups.firstOrNull!.sets.length, 1);
      expect(
        program?.workouts.firstOrNull!.setGroups.firstOrNull!.sets.firstOrNull!.ex!.id,
        'some id',
      );
      expect(
      // this should include all the tweaks
        program?.workouts.firstOrNull!.setGroups.firstOrNull!.sets.firstOrNull!.ex!.tweaks,
        [],
      );
      */
    });
  });
}
