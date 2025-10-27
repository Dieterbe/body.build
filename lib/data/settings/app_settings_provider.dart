import 'package:bodybuild/service/app_settings_persistence_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_settings_provider.g.dart';

@Riverpod(keepAlive: true)
Future<AppSettingsPersistenceService> appSettingsPersistence(Ref _) async {
  final prefs = await SharedPreferences.getInstance();
  return AppSettingsPersistenceService(prefs);
}
