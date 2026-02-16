// Exercise dataset version for migration tracking
import 'package:bodybuild/data/dataset/exercise_migration.dart';

const int exerciseDatasetVersion = 3;

// In case we make breaking changes to exercise ID's or tweaks (such that persisted values from
// the programmer, workout history, etc. are no longer valid), we should increment this version
// and add appropriate migrations to the list below.

// Exercise migrations registry
// Add migrations here when making breaking changes to exercise definitions
const List<ExerciseMigration> exerciseMigrations = [
  MergeExerciseMigration(1, 2, 'bulgarian split squat', {
    'dumbbell bulgarian split squat': {'loading': 'dumbbell'},
    'barbell bulgarian split squat': {'loading': 'barbell'},
    'smith machine (vertical) bulgarian split squat': {'loading': 'smith machine vertical'},
    'smith machine (angled) bulgarian split squat': {'loading': 'smith machine angled'},
  }),
  // Merge skull-overs, skull-crushers and overhead tricep extensions into "tricep extension"
  MergeExerciseMigration(2, 3, 'tricep extension', {
    'cable overhead tricep extension': {'loading': 'cable', 'posture': 'standing'},
    'dumbbell overhead tricep extension': {
      'loading': 'dumbbell',
      'posture': 'standing',
      'upper arm': 'stable',
    },
    'dumbbell skull-over': {
      'loading': 'dumbbell',
      'path': 'overhead',
      'posture': 'lying',
      'upper arm': 'stable',
    },
    'ez-bar skull-over': {
      'loading': 'ez-bar',
      'path': 'overhead',
      'posture': 'lying',
      'upper arm': 'stable',
    },
    'barbell skull-over': {
      'loading': 'barbell',
      'path': 'overhead',
      'posture': 'lying',
      'upper arm': 'stable',
    },
    'elastic skull-over': {
      'loading': 'elastic band',
      'path': 'overhead',
      'posture': 'lying',
      'upper arm': 'stable',
    },
    'dumbbell skull-crusher': {
      'loading': 'dumbbell',
      'path': 'to forehead',
      'posture': 'lying',
      'upper arm': 'stable',
    },
    'ez-bar skull-crusher': {
      'loading': 'ez-bar',
      'path': 'to forehead',
      'posture': 'lying',
      'upper arm': 'stable',
    },
    'barbell skull-crusher': {
      'loading': 'barbell',
      'path': 'to forehead',
      'posture': 'lying',
      'upper arm': 'stable',
    },
    'elastic skull-crusher': {
      'loading': 'elastic band',
      'path': 'to forehead',
      'posture': 'lying',
      'upper arm': 'stable',
    },
  }),
  // Rename "RP style" tweak to "upper arm" with updated option values
  // (only affects "cable overhead tricep extension" which had this tweak before merge)
  RenameTweakMigration(
    2,
    3,
    targetExerciseId: 'tricep extension',
    oldTweakName: 'RP style',
    oldOptionValue: 'no',
    newOptionValue: 'stable',
  ),
  RenameTweakMigration(
    2,
    3,
    targetExerciseId: 'tricep extension',
    oldTweakName: 'RP style',
    oldOptionValue: 'yes',
    newOptionValue: 'RP style',
  ),
  RenameTweakMigration(
    2,
    3,
    targetExerciseId: 'tricep extension',
    oldTweakName: 'RP style',
    newTweakName: 'upper arm',
  ),
];
