import 'dart:convert';

import 'package:bodybuild/model/settings/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _settingsKey = 'app_settings';

class AppSettingsPersistenceService {
  final SharedPreferences _prefs;

  AppSettingsPersistenceService(this._prefs);

  AppSettings loadSettings() {
    final jsonString = _prefs.getString(_settingsKey);
    if (jsonString == null) {
      return const AppSettings();
    }

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return AppSettings.fromJson(json);
    } catch (e) {
      // If parsing fails, return default settings
      return const AppSettings();
    }
  }

  Future<void> saveSettings(AppSettings settings) async {
    final jsonString = jsonEncode(settings.toJson());
    await _prefs.setString(_settingsKey, jsonString);
  }

  Future<void> setWgerApiKey(String apiKey) async {
    final currentSettings = loadSettings();
    final newSettings = currentSettings.copyWith(wgerApiKey: apiKey);
    await saveSettings(newSettings);
  }

  Future<void> clearWgerApiKey() async {
    await setWgerApiKey('');
  }
}
