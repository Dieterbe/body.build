import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bodybuild/model/programmer/set_group.dart';

part 'workout.freezed.dart';
part 'workout.g.dart';

@freezed
class Workout with _$Workout {
  const factory Workout({
    @Default('unnamed workout') String name,
    @Default([]) List<SetGroup> setGroups,
    @Default(1) int timesPerPeriod,
    @Default(1) int periodWeeks,
  }) = _Workout;

  factory Workout.fromJson(Map<String, dynamic> json) => _$WorkoutFromJson(json);
}
