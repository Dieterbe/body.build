import 'package:bodybuild/data/programmer/demo_workouts.dart';
import 'package:bodybuild/data/programmer/program_persistence_provider.dart';
import 'package:bodybuild/model/programmer/program_state.dart';
import 'package:bodybuild/model/programmer/workout.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
      currentId = 'demo1';
      programs['demo1'] = demo1;

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

    final service = await ref.read(programPersistenceProvider.future);
    await service.saveLastProgramId(id);

    state = AsyncData(state.value!.copyWith(currentProgramId: id));
  }

// caller should assure the name is not used yet
  Future<void> createNewProgram(String name) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final newProgram = ProgramState(name: name);
    _createProgram(state.value!.programs, id, newProgram);
  }

// caller should assure the name is not used yet
  Future<void> duplicateProgram(String newName) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final newProgram =
        state.value!.currentProgram.copyWith(name: newName, builtin: false);
    _createProgram(state.value!.programs, id, newProgram);
  }

  Future<void> deleteProgram(String id) async {
    if (!state.value!.programs.containsKey(id)) return;

    final updatedPrograms = Map.of(state.value!.programs)..remove(id);
    final service = await ref.read(programPersistenceProvider.future);
    await service.deleteProgram(id);

    if (updatedPrograms.isEmpty) {
      // this should actually never happen anymore since we now have non-deletable builtins
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      const newProgram = ProgramState(name: 'New Program');
      _createProgram(updatedPrograms, id, newProgram);
      return;
    }

    if (id == state.value!.currentProgramId) {
      // current ID is no longer valid and needs to be fixed
      final newCurrentId = updatedPrograms.keys.first;
      await service.saveLastProgramId(newCurrentId);
      state = AsyncData(state.value!.copyWith(
        programs: updatedPrograms,
        currentProgramId: newCurrentId,
      ));
      return;
    }
    state = AsyncData(state.value!.copyWith(programs: updatedPrograms));
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

  // create program and switch to it.
  // id must be new, and program must have a unique name
  Future<void> _createProgram(
      Map<String, ProgramState> base, String id, ProgramState program) async {
    final updatedPrograms = Map.of(base);
    updatedPrograms[id] = program;

    final service = await ref.read(programPersistenceProvider.future);
    await service.saveProgram(id, program);
    await service.saveLastProgramId(id);

    state = AsyncData(state.value!.copyWith(
      programs: updatedPrograms,
      currentProgramId: id,
    ));
  }

  Future<void> _updateCurrentProgram(
      ProgramState Function(ProgramState) update) async {
    final currentId = state.value!.currentProgramId;
    final updatedProgram = update(state.value!.currentProgram);

    final updatedPrograms = Map.of(state.value!.programs);
    updatedPrograms[currentId] = updatedProgram;

    final service = await ref.read(programPersistenceProvider.future);
    await service.saveProgram(currentId, updatedProgram);

    state = AsyncData(state.value!.copyWith(programs: updatedPrograms));
  }
}
