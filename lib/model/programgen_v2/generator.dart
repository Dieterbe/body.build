import 'dart:async';

import 'package:ptc/data/programmer/groups.dart';
import 'package:ptc/model/programgen_v1/rank.dart';
import 'package:ptc/model/programmer/set_group.dart';
import 'package:ptc/model/programgen_v2/solution_node.dart';

/// Generates an optimized SetGroup that matches the desired recruitment targets
/// for each ProgramGroup as closely as possible while minimizing overshoot.
/// Returns a stream of solutions, with each new solution being better than the last.
Stream<SetGroup> generateOptimalSetGroup(
    Map<ProgramGroup, double> targetRecruitment) async* {
  final exercises = rankExercises();

  // caches to save CPU at runtime..
  final totalRecruitments =
      exercises.map((e) => e.ex.totalRecruitmentFiltered(0.5)).toList();
  final recruitments = List.generate(
    exercises.length,
    (i) => Map.fromEntries(
      ProgramGroup.values.map(
        (group) =>
            MapEntry(group, exercises[i].ex.recruitmentFiltered(group, 0.5)),
      ),
    ),
  );

  print('\nStarting workout generation:');
  print('Available exercises: ${exercises.length}');

  var bestSolution =
      SolutionNode.initial(exercises, recruitments, targetRecruitment);
  print('Best solution cost: ${bestSolution.cost}');
  var nodesExplored = 0;

  // Recursive function to explore solutions
  Future<SolutionNode> explore(SolutionNode current,
      StreamController<SetGroup> controller, String indent) async {
    nodesExplored++;
    //if (nodesExplored > 500000) {
    //  return current;
    // }
    if (nodesExplored % 1000 == 0) {
      print(
          '${indent}Explored $nodesExplored nodes, best.cost: ${bestSolution.cost}');
    }

    final highest = current.findHighestTarget();

    if (highest == null) {
      print('${indent}Next target-> none. reached max depth');
      // No significant targets remaining, we've descended as deep as we can.
      // Emit our best solution, if it' good
      if (current.cost < bestSolution.cost) {
        bestSolution = current;
        print('${indent}\nFound better solution:');
        print('${indent}Cost: ${current.cost}');
        print(
            '${indent}Exercises: ${current.exercises.map((e) => "${e.ex.id}:${current.sets[current.exercises.indexOf(e)]}").join(", ")}');

        // Emit new best solution
        controller.add(current.toSetGroup());
      }
      return bestSolution;
    }

    final (targetGroup, targetValue) = highest;

    var best = bestSolution;

    // Try each well-fitting exercise

    final (minRecruitment, maxRecruitment) = switch (targetValue) {
      // Large deficit: accept strong exercises. maybe could accept 0.5 here if we get close
      >= 1.0 => (0.5, 1.0),
      0.75 => (0.5, 0.75),
      >= 0.5 => (0.5, 0.75), // Medium deficit: avoid overshooting
      _ => (0.5, 0.5), // Small deficit: precise matching
    };

    for (final (i, exercise) in exercises.indexed) {
      final recruitment = recruitments[i][targetGroup]!;

      if (recruitment >= minRecruitment && recruitment <= maxRecruitment) {
        // Try adding one set for this exercise
        var newSolution = current.addSetFor(i);

        // All children that sufficiently improve upon their parent, are worth exploring.
        // even if e.g. the 2nd child does not improve upon the first child
        // if an exercise has total recruitment of, say 5, you would expect it to at least increase the score by 2.5
        // if not, too much of the recruitment goes towards overshooting sets
        if (newSolution.cost <= current.cost - (totalRecruitments[i] / 2)) {
          print(
              '${indent}Next target: ${targetGroup.name} ($targetValue) -> Trying ${exercise.ex.id} -> cost: ${newSolution.cost}, diff ${current.cost - newSolution.cost} -> exploring it...');

          var result = await explore(newSolution, controller, '$indent  ');
          if (result.cost < best.cost) {
            best = result;
          }
        } else {
          print(
              '${indent}Next target: ${targetGroup.name} ($targetValue) -> Trying ${exercise.ex.id} -> cost: ${newSolution.cost}, diff ${current.cost - newSolution.cost} -> not exploring it');
        }
      }
    }

    return best; // at the root level, this is kindof redundant since we've put it on the stream and then close the stream
  }

  // Create stream controller to emit solutions
  final controller = StreamController<SetGroup>();

  // Start exploration and emit solutions
  explore(bestSolution, controller, "").then((_) {
    // Close stream when done
    print('All done!');

    controller.close();
  });

  // Return the stream
  yield* controller.stream;
}
