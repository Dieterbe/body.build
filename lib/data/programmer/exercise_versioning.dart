// Exercise dataset version for migration tracking
import 'package:bodybuild/data/programmer/exercise_migrations.dart';

const int exerciseDatasetVersion = 1;

// In case we make breaking changes to exercise ID's or tweaks (such that persisted values from
// the programmer, workout history, etc. are no longer valid), we should increment this version
// and add appropriate migrations to the list below.

// Exercise migrations registry
// Add migrations here when making breaking changes to exercise definitions
const List<ExerciseMigration> exerciseMigrations = [];
