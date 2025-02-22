import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bodybuild/service/program_persistence_service.dart';

part 'program_persistence_provider.g.dart';

@Riverpod()
Future<ProgramPersistenceService> programPersistence(Ref ref) async {
  final prefs = await SharedPreferences.getInstance();
  return ProgramPersistenceService(prefs);
}
