import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bodybuild/model/programmer/workout.dart';

part 'program_state.freezed.dart';
part 'program_state.g.dart';

@freezed
class ProgramState with _$ProgramState {
  const factory ProgramState({
    @Default('unnamed program') String name,
    @Default([]) List<Workout> workouts,
    @Default(false) bool builtin,
  }) = _ProgramState;

  factory ProgramState.fromJson(Map<String, dynamic> json) =>
      _$ProgramStateFromJson(json);
}
