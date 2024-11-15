import 'package:ptc/model/programmer/workout.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'program.g.dart';

class ProgramState {
  final List<Workout> workouts;
  ProgramState({this.workouts = const []});

  copyWith({List<Workout>? workouts}) =>
      ProgramState(workouts: workouts ?? this.workouts);
}

@Riverpod(keepAlive: true)
class Program extends _$Program {
  @override
  ProgramState build() {
    ref.onDispose(() {
      print('programmer program provider disposed');
    });
    return ProgramState();
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
}
