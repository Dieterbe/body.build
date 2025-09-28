import 'package:bodybuild/data/programmer/groups.dart';
import 'package:bodybuild/model/programmer/level.dart';
import 'package:bodybuild/model/programmer/parameter_overrides.dart';
import 'package:bodybuild/model/programmer/settings.dart';
import 'package:bodybuild/util/formulas.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'parameters.freezed.dart';
part 'parameters.g.dart';

// 37 ⋮    │TODO: implement ceiling of max sets per workout per MG: research says 6. but depends on factors such as genetics, closeness to failure, and rest intervals
@freezed
abstract class Parameters with _$Parameters {
  Parameters._(); // Private constructor for methods

  factory Parameters({
    @Default([]) List<int> intensities,
    @Default(0) int setsPerweekPerMuscleGroup,
    @Default([]) List<MuscleGroupOverride> setsPerWeekPerMuscleGroupIndividual,
  }) = _Parameters;

  factory Parameters.fromJson(Map<String, dynamic> json) => _$ParametersFromJson(json);

  static Parameters fromSettings(Settings s) {
    return Parameters(
      intensities: switch (s.level) {
        Level.beginner => [60],
        Level.intermediate => [60, 70],
        Level.advanced => [65, 85],
        Level.elite => [70, 75, 80, 90],
        // TODO: age affects intensity
      },
      setsPerweekPerMuscleGroup: calcOptimalSetsPerWeekPerMuscleGroupMH(
          s.sex, s.level, s.recoveryFactor, s.energyBalance / 100, s.workoutsPerWeek * 1.0),
      setsPerWeekPerMuscleGroupIndividual: [],
    );
  }

  Parameters apply(ParameterOverrides o) {
    return copyWith(
      intensities: o.intensities ?? intensities,
      setsPerweekPerMuscleGroup: o.setsPerWeekPerMuscleGroup ?? setsPerweekPerMuscleGroup,
      setsPerWeekPerMuscleGroupIndividual:
          o.setsPerWeekPerMuscleGroupIndividual ?? setsPerWeekPerMuscleGroupIndividual,
    );
  }

  int getSetsPerWeekPerMuscleGroupFor(ProgramGroup group) {
    final override = setsPerWeekPerMuscleGroupIndividual.where((e) => e.group == group).firstOrNull;
    return override?.sets ?? setsPerweekPerMuscleGroup;
  }
}
