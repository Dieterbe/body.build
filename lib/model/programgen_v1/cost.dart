import 'package:bodybuild/data/programmer/groups.dart';
import 'package:bodybuild/model/programmer/set_group.dart';

/// Calculates the cost of a SetGroup based on how well it matches the target recruitment values.
/// Cost is the sum of absolute differences between target and actual recruitment.
/// Overshooting (actual > target) is penalized 3x more than undershooting.
double calculateCost(Map<ProgramGroup, double> targets, SetGroup group) {
  var totalCost = 0.0;

  // For each target group, calculate actual recruitment and compare to target
  for (final entry in targets.entries) {
    final pg = entry.key;
    final recruitTarget = entry.value;

    // Sum up actual recruitment from all sets
    final actualValue = group.sets.fold(0.0, (sum, set) {
      return sum + set.recruitmentFiltered(pg, 0.5);
    });

    final diff = actualValue - recruitTarget;
    //  totalCost += (diff > 0) ? diff * 3 : diff.abs();
    totalCost += diff.abs();
  }

  return totalCost;
}
