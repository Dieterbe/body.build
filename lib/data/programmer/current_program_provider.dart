import 'package:bodybuild/data/programmer/program_persistence_provider.dart';
import 'package:bodybuild/model/programmer/program_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_program_provider.g.dart';

@Riverpod()
class CurrentProgram extends _$CurrentProgram {
  @override
  Future<String> build() async {
    ref.onDispose(() {
      print('current program provider disposed');
    });

    // Get the persistence service
    final service = await ref.read(programPersistenceProvider.future);

    // Try to load the last selected program ID
    final lastProgramId = await service.loadLastProgramId();
    if (lastProgramId != null) {
      // Verify the program still exists
      final program = await service.loadProgram(lastProgramId);
      if (program != null) {
        return lastProgramId;
      }
    }

    // If no last program or it doesn't exist anymore, get the first available program
    final programs = await service.loadPrograms();

    if (programs.isEmpty) {
      final newId = DateTime.now().millisecondsSinceEpoch.toString();
      await service.saveProgram(
        newId,
        const ProgramState(name: 'New Program'),
      );
      await service.saveLastProgramId(newId);
      return newId;
    }

    final firstId = programs.keys.first;
    await service.saveLastProgramId(firstId);
    return firstId;
  }

  void select(String id) async {
    state = AsyncData(id);
    // Save the selected program ID
    final service = await ref.read(programPersistenceProvider.future);
    await service.saveLastProgramId(id);
  }
}
