import 'package:ptc/data/programmer/program_persistence_provider.dart';
import 'package:ptc/model/programmer/program_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_program_provider.g.dart';

@Riverpod()
class CurrentProgram extends _$CurrentProgram {
  @override
  Future<String> build() async {
    ref.onDispose(() {
      print('current program provider disposed');
    });

    // Get the first available program ID, or create a new program if none exist
    final service = await ref.read(programPersistenceProvider.future);
    final programs = await service.loadPrograms();

    if (programs.isEmpty) {
      final newId = DateTime.now().millisecondsSinceEpoch.toString();
      await service.saveProgram(
        newId,
        const ProgramState(name: 'New Program'),
      );
      return newId;
    }

    return programs.keys.first;
  }

  void select(String id) {
    state = AsyncData(id);
  }
}
