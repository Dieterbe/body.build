import 'dart:math';

import 'package:bodybuild/data/programmer/groups.dart';
import 'package:bodybuild/model/programmer/settings.dart';
import 'package:bodybuild/model/programmer/workout.dart';
import 'package:bodybuild/util/formulas.dart';

class WorkoutsStats {
  /* input parameters */
  final Settings? setup;
  final List<Workout> workouts;
  final double cutoff;

  /* computed values */
  // for each program group, the recruitment volume, summed from all the exercises found in our sets
  // volumes < cutoff are counted as 0
  late Map<ProgramGroup, double> totals;
  late double maxVal; // highest value seen amongst the totals
  // number of sets per "involved musclegroups" (not the same as PG's)
  late Map<int, int> setsHisto;
  late double score;

  WorkoutsStats(this.setup, this.workouts, this.cutoff) {
    var totalsWIP = {for (var group in ProgramGroup.values) group: 0.0};
    var setHistoWIP = <int, int>{};

    for (final workout in workouts) {
      final weeklyFreq = workout.timesPerPeriod / workout.periodWeeks;

      // Process each set in all SetGroups
      for (final sg in workout.setGroups) {
        for (final set in sg.sets) {
          if (set.ex != null) {
            // Count recruitment for each group
            for (var group in ProgramGroup.values) {
              totalsWIP[group] =
                  totalsWIP[group]! + set.recruitmentFiltered(group, cutoff) * weeklyFreq;
            }
            final img = set.involvedMuscleGroups();
            if (img != null) {
              setHistoWIP[img] = (setHistoWIP[img] ?? 0) + set.n;
            }
          }
        }
      }
    }

    totals = totalsWIP.map((group, value) => MapEntry(group, value));
    maxVal = totals.values.reduce(max);
    setsHisto = setHistoWIP;
    score = _calculateScore(totalsWIP);
  }

  // Calculate the average score by comparing recruitment totals (filtered against a cutoff)
  // to desired volumes
  double _calculateScore(Map<ProgramGroup, double> totals) {
    if (setup == null) return 0.0;

    var costs = <double>[];
    for (var group in ProgramGroup.values) {
      final target = setup!.paramFinal.getSetsPerWeekPerMuscleGroupFor(group);
      final recruitment = totals[group] ?? 0.0;
      costs.add(calcCostForGroup(group, target * 1.0, recruitment));
    }

    final avgCost = costs.reduce((a, b) => a + b) / costs.length;
    // Convert cost to score (0-100%):
    // cost 0.0 -> score 100%
    // cost 0.5 -> score 50%
    // cost 1.0 -> score 0%
    // cost 2.0 -> score 0%
    return max(0.0, 1.0 - avgCost);
  }
}
