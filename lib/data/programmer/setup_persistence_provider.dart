import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bodybuild/service/setup_persistence_service.dart';

part 'setup_persistence_provider.g.dart';

@riverpod
Future<SetupPersistenceService> setupPersistence(Ref ref) async {
  final prefs = await SharedPreferences.getInstance();
  return SetupPersistenceService(prefs);
}
