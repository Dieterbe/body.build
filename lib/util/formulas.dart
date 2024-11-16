// length in cm
// weight in kg
import 'dart:math';

import 'package:ptc/model/programmer/level.dart';
import 'package:ptc/model/programmer/sex.dart';

double calcBMI(int weight, int length) => 10000 * weight / (length * length);

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
