import 'package:bodybuild/data/programmer/program_persistence_provider.dart';
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

    final programs = await service.loadPrograms();

    if (programs.isEmpty) {
      throw Exception('No programs found');
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
