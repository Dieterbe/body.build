import 'package:ptc/data/programmer/groups.dart';
import 'package:ptc/model/programgen_v1/rank.dart';
import 'package:ptc/model/programmer/set_group.dart';

/// Represents a node in the solution search tree, containing a partial solution
/// to the workout generation problem.
class SolutionNode implements Comparable<SolutionNode> {
  /// Number of sets for each exercise. id corresponds to index in [exercises]
  final List<int> sets;

  /// Original target recruitment for each group
  final Map<ProgramGroup, double> targets;

  /// Cost of current solution (lower is better)
  final double cost;

  // cache
  final List<Map<ProgramGroup, double>> recruitments;
  List<RankedExercise>
      exercises; // only used for printing and turning into a setGroup

  SolutionNode(
      this.sets, this.targets, this.cost, this.recruitments, this.exercises);

  /// Creates initial empty solution with given targets
  factory SolutionNode.initial(
      List<RankedExercise> exercises,
      List<Map<ProgramGroup, double>> recruitments,
      Map<ProgramGroup, double> targets) {
    // Calculate initial cost based on all targets being unmet
    var initialCost = 0.0;
    for (final entry in targets.entries) {
      initialCost += entry.value; // Cost is just the sum of unfulfilled targets
    }
    return SolutionNode(List.filled(exercises.length, 0), targets, initialCost,
        recruitments, exercises);
  }

  /// Get current recruitment for a program group
  /// // TODO: can rewrite this as a fold() ?
  double getCurrentRecruitment(ProgramGroup group) {
    var total = 0.0;
    for (var i = 0; i < recruitments.length; i++) {
      total += recruitments[i][group]! * sets[i];
    }
    return total;
  }

  /// Get remaining deficit for a program group (positive means under target)
  double getDeficit(ProgramGroup group) {
    return (targets[group] ?? 0) - getCurrentRecruitment(group);
  }

  /// Creates a new solution by adding a set for the given exercise id
  SolutionNode addSetFor(int i) {
    // Copy state that needs to be copied in all cases
    final newSets = List<int>.from(sets);
    newSets[i]++;

    // Calculate new cost based on deficits
    var cost = 0.0;
    for (final group in ProgramGroup.values) {
      // Calculate new recruitment and deficit
      var newRecruitment = 0.0;
      for (var i = 0; i < recruitments.length; i++) {
        newRecruitment += recruitments[i][group]! * newSets[i];
      }
      final deficit = (targets[group] ?? 0) - newRecruitment;

      // Add to cost - penalize overshoot 2x
      if (deficit < 0) {
        cost += -deficit * 2; // overshoot
      } else {
        cost += deficit; // undershoot
      }
    }

    return SolutionNode(newSets, targets, cost, recruitments, exercises);
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
  SetGroup toSetGroup() => SetGroup(
        List.generate(exercises.length, (i) => (exercises[i], sets[i]))
            .where((tuple) => tuple.$2 > 0)
            .map((tuple) => Sets(60, ex: tuple.$1.ex, n: tuple.$2))
            .toList(),
      );

  @override
  int compareTo(SolutionNode other) => cost.compareTo(other.cost);

  @override
  String toString() {
    return 'Solution(cost: $cost, exercises: ${exercises.map((e) => "${e.ex.id}:${sets[exercises.indexOf(e)]}").join(", ")})';
  }
}
