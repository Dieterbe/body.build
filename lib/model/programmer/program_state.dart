import 'package:ptc/model/programmer/workout.dart';

class ProgramState {
  final List<Workout> workouts;
  ProgramState({this.workouts = const []});

  copyWith({List<Workout>? workouts}) =>
      ProgramState(workouts: workouts ?? this.workouts);
}
