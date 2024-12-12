import 'package:ptc/data/programmer/groups.dart';
import 'package:ptc/model/programgen_v1/combinator.dart';
import 'package:ptc/model/programgen_v1/components.dart';
import 'package:ptc/model/programgen_v1/cost.dart';
import 'package:ptc/model/programgen_v1/matrix_optimizer.dart';
import 'package:ptc/model/programgen_v1/rank.dart';
import 'package:ptc/model/programmer/set_group.dart';

/// Generates an optimized SetGroup that matches the desired recruitment targets
/// for each ProgramGroup as closely as possible while minimizing overshoot.
SetGroup generateOptimalSetGroup(Map<ProgramGroup, double> targetRecruitment) {
  final rankedExercises = rankExercises();

  // Print all ranked exercises with their total recruitment values
  // for (final ranked in rankedExercises) {
  //  print('${ranked.ex.id}: ${ranked.rank}');
  // }

  final compounds = rankedExercises.where((ranked) => ranked.rank > 1.25);
  // final isolations = rankedExercises.where((ranked) => ranked.rank <= 1.25);

// now we need to explore the space of possible setGroups, where setGroups are combinations
// of sets for a given exercise (from compounds only) and given `n' factor,
// in such as way that calculateCost() is the smallest amount possible.

  return generateLowestCostSetGroup(compounds, targetRecruitment);
}

SetGroup generateLowestCostSetGroup(Iterable<RankedExercise> compounds,
    Map<ProgramGroup, double> targetRecruitment) {
  print('\n# Starting workout generation:');

  // Find disjoint components
  final components = findExerciseComponents(compounds, targetRecruitment);
  print('Found ${components.length} disjoint exercise components');

  // Process each component separately
  final componentSetGroups = <SetGroup>[];
  for (var i = 0; i < components.length; i++) {
    final component = components[i];
    print('\nProcessing component ${i + 1}/${components.length}:');
    print(
        'Exercises in component: ${component.map((e) => e.ex.id).join(', ')}');

    // Create component-specific targets
    final componentTargets = Map.of(targetRecruitment);
    // Zero out targets for program groups not affected by this component
    final componentProgramGroups = ProgramGroup.values
        .where((pg) => component.any((ex) => ex.ex.recruitment(pg) > 0));

    // Zero out targets for program groups not affected by this component
    for (final pg in ProgramGroup.values) {
      if (!componentProgramGroups.contains(pg)) {
        componentTargets[pg] = 0;
      }
    }

    print('Active program groups for this component:');
    componentTargets.forEach((pg, target) {
      if (target > 0) print('  $pg: $target');
    });

    final setGroup = _generateComponentSetGroup(component, componentTargets);
    if (setGroup.sets.isNotEmpty) {
      componentSetGroups.add(setGroup);
      print('\nComponent solution:');
      for (final set in setGroup.sets) {
        print('  ${set.ex?.id}: ${set.n} sets');
      }
    }
  }

  // Combine all component results
  final finalSetGroup =
      SetGroup(componentSetGroups.expand((sg) => sg.sets).toList());

  print('\nWorkout generation complete:');

  return finalSetGroup;
}

// Process a single component using matrix optimization
SetGroup _generateComponentSetGroup(List<RankedExercise> compounds,
    Map<ProgramGroup, double> targetRecruitment) {
  final numSignificantGroups =
      targetRecruitment.entries.where((entry) => entry.value > 0.5).length;

  print('\nOptimizing component:');
  print('Number of significant groups: $numSignificantGroups');
  print('Available exercises: ${compounds.length}');
// We probably need approximately half as many distinct exercises as significant groups
// this is a crude optimization
  final minExercises = (numSignificantGroups / 2).ceil();
  print(
      'Will try combinations of $minExercises to ${minExercises + 2} exercises');

  var bestSetGroup = const SetGroup([]);
  var bestCost = double.infinity;
  var combinationsTried = 0;

  // Helper function to try different set combinations for a list of exercises
  void trySetCombinations(List<RankedExercise> selectedExercises) {
    combinationsTried++;
    // print('\nTrying exercise combination $combinationsTried:');
    // print('Exercises: ${selectedExercises.map((e) => e.ex.id).join(', ')}');

    final optimizer = MatrixOptimizer(selectedExercises, targetRecruitment);
    final setGroup = optimizer.findOptimalSetGroup();
    final cost = calculateCost(targetRecruitment,
        setGroup); // todo: can probably use the cost from the optimizer

    if (cost < bestCost) {
      bestCost = cost;
      bestSetGroup = setGroup;
      print('\nNew best combination found!');
      print('Cost: $cost');
      print('Exercises with sets:');
      for (final set in setGroup.sets) {
        print('  ${set.ex?.id}: ${set.n} sets');
      }
    }
  }

  combinator(compounds, minExercises, minExercises + 2, trySetCombinations);

  print('\nComponent optimization complete:');
  print('Total exercise combinations tried: $combinationsTried');
  print('Final best cost: $bestCost');

  return bestSetGroup;
}
