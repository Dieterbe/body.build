import 'package:bodybuild/model/programmer/program_state.dart';
import 'package:bodybuild/model/programmer/workout.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bodybuild/data/programmer/program_persistence_provider.dart';

part 'program_manager.g.dart';

class ProgramManagerState {
  final Map<String, ProgramState> programs;
  final String currentProgramId;

  const ProgramManagerState({
    required this.programs,
    required this.currentProgramId,
  });

  ProgramState get currentProgram => programs[currentProgramId]!;

  ProgramManagerState copyWith({
    Map<String, ProgramState>? programs,
    String? currentProgramId,
  }) {
    return ProgramManagerState(
      programs: programs ?? this.programs,
      currentProgramId: currentProgramId ?? this.currentProgramId,
    );
  }
}

@Riverpod(keepAlive: true)
class ProgramManager extends _$ProgramManager {
  @override
  Future<ProgramManagerState> build() async {
    ref.onDispose(() {
      print('program manager provider disposed');
    });

    final service = await ref.read(programPersistenceProvider.future);

    // Load all programs
    final programs = await service.loadPrograms();

    // Get last selected or create default
    String currentId;
    if (programs.isEmpty) {
      currentId = DateTime.now().millisecondsSinceEpoch.toString();
      programs[currentId] = const ProgramState(name: 'New Program');
      await service.saveProgram(currentId, programs[currentId]!);
      await service.saveLastProgramId(currentId);
    } else {
      currentId = await service.loadLastProgramId() ?? programs.keys.first;
    }

    return ProgramManagerState(
      programs: programs,
      currentProgramId: currentId,
    );
  }

  Future<void> selectProgram(String id) async {
    if (!state.value!.programs.containsKey(id)) return;

    state = AsyncData(state.value!.copyWith(currentProgramId: id));
    final service = await ref.read(programPersistenceProvider.future);
    await service.saveLastProgramId(id);
  }

  Future<void> createProgram(String name) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final newProgram = ProgramState(name: name);

    final updatedPrograms = Map.of(state.value!.programs);
    updatedPrograms[id] = newProgram;

    state = AsyncData(state.value!.copyWith(
      programs: updatedPrograms,
      currentProgramId: id,
    ));

    final service = await ref.read(programPersistenceProvider.future);
    await service.saveProgram(id, newProgram);
    await service.saveLastProgramId(id);
  }

  Future<void> deleteProgram(String id) async {
    if (!state.value!.programs.containsKey(id)) return;

    final updatedPrograms = Map.of(state.value!.programs)..remove(id);
    final service = await ref.read(programPersistenceProvider.future);
    await service.deleteProgram(id);

    if (updatedPrograms.isEmpty) {
      await createProgram('New Program');
      return;
    }

    if (id == state.value!.currentProgramId) {
      final newCurrentId = updatedPrograms.keys.first;
      state = AsyncData(state.value!.copyWith(
        programs: updatedPrograms,
        currentProgramId: newCurrentId,
      ));
      await service.saveLastProgramId(newCurrentId);
    } else {
      state = AsyncData(state.value!.copyWith(programs: updatedPrograms));
    }
  }

  Future<void> updateProgramName(String name) async {
    _updateCurrentProgram((ProgramState p) {
      return p.copyWith(name: name);
    });
  }

  void addWorkout(Workout w) {
    _updateCurrentProgram((ProgramState p) {
      return p.copyWith(
        workouts: [...p.workouts, w],
      );
    });
  }

  void removeWorkout(Workout w) {
    _updateCurrentProgram((ProgramState p) {
      return p.copyWith(
        workouts: p.workouts.where((e) => e != w).toList(),
      );
    });
  }

  void updateWorkout(Workout wOld, Workout? wNew) {
    _updateCurrentProgram((ProgramState p) {
      return p.copyWith(
        workouts: wNew == null
            ? p.workouts.where((e) => e != wOld).toList()
            : p.workouts.map((e) => e == wOld ? wNew : e).toList(),
      );
    });
  }

  void _updateCurrentProgram(ProgramState Function(ProgramState) update) {
    final currentId = state.value!.currentProgramId;
    final currentProgram = state.value!.programs[currentId]!;
    final updatedProgram = update(currentProgram);

    final updatedPrograms = Map.of(state.value!.programs);
    updatedPrograms[currentId] = updatedProgram;

    state = AsyncData(state.value!.copyWith(programs: updatedPrograms));
    _persistCurrentProgram(updatedProgram);
  }

  Future<void> _persistCurrentProgram(ProgramState program) async {
    final service = await ref.read(programPersistenceProvider.future);
    await service.saveProgram(state.value!.currentProgramId, program);
  }
}
