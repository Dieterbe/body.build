import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ptc/model/programmer/settings.dart';
import 'package:ptc/data/programmer/setup_persistence_provider.dart';

part 'setup_profile_list_provider.g.dart';

@riverpod
Future<Map<String, Settings>> setupProfileList(SetupProfileListRef ref) async {
  final service = await ref.watch(setupPersistenceProvider.future);
  return service.loadProfiles();
}
