import 'dart:convert';
import 'package:bodybuild/data/programmer/exercise_versioning.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bodybuild/model/programmer/settings.dart';

class SetupPersistenceService {
  final SharedPreferences _prefs;
  static const _setupProfilesKey = 'setup_profiles';
  static const _lastProfileKey = 'last_setup_profile';
  static const _exerciseVersionKey = 'exercise_dataset_version_setup';

  SetupPersistenceService(this._prefs);

  /// Loads all setup profiles from SharedPreferences
  Map<String, Settings> loadProfiles() {
    final String? profilesJson = _prefs.getString(_setupProfilesKey);
    if (profilesJson == null) return {};

    final Map<String, dynamic> profilesMap = json.decode(profilesJson);
    return profilesMap.map(
      (key, value) => MapEntry(key, Settings.fromJson(value as Map<String, dynamic>)),
    );
  }

  /// Helper method to save profiles map to SharedPreferences
  Future<bool> _saveProfiles(Map<String, Settings> profiles) {
    final profilesJson = json.encode(profiles.map((key, value) => MapEntry(key, value.toJson())));
    return _prefs.setString(_setupProfilesKey, profilesJson);
  }

  /// Loads a specific profile by ID
  Settings? loadProfile(String id) {
    final profiles = loadProfiles();
    return profiles[id];
  }

  /// Saves a setup profile to SharedPreferences
  Future<bool> saveProfile(String id, Settings profile) async {
    final profiles = loadProfiles();
    profiles[id] = profile;
    return await _saveProfiles(profiles);
  }

  /// Deletes a profile by ID
  Future<bool> deleteProfile(String id) async {
    final profiles = loadProfiles();
    profiles.remove(id);
    return await _saveProfiles(profiles);
  }

  /// Loads the ID of the last selected profile
  Future<String?> loadLastProfileId() {
    return Future.value(_prefs.getString(_lastProfileKey));
  }

  /// Saves the ID of the last selected profile
  Future<bool> saveLastProfileId(String id) {
    return _prefs.setString(_lastProfileKey, id);
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
      return 'Exercise migration needed for setup profiles: $currentVersion -> $exerciseDatasetVersion';
    }

    return null;
  }
}
