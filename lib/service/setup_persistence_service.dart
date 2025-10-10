import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bodybuild/model/programmer/settings.dart';

class SetupPersistenceService {
  final SharedPreferences _prefs;
  static const _setupProfilesKey = 'setup_profiles';
  static const _lastProfileKey = 'last_setup_profile';

  SetupPersistenceService(this._prefs);

  /// Loads all setup profiles from SharedPreferences
  Future<Map<String, Settings>> loadProfiles() async {
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
  Future<Settings?> loadProfile(String id) async {
    final profiles = await loadProfiles();
    return profiles[id];
  }

  /// Saves a setup profile to SharedPreferences
  Future<bool> saveProfile(String id, Settings profile) async {
    final profiles = await loadProfiles();
    profiles[id] = profile;
    return _saveProfiles(profiles);
  }

  /// Deletes a profile by ID
  Future<bool> deleteProfile(String id) async {
    final profiles = await loadProfiles();
    profiles.remove(id);
    return _saveProfiles(profiles);
  }

  /// Loads the ID of the last selected profile
  Future<String?> loadLastProfileId() {
    return Future.value(_prefs.getString(_lastProfileKey));
  }

  /// Saves the ID of the last selected profile
  Future<bool> saveLastProfileId(String id) {
    return _prefs.setString(_lastProfileKey, id);
  }
}
