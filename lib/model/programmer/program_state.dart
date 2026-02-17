import 'package:bodybuild/model/programmer/workout.dart';
import 'package:bodybuild/model/workouts/template.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'program_state.freezed.dart';
part 'program_state.g.dart';

@freezed
abstract class ProgramState with _$ProgramState {
  const ProgramState._();

  const factory ProgramState({
    @Default('unnamed program') String name,
    @Default([]) List<Workout> workouts,
    @Default(false) bool builtin,
  }) = _ProgramState;

  factory ProgramState.fromJson(Map<String, dynamic> json) => _$ProgramStateFromJson(json);

  /// Convert each Workout in this program to a WorkoutTemplate,
  List<WorkoutTemplate> toTemplates() {
    final now = DateTime.now();
    const uuid = Uuid();
    return workouts
        .map(
          (workout) => WorkoutTemplate(
            id: uuid.v4(),
            description: 'Imported ${workout.name} from $name',
            isBuiltin: builtin,
            createdAt: now,
            updatedAt: now,
            workout: workout.copyWith(name: '$name / ${workout.name}'),
          ),
        )
        .toList();
  }
}
