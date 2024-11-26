import 'package:ptc/data/programmer/exercises.dart';
import 'package:ptc/data/programmer/groups.dart';
import 'package:ptc/model/programmer/set_group.dart';

/// Generates an optimized SetGroup that matches the desired recruitment targets
/// for each ProgramGroup as closely as possible while minimizing overshoot.
SetGroup generateOptimizedSetGroup(
    Map<ProgramGroup, double> targetRecruitment) {
  // 1. First, find the best exercises for each target
  final exercisesByGroup = _findBestExercisesForTargets(targetRecruitment);

  // 2. Calculate initial set configurations
  final setConfigurations =
      _calculateSetConfigurations(exercisesByGroup, targetRecruitment);

  // 3. Optimize and combine sets
  final optimizedSets = _optimizeSets(setConfigurations);

  // TODO: ordering based on priority, fatigue-rest-optimization,
  // compounds first (or compounds mixed with small isos)

  return SetGroup(optimizedSets);
}

/// Finds the exercises that provide the best recruitment for each target group
Map<ProgramGroup, List<Ex>> _findBestExercisesForTargets(
    Map<ProgramGroup, double> targets) {
  final result = <ProgramGroup, List<Ex>>{};

  for (final target in targets.keys) {
    // Sort exercises by their recruitment value for this group
    final sortedExes = exes.where((ex) => ex.recruitment(target) > 0).toList()
      ..sort((a, b) => b.recruitment(target).compareTo(a.recruitment(target)));

    // Take top N exercises
    result[target] = sortedExes.take(3).toList();
  }

  return result;
}

/// Calculates initial set configurations to meet recruitment targets
List<Sets> _calculateSetConfigurations(
    Map<ProgramGroup, List<Ex>> exercisesByGroup,
    Map<ProgramGroup, double> targets) {
  final sets = <Sets>[];

  for (final entry in exercisesByGroup.entries) {
    final target = targets[entry.key]!;
    final exercises = entry.value;

    // Start with the exercise that gives highest recruitment
    final bestEx = exercises.first;
    final recruitmentPerRep = bestEx.recruitment(entry.key);

    // Calculate reps needed (rounded up to ensure we meet or exceed target)
    final repsNeeded = (target / recruitmentPerRep).ceil();

    // Create sets with reasonable rep ranges (e.g., 8-12 reps per set)
    final setsNeeded = (repsNeeded / 10).ceil();
    final repsPerSet = (repsNeeded / setsNeeded).ceil();

    for (var i = 0; i < setsNeeded; i++) {
      sets.add(Sets(
        75, // moderate intensity
        ex: bestEx,
        n: repsPerSet,
      ));
    }
  }

  return sets;
}

/// Optimizes the set configuration to minimize total volume while meeting targets
List<Sets> _optimizeSets(List<Sets> initialSets) {
  // TODO: Implement optimization logic:
  // 1. Combine sets that work well together
  // 2. Adjust n factors to fine-tune recruitment
  // 3. Balance between minimal sets and meeting targets
  return initialSets;
}
