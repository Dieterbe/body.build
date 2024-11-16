import 'package:ptc/model/programmer/level.dart';
import 'package:ptc/model/programmer/parameter_overrides.dart';
import 'package:ptc/model/programmer/settings.dart';

class Parameters {
  late List<int> intensities;

  Parameters() {
    intensities = [];
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
    /*
    novice -> 6-10 sets per muscle group per week
    trained -> 12-25 sets per muscle group per week
    elite -> 15 - 30 sets per muscle group per week

    Optimal gains rules of thumb
    novice trainees: 6-10 sets per muscle group per week
    trained: 12-20 sets, sometimes more

women -> can do a bit more probably

20-33% reduction in volume is generally appropriate during a cut compared to during a bulk (though at end of bulk, may have become advanced enough to eat the diff)

// other factors: PED, elite genetics, elderly a bit less

//////////////////////
in the setup, we ideally don't want to be too prescriptive in terms of sets volume per muscle group, such that the program
can prioritize exercises not just thru volume, also thru ordering
OTOH, we do want to be able to express "don't train at all - vs de-emph - vs normal - vs prioritize"

*/

    return p;
  }

// when you empty the override form, this is an empty list
// so the override fails

// OTOH, with default settings, overrides is just an empty list
// then we don't want it to override
  Parameters copyWith({List<int>? intensities}) {
    return Parameters()..intensities = intensities ?? this.intensities;
  }

  Parameters apply(ParameterOverrides overrides) {
    return copyWith(intensities: overrides.intensities);
  }
}
