import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ptc/provider/program_persistence_provider.dart';
import 'package:ptc/model/programmer/program_state.dart';

part 'program_list_provider.g.dart';

@riverpod
Future<Map<String, ProgramState>> programList(ProgramListRef ref) async {
  final service = await ref.watch(programPersistenceProvider.future);
  return service.loadPrograms();
}
