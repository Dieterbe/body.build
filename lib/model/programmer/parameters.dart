import 'package:ptc/data/programmer/groups.dart';
import 'package:ptc/model/programmer/level.dart';
import 'package:ptc/model/programmer/parameter_overrides.dart';
import 'package:ptc/model/programmer/settings.dart';
import 'package:ptc/util/formulas.dart';

class Parameters {
  late List<int> intensities;
  late int setsPerweekPerMuscleGroup;
  late List<MuscleGroupOverride> setsPerWeekPerMuscleGroupIndividual;

  Parameters() {
    intensities = [];
    setsPerweekPerMuscleGroup = 0;
    setsPerWeekPerMuscleGroupIndividual = [];
  }
  static Parameters fromSettings(Settings s) {
    var p = Parameters();
    p.intensities = switch (s.level) {
      Level.beginner => [60],
      Level.intermediate => [60, 70],
      Level.advanced => [65, 85],
      Level.elite => [70, 75, 80, 90],
      // TODO: age affects intensity
    };
    p.setsPerweekPerMuscleGroup = calcOptimalSetsPerWeekPerMuscleGroupMH(
        s.sex,
        s.level,
        s.recoveryFactor,
        s.energyBalance / 100,
        s.workoutsPerWeek * 1.0);
    /*
in the setup, we ideally don't want to be too prescriptive in terms of sets volume per muscle group, such that the program
can prioritize exercises not just thru volume, also thru ordering
OTOH, we do want to be able to express "don't train at all - vs de-emph - vs normal - vs prioritize"
*/

    return p;
  }

  Parameters copyWith(
      {List<int>? intensities,
      int? setsPerweekPerMuscleGroup,
      List<MuscleGroupOverride>? setsPerWeekPerMuscleGroupIndividual}) {
    return Parameters()
      ..intensities = intensities ?? this.intensities
      ..setsPerweekPerMuscleGroup =
          setsPerweekPerMuscleGroup ?? this.setsPerweekPerMuscleGroup
      ..setsPerWeekPerMuscleGroupIndividual =
          setsPerWeekPerMuscleGroupIndividual ??
              this.setsPerWeekPerMuscleGroupIndividual;
  }

  Parameters apply(ParameterOverrides overrides) {
    return copyWith(
        intensities: overrides.intensities,
        setsPerweekPerMuscleGroup: overrides.setsPerweekPerMuscleGroup,
        setsPerWeekPerMuscleGroupIndividual:
            overrides.setsPerWeekPerMuscleGroupIndividual);
  }

  int getSetsPerWeekPerMuscleGroupFor(ProgramGroup group) {
    for (final override in setsPerWeekPerMuscleGroupIndividual) {
      if (override.group == group) {
        return override.sets;
      }
    }
    return setsPerweekPerMuscleGroup;
  }
}
