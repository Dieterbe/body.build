import 'package:ptc/model/programmer/program_state.dart';
import 'package:ptc/model/programmer/workout.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ptc/data/programmer/program_persistence_provider.dart';
import 'package:ptc/data/programmer/current_program_provider.dart';

part 'program.g.dart';

@Riverpod(keepAlive: true)
class Program extends _$Program {
  @override
  Future<ProgramState> build() async {
    ref.onDispose(() {
      print('programmer program provider disposed');
    });

    // Watch the current program ID to rebuild when it changes
    final currentProgram = await ref.watch(currentProgramProvider.future);

    // Listen to state changes and save automatically
    ref.listenSelf((previous, next) async {
      if (next.value == null) return;
      final service = await ref.read(programPersistenceProvider.future);
      await service.saveProgram(currentProgram, next.value!);
    });

    // Try to load saved program
    final service = await ref.read(programPersistenceProvider.future);
    final savedProgram = await service.loadProgram(currentProgram);
    return savedProgram ?? const ProgramState();
  }

  void add(Workout w) => state =
      AsyncData(state.value!.copyWith(workouts: [...state.value!.workouts, w]));

  void remove(Workout w) => state = AsyncData(state.value!.copyWith(
        workouts: state.value!.workouts.where((e) => e != w).toList(),
      ));

  void updateWorkout(Workout wOld, Workout? wNew) =>
      state = AsyncData(state.value!.copyWith(
        workouts: (wNew == null)
            ? state.value!.workouts.where((e) => (e != wOld)).toList()
            : state.value!.workouts
                .map((e) => ((e == wOld) ? wNew : e))
                .toList(),
      ));

  void updateName(String name) =>
      state = AsyncData(state.value!.copyWith(name: name));
}
