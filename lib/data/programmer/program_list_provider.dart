import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ptc/data/programmer/program_persistence_provider.dart';
import 'package:ptc/model/programmer/program_state.dart';

part 'program_list_provider.g.dart';

@Riverpod()
Future<Map<String, ProgramState>> programList(Ref ref) async {
  final service = await ref.watch(programPersistenceProvider.future);
  return service.loadPrograms();
}
