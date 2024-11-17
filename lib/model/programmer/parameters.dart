import 'package:ptc/model/programmer/level.dart';
import 'package:ptc/model/programmer/parameter_overrides.dart';
import 'package:ptc/model/programmer/settings.dart';
import 'package:ptc/util/formulas.dart';

class Parameters {
  late List<int> intensities;
  late int setsPerweekPerMuscleGroup;

  Parameters() {
    intensities = [];
    setsPerweekPerMuscleGroup = 0;
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

  Parameters copyWith({List<int>? intensities}) {
    return Parameters()..intensities = intensities ?? this.intensities;
  }

  Parameters apply(ParameterOverrides overrides) {
    return copyWith(intensities: overrides.intensities);
  }
}
