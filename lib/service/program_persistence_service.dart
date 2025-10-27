import 'dart:convert';
import 'package:bodybuild/model/programmer/program_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bodybuild/data/programmer/exercises.dart';

class ProgramPersistenceService {
  static const String _programsKey = 'programs';
  static const String _lastProgramKey = 'last_program_id';
  static const String _exerciseVersionKey = 'exercise_dataset_version_programs';
  final SharedPreferences _prefs;

  ProgramPersistenceService(this._prefs);

  /// Loads all programs from SharedPreferences
  Map<String, ProgramState> loadPrograms() {
    final String? programsJson = _prefs.getString(_programsKey);
    if (programsJson == null) return {};

    final Map<String, dynamic> programsMap = json.decode(programsJson);
    return programsMap.map(
      (key, value) => MapEntry(key, ProgramState.fromJson(value as Map<String, dynamic>)),
    );
  }

  /// Helper method to save programs map to SharedPreferences
  Future<bool> _savePrograms(Map<String, ProgramState> programs) {
    final programsJson = json.encode(programs.map((key, value) => MapEntry(key, value.toJson())));
    return _prefs.setString(_programsKey, programsJson);
  }

  /// Loads a specific program by ID
  ProgramState? loadProgram(String id) {
    final programs = loadPrograms();
    return programs[id];
  }

  /// Saves a program to SharedPreferences
  Future<bool> saveProgram(String id, ProgramState program) async {
    final programs = loadPrograms();
    programs[id] = program;
    return await _savePrograms(programs);
  }

  /// Deletes a program by ID
  Future<bool> deleteProgram(String id) async {
    final programs = loadPrograms();
    programs.remove(id);
    return await _savePrograms(programs);
  }

  /// Loads the ID of the last selected program
  String? loadLastProgramId() {
    return _prefs.getString(_lastProgramKey);
  }

  /// Saves the ID of the last selected program
  Future<bool> saveLastProgramId(String id) async {
    return await _prefs.setString(_lastProgramKey, id);
  }

  /// Gets the current exercise dataset version from SharedPreferences
  int? getCurrentExerciseVersion() {
    return _prefs.getInt(_exerciseVersionKey);
  }

  /// Sets the current exercise dataset version in SharedPreferences
  Future<bool> setCurrentExerciseVersion(int version) {
    return _prefs.setInt(_exerciseVersionKey, version);
  }

  /// Checks if exercise migration is needed
  /// Returns null if OK, or error message if migration needed
  Future<String?> checkExerciseMigration() async {
    final currentVersion = getCurrentExerciseVersion();

    if (currentVersion == null) {
      // First time - set the version
      await setCurrentExerciseVersion(exerciseDatasetVersion);
      return null;
    }

    if (currentVersion != exerciseDatasetVersion) {
      return 'Exercise migration needed for programs: $currentVersion -> $exerciseDatasetVersion';
    }

    return null;
  }
}
