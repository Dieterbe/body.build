// length in cm
// weight in kg
import 'dart:math';

import 'package:bodybuild/data/programmer/groups.dart';
import 'package:bodybuild/model/programmer/level.dart';
import 'package:bodybuild/model/programmer/sex.dart';

const double kJToKcal = 0.239006;

double calcBMI(double weight, double length) =>
    10000 * weight / (length * length);

// implements Menno's suggested formula
int calcOptimalSetsPerWeekPerMuscleGroupMH(Sex sex, Level level,
    double recoveryFactor, double energyBalanceFactor, double workoutsPerWeek) {
  if (workoutsPerWeek >= 3) {
    workoutsPerWeek = 2.5;
  }
  final trainingStatusFactor = switch (level) {
    Level.beginner => 1.0,
    Level.intermediate => 2.0,
    Level.advanced => 3.0,
    Level.elite => 3.0,
  };
  final result = (workoutsPerWeek * 5) *
          energyBalanceFactor *
          recoveryFactor *
          sqrt(trainingStatusFactor) +
      (sex == Sex.female ? 3 : 0);
  return result.round();
}

// cunningham et al. 1991
// weigt must be in kg
// BMR via cunningham 1991 (aka katch-mcArdle)
// been validated in a wide range of
// populations from untrained individuals to athletes
bmrCunningham(double weight, double fatPct) {
  final ffm = weight * (1 - fatPct / 100);
  return 370 + (21.6 * ffm);
}

// Tinsley et al. (2018) BMR
// great for physique athletes, high level athletes, and bodybuilders (on AAS)
bmrTinsley(double weight) => 10 + weight * 24.8;

// Ten Haaf et al. (2014) BMR
// weight in kg
// height in m
// age in years
// good for athletes if you don't know BF
bmrTenHaaf(double weight, double height, double age, Sex sex) =>
    (49.94 * weight +
        24.59053 * height -
        34.014 * age +
        (sex == Sex.male ? 799.257 : 0) +
        122.502) *
    kJToKcal;

// get a body fat percentage estimate. not accurate for trained individuals with a good amount
// of lean body mass. but useful ballpark for untrained individuals
// Deurenberg et al. (1991)
bfDeurenberg(double bmi, double age, Sex sex) =>
    1.2 * bmi + 0.23 * age - (sex == Sex.male ? 10.8 : 0) - 5.4;

// normally, costs are as follows:
// 0.0 = perfect match
// 0.5 = off by 50%
// 1.0 = off by 100%
// 2.0 = off by 200%
// but there are exceptions...
calcCostForGroup(ProgramGroup group, double target, double recruitment) {
  final deficit = target - recruitment;

  // special case: overshooting front delts is less bad than
  // its alternatives (undershooting pecs or lateral delts)
  if (group == ProgramGroup.frontDelts && deficit < 0) {
    return (-deficit * 0.5) / target;
  }
  return deficit.abs() / target;
}
