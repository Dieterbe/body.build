library;

/// URL encoding and decoding utilities for exercise IDs
/// see exercises.dart for detailed character rules of the various fields
/// most importantly, '_' is not allowed, so we can use them in the URL
import 'package:bodybuild/data/programmer/exercise_versioning.dart';
import 'package:bodybuild/data/programmer/exercises.dart';
import 'package:bodybuild/service/exercise_migration_service.dart';
import 'package:collection/collection.dart';

/// Builds an exercise detail URL with encoded exercise ID and tweak options.
String buildExerciseDetailUrl(String exerciseId, Map<String, String> tweakOptions) {
  // Encode spaces as underscores in exercise ID
  final encodedExerciseId = exerciseId.replaceAll(' ', '_');

  if (tweakOptions.isEmpty) {
    return '/exercises/$encodedExerciseId';
  }

  final queryParams = <String, String>{};
  tweakOptions.forEach((key, value) {
    // Encode spaces as underscores in both keys and values
    final encodedKey = key.replaceAll(' ', '_');
    final encodedValue = value.replaceAll(' ', '_');
    queryParams['t_$encodedKey'] = encodedValue;
  });

  final uri = Uri(path: '/exercises/$encodedExerciseId', queryParameters: queryParams);

  return uri.toString();
}

/// Parses tweak options from URL query parameters.
/// Strips 't_' prefix and decodes underscores back to spaces.
Map<String, String> parseExerciseParams(Map<String, String> queryParameters) {
  final tweakOptions = <String, String>{};

  queryParameters.forEach((key, value) {
    if (key.startsWith('t_')) {
      // Strip 't_' prefix and decode underscores to spaces
      final decodedKey = key.substring(2).replaceAll('_', ' ');
      final decodedValue = value.replaceAll('_', ' ');
      tweakOptions[decodedKey] = decodedValue;
    }
  });

  return tweakOptions;
}

String parseExerciseId(String path) {
  return path.replaceAll('_', ' ');
}

/// Attempt to migrate incoming exercise ID/tweaks to current dataset version, if it isn't found.
(String, Map<String, String>) maybeMigrateExerciseFromUrl(
  String exerciseId,
  Map<String, String> tweaks,
) {
  final exercise = exes.firstWhereOrNull((ex) => ex.id == exerciseId);
  // note: for the purpose of migrations, we don't have to worry about constraint violations:
  // if the exercise ID, tweak keys and values are known, we can assume we're at the latest
  // version of the schema
  if (exercise != null && exercise.tweaksExist(tweaks)) {
    return (exerciseId, tweaks);
  }

  final result = ExerciseMigrationService.migrateExercise(
    exerciseId,
    tweaks,
    1,
    exerciseDatasetVersion,
  );
  return (result.$1, result.$2);
}
