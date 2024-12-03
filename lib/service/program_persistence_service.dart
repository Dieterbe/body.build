import 'dart:convert';
import 'package:ptc/model/programmer/program_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgramPersistenceService {
  static const String _programsKey = 'programs';
  final SharedPreferences _prefs;

  ProgramPersistenceService(this._prefs);

  /// Saves a program to SharedPreferences
  Future<bool> saveProgram(String id, ProgramState program) async {
    final programs = await loadPrograms();
    programs[id] = program;
    return _savePrograms(programs);
  }

  /// Loads all programs from SharedPreferences
  Future<Map<String, ProgramState>> loadPrograms() async {
    final String? programsJson = _prefs.getString(_programsKey);
    if (programsJson == null) return {};

    final Map<String, dynamic> programsMap = json.decode(programsJson);
    return programsMap.map((key, value) =>
        MapEntry(key, ProgramState.fromJson(value as Map<String, dynamic>)));
  }

  /// Loads a specific program by ID
  Future<ProgramState?> loadProgram(String id) async {
    final programs = await loadPrograms();
    return programs[id];
  }

  /// Deletes a program by ID
  Future<bool> deleteProgram(String id) async {
    final programs = await loadPrograms();
    programs.remove(id);
    return _savePrograms(programs);
  }

  /// Helper method to save programs map to SharedPreferences
  Future<bool> _savePrograms(Map<String, ProgramState> programs) {
    final programsJson = json
        .encode(programs.map((key, value) => MapEntry(key, value.toJson())));
    return _prefs.setString(_programsKey, programsJson);
  }
}
