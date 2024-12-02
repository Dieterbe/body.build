import 'package:ml_linalg/linalg.dart';
import 'package:ptc/data/programmer/groups.dart';
import 'package:ptc/model/programgen_v1/rank.dart';
import 'package:ptc/model/programmer/set_group.dart';

class MatrixOptimizer {
  final Matrix recruitmentMatrix; // [exercises × program_groups]
  final Vector targetVector; // [program_groups]
  final List<RankedExercise> exercises;
  final List<ProgramGroup> programGroups;
  final List<List<double>> recruitmentData; // cached matrix data
  final List<double> targetData; // cached target data
  int setCombosTried = 0;

  MatrixOptimizer(List<RankedExercise> exs, Map<ProgramGroup, double> targets)
      : exercises = exs,
        programGroups = targets.keys.toList(),
        recruitmentMatrix = Matrix.fromList(
          List.generate(
            exs.length,
            (i) => List.generate(
              targets.length,
              (j) => exs[i].ex.recruitment(targets.keys.elementAt(j)),
            ),
          ),
        ),
        targetVector = Vector.fromList(targets.values.toList()),
        // Cache the data as lists for faster access
        recruitmentData = Matrix.fromList(
          List.generate(
            exs.length,
            (i) => List.generate(
              targets.length,
              (j) => exs[i].ex.recruitment(targets.keys.elementAt(j)),
            ),
          ),
        ).toList().map((row) => row.toList()).toList(),
        targetData = targets.values.toList();

  // Calculate cost for a given set combination (vector of setcounts per exercise)
  double calculateCost(List<int> setCounts) {
    setCombosTried++;
    var cost = 0.0;
    // For each program group
    for (var groupIdx = 0; groupIdx < programGroups.length; groupIdx++) {
      var totalRecruitment = 0.0;
      // Sum up (recruitment * sets) for each exercise
      for (var exIdx = 0; exIdx < exercises.length; exIdx++) {
        totalRecruitment += recruitmentData[exIdx][groupIdx] * setCounts[exIdx];
      }
      // Calculate cost component for this group
      final diff = totalRecruitment - targetData[groupIdx];
      //  cost += diff > 0 ? diff * 3 : -diff;
      cost += diff.abs();
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
