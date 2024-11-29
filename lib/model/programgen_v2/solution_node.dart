import 'package:ptc/data/programmer/exercises.dart';
import 'package:ptc/data/programmer/groups.dart';
import 'package:ptc/model/programgen_v1/rank.dart';
import 'package:ptc/model/programmer/set_group.dart';

/// Represents a node in the solution search tree, containing a partial solution
/// to the workout generation problem.
class SolutionNode implements Comparable<SolutionNode> {
  /// Exercises chosen so far
  final List<RankedExercise> exercises;

  /// Number of sets for each exercise
  final List<int> setCounts;

  /// Original target recruitment for each group
  final Map<ProgramGroup, double> targets;

  /// Cost of current solution (lower is better)
  final double cost;

  SolutionNode(this.exercises, this.setCounts, this.targets, this.cost);

  /// Creates initial empty solution with given targets
  factory SolutionNode.initial(Map<ProgramGroup, double> targets) {
    // Calculate initial cost based on all targets being unmet
    var initialCost = 0.0;
    for (final entry in targets.entries) {
      initialCost += entry.value; // Cost is just the sum of unfulfilled targets
    }
    return SolutionNode([], [], targets, initialCost);
  }

  /// Get current recruitment for a program group
  double getCurrentRecruitment(ProgramGroup group) {
    var total = 0.0;
    for (var i = 0; i < exercises.length; i++) {
      total += exercises[i].ex.recruitmentFiltered(group, 0.5) * setCounts[i];
    }
    return total;
  }

  /// Get remaining deficit for a program group (positive means under target)
  double getDeficit(ProgramGroup group) {
    return (targets[group] ?? 0) - getCurrentRecruitment(group);
  }

  /// Creates a new solution by adding a set for the given exercise
  SolutionNode addSetFor(RankedExercise exercise) {
    // Copy state that needs to be copied in all cases
    final newSetCounts = List<int>.from(setCounts);
    var newExercises = exercises; // may not need to be copied

    // Find existing exercise or add new one
    final existingIndex = exercises.indexOf(exercise);
    if (existingIndex >= 0) {
      // Update existing exercise's sets
      newSetCounts[existingIndex]++;
    } else {
      // Add new exercise
      newExercises = List<RankedExercise>.from(exercises);
      newExercises.add(exercise);
      newSetCounts.add(1);
    }

    // Calculate new cost based on deficits
    var cost = 0.0;
    for (final group in ProgramGroup.values) {
      // Calculate new recruitment and deficit
      var newRecruitment = 0.0;
      for (var i = 0; i < newExercises.length; i++) {
        newRecruitment += newExercises[i].ex.recruitmentFiltered(group, 0.5) *
            newSetCounts[i];
      }
      final deficit = (targets[group] ?? 0) - newRecruitment;

      // Add to cost - penalize overshoot 2x
      if (deficit < 0) {
        cost += -deficit * 2; // overshoot
      } else {
        cost += deficit; // undershoot
      }
    }

    return SolutionNode(newExercises, newSetCounts, targets, cost);
  }

  /// Finds program group with highest remaining target
  /// Returns (group, target value) or null if no significant targets remain
  (ProgramGroup, double)? findHighestTarget() {
    var maxGroup = ProgramGroup.values
        .map((g) => MapEntry(g, getDeficit(g)))
        .where((e) => e.value >= 0.5) // Only consider significant deficits
        .fold<MapEntry<ProgramGroup, double>?>(
            null,
            (max, entry) =>
                max == null || entry.value > max.value ? entry : max);

    return maxGroup == null ? null : (maxGroup.key, maxGroup.value);
  }

  /// Converts solution to final SetGroup format
  SetGroup toSetGroup() {
    return SetGroup(
      List.generate(
        exercises.length,
        (i) => Sets(60, ex: exercises[i].ex, n: setCounts[i]),
      ),
    );
  }

  @override
  int compareTo(SolutionNode other) => cost.compareTo(other.cost);

  @override
  String toString() {
    return 'Solution(cost: $cost, exercises: ${exercises.map((e) => "${e.ex.id}:${setCounts[exercises.indexOf(e)]}").join(", ")})';
  }
}
