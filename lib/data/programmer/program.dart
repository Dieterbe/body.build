import 'package:ptc/model/programmer/program_state.dart';
import 'package:ptc/model/programmer/workout.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ptc/provider/program_persistence_provider.dart';

part 'program.g.dart';

@Riverpod(keepAlive: true)
class Program extends _$Program {
  @override
  ProgramState build() {
    ref.onDispose(() {
      print('programmer program provider disposed');
    });

    // Listen to state changes and save automatically
    ref.listenSelf((previous, next) async {
      final service = await ref.read(programPersistenceProvider.future);
      await service.saveProgram('current', next);
    });

    // Try to load saved program
    _loadSavedProgram();
    return ProgramState();
  }

  Future<void> _loadSavedProgram() async {
    try {
      final service = await ref.read(programPersistenceProvider.future);
      final savedProgram = await service.loadProgram('current');
      if (savedProgram != null) {
        state = savedProgram;
      }
    } catch (e) {
      print('Error loading saved program: $e');
    }
  }

  void add(Workout w) =>
      state = state.copyWith(workouts: [...state.workouts, w]);

  void remove(Workout w) => state = state.copyWith(
        workouts: state.workouts.where((e) => e != w).toList(),
      );

  void updateWorkout(Workout wOld, Workout? wNew) => state = state.copyWith(
        workouts: (wNew == null)
            ? state.workouts.where((e) => (e != wOld)).toList()
            : state.workouts.map((e) => ((e == wOld) ? wNew : e)).toList(),
      );

  void updateName(String name) => state = state.copyWith(name: name);
}
