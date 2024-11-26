import 'dart:math';

import 'package:ptc/data/programmer/groups.dart';
import 'package:ptc/model/programgen/combinator.dart';
import 'package:ptc/model/programgen/cost.dart';
import 'package:ptc/model/programgen/rank.dart';
import 'package:ptc/model/programmer/set_group.dart';

/// Generates an optimized SetGroup that matches the desired recruitment targets
/// for each ProgramGroup as closely as possible while minimizing overshoot.
SetGroup generateOptimizedSetGroup(
    Map<ProgramGroup, double> targetRecruitment) {
  final rankedExercises = rankExercises();

  // Print all ranked exercises with their total recruitment values
  // for (final ranked in rankedExercises) {
  //  print('${ranked.ex.id}: ${ranked.rank}');
  // }

  final compounds = rankedExercises.where((ranked) => ranked.rank > 1.25);
  final isolations = rankedExercises.where((ranked) => ranked.rank <= 1.25);

// now we need to explore the space of possible setGroups, where setGroups are combinations
// of sets for a given exercise (from compounds only) and given `n' factor,
// in such as way that calculateCost() is the smallest amount possible.

  return generateLowestCostSetGroup(compounds, targetRecruitment);
}

// future optimizations.. identify combo's that only differ in disjoint parts
// e.g. we don't need to calc all combo's of all leg exercises with all combo's of all chest exercises
// could identify disjoint groups, and process them separately
SetGroup generateLowestCostSetGroup(Iterable<RankedExercise> compounds,
    Map<ProgramGroup, double> targetRecruitment) {
  final numSignificantGroups =
      targetRecruitment.entries.where((entry) => entry.value > 0.5).length;

  // We need approximately half as many distinct exercises as significant groups
  final minExercises = (numSignificantGroups / 2).ceil();

  var bestSetGroup = SetGroup([]);
  var bestCost = double.infinity;

  // Helper function to try different set combinations for a list of exercises
  void trySetCombinations(List<RankedExercise> selectedExercises) {
    // Generate all possible set counts for each exercise (1-4 sets each)
    final setCombinations = List.generate(
        selectedExercises.length, (i) => List.generate(4, (sets) => sets + 1));

    // Try each combination of set counts
    void generateSetGroups(List<int> currentSets, int index) {
      if (index == selectedExercises.length) {
        // We have a complete combination of set counts
        final sets = List.generate(selectedExercises.length,
            (i) => Sets(60, ex: selectedExercises[i].ex, n: currentSets[i]));

        final setGroup = SetGroup(sets);
        final cost = calculateCost(targetRecruitment, setGroup);

        if (cost < bestCost) {
          bestCost = cost;
          bestSetGroup = setGroup;
        }
        return;
      }

      // Try each possible set count for the current exercise
      for (final setCount in setCombinations[index]) {
        currentSets[index] = setCount;
        generateSetGroups(currentSets, index + 1);
      }
    }

    generateSetGroups(List.filled(selectedExercises.length, 1), 0);
  }

  combinator(
      compounds.toList(), minExercises, minExercises + 2, trySetCombinations);

  return bestSetGroup;
}
