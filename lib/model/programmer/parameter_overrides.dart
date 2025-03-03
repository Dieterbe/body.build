import 'package:bodybuild/data/programmer/exercise_base.dart';
import 'package:bodybuild/data/programmer/groups.dart';
import 'package:bodybuild/data/programmer/exercises.dart';
import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'parameter_overrides.freezed.dart';
part 'parameter_overrides.g.dart';

@freezed
class MuscleGroupOverride with _$MuscleGroupOverride {
  const factory MuscleGroupOverride(
    ProgramGroup group,
    int sets,
  ) = _MuscleGroupOverride;

  factory MuscleGroupOverride.fromJson(Map<String, dynamic> json) =>
      _$MuscleGroupOverrideFromJson(json);
}

@freezed
class ParameterOverrides with _$ParameterOverrides {
  const factory ParameterOverrides({
    final List<int>? intensities,
    final int? setsPerWeekPerMuscleGroup,
    final List<MuscleGroupOverride>? setsPerWeekPerMuscleGroupIndividual,
    @JsonKey(toJson: _exSetToJson, fromJson: _exSetFromJson)
    final Set<Ex>? excludedExercises,
    @JsonKey(toJson: _ebaseSetToJson, fromJson: _ebaseSetFromJson)
    final Set<EBase>? excludedBases,
  }) = _ParameterOverrides;

  factory ParameterOverrides.fromJson(Map<String, dynamic> json) =>
      _$ParameterOverridesFromJson(json);
}

List<String>? _exSetToJson(Set<Ex>? exSet) => exSet?.map((e) => e.id).toList();

Set<Ex>? _exSetFromJson(List<dynamic>? json) => json
    ?.map((e) {
      final match = exes.firstWhereOrNull((ex) => ex.id == e);
      if (match == null) {
        print(
            'Warning: Could not match exercise ID "$e" - forgetting about it');
      }
      return match;
    })
    .nonNulls
    .toSet();

List<String>? _ebaseSetToJson(Set<EBase>? ebaseSet) =>
    ebaseSet?.map((e) => e.name).toList();

Set<EBase>? _ebaseSetFromJson(List<dynamic>? json) => json
    ?.map((e) {
      final match = EBase.values.firstWhereOrNull((eb) => eb.name == e);
      if (match == null) {
        print('Warning: Could not match EBase name "$e" - forgetting about it');
      }
      return match;
    })
    .nonNulls
    .toSet();
