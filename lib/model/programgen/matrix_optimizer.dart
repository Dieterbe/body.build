import 'package:ml_linalg/linalg.dart';
import 'package:ptc/data/programmer/groups.dart';
import 'package:ptc/model/programgen/rank.dart';
import 'package:ptc/model/programmer/set_group.dart';

class MatrixOptimizer {
  final Matrix recruitmentMatrix; // [exercises × program_groups]
  final Vector targetVector; // [program_groups]
  final List<RankedExercise> exercises;
  final List<ProgramGroup> programGroups;
  int setCombosTried = 0;

  MatrixOptimizer(List<RankedExercise> exs, Map<ProgramGroup, double> targets)
      : exercises = exs,
        programGroups = targets.keys.toList(),
        recruitmentMatrix = Matrix.fromList(
          List.generate(
            exs.length,
            (i) => List.generate(
              targets.length,
              (j) => exs[i]
                  .ex
                  .recruitment(targets.keys.elementAt(j)), // todo cutoff
            ),
          ),
        ),
        targetVector = Vector.fromList(targets.values.toList());

  // Calculate cost for a given set combination (vector of setcounts per exercise)
  double calculateCost(List<int> setCounts) {
    setCombosTried++;

    // Convert set counts to vector
    final setVector =
        Vector.fromList(setCounts.map((i) => i.toDouble()).toList());

    // Scale recruitment matrix by real set counts
    // we now have a matrix of size [exercises x program_groups] with "true" (set adjusted) recruitments
    final scaledRecruitments =
        recruitmentMatrix.mapColumns((col) => col * setVector);
    // sum up recruitments for each program group across all exercises
    final totalRecruitments = scaledRecruitments.reduceRows((a, b) => a + b);

    // Calculate difference from target
    final diff = totalRecruitments - targetVector;

    // maybe do this more optimized too
    var cost = 0.0;
    for (var i = 0; i < diff.length; i++) {
      cost += diff[i] > 0 ? diff[i] * 3 : -diff[i];
    }
    return cost;
  }

  SetGroup findOptimalSetGroup() {
    var bestCost = double.infinity;
    var bestSets = <int>[];

    void generateCombinations(List<int> current, int index) {
      if (index == exercises.length) {
        final cost = calculateCost(current);
        if (cost < bestCost) {
          bestCost = cost;
          bestSets = List.from(current);
          print(
              'Found better set combination with cost $cost: ${current.join(',')} sets');
        }
        return;
      }

      for (var sets = 1; sets <= 4; sets++) {
        current[index] = sets;
        generateCombinations(current, index + 1);
      }
    }

    generateCombinations(List.filled(exercises.length, 1), 0);
    print(
        'Finished optimizing sets. Best cost: $bestCost (tried $setCombosTried)');
    setCombosTried = 0;
    print('Best set counts: ${bestSets.join(',')}');

    return SetGroup(
      List.generate(
        exercises.length,
        (i) => Sets(60, ex: exercises[i].ex, n: bestSets[i]),
      ),
    );
  }
}
