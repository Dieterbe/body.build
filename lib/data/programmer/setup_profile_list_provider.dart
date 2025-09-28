import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bodybuild/model/programmer/settings.dart';
import 'package:bodybuild/data/programmer/setup_persistence_provider.dart';

part 'setup_profile_list_provider.g.dart';

@riverpod
Future<Map<String, Settings>> setupProfileList(Ref ref) async {
  final service = await ref.watch(setupPersistenceProvider.future);
  return service.loadProfiles();
}
