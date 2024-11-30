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

  print('Workout generation (generateOptimalSetGroup) start');
  print('Available exercises: ${exercises.length}');

  var bestSolution =
      SolutionNode.initial(exercises, recruitments, targetRecruitment);
  print('Best solution cost: ${bestSolution.cost}');
  var nodesExplored = 0;

  // Recursive function to explore solutions
  Future<void> explore(SolutionNode current,
      StreamController<SetGroup> controller, String indent) async {
    nodesExplored++;
    //if (nodesExplored > 500000) {
    //  return current;
    // }
    if (nodesExplored % 10000 == 0) {
      // give UI a chance to update
      await Future.delayed(Duration(milliseconds: 10));
    }
    if (nodesExplored % 50000 == 0) {
      print(
          '${indent}Explored $nodesExplored nodes, best.cost: ${bestSolution.cost}');
    }

    final targets = current.findTargets();
    if (targets.isEmpty) {
      print('${indent}Next targets -> none. Reached max depth');
      return;
    }

    var improvedForTarget = false;

    // Try each target group in order until we find improvements
    for (final (targetGroup, targetValue) in targets) {
      if (improvedForTarget) {
        // If we already went down the path of optimizing via a specific target,
        // then we should not spend any time trying other targets
        return;
      }
      // Select appropriate recruitment range based on deficit
      final (minRecruitment, maxRecruitment) = switch (targetValue) {
        // Large deficit: accept strong exercises. maybe could accept 0.5 here if we get close
        >= 1.0 => (0.5, 1.0),
        0.75 => (0.5, 0.75),
        >= 0.5 => (0.5, 0.75), // Medium deficit: avoid overshooting
        _ => (0.5, 0.5), // Small deficit: precise matching
      };

      // Try each well-fitting exercise
      for (final (i, exercise) in exercises.indexed) {
        final recruitment = recruitments[i][targetGroup]!;

        if (recruitment >= minRecruitment && recruitment <= maxRecruitment) {
          // TODO: once we dip under minRecruitment we can probably break out
          // Try adding one set for this exercise
          var newSolution = current.addSetFor(i);

          // All children that sufficiently improve upon their parent, are worth exploring.
          // even if e.g. the 2nd child does not improve upon the first child
          // if an exercise has total recruitment of, say 5, to be considered a good addition,
          // you would expect it to:
          // - add 4 of useful volume
          // - worst case, add 1 of overshoot
          // therefore, to have a score of at least 4 -2 = 2. for now we have a higher bar: to at least increase the score by 3.5
          // if not, too much of the recruitment goes towards overshooting sets

          if (newSolution.cost <= current.cost - (totalRecruitments[i] * 0.7)) {
            //   print(
            //     '${indent}Next target: ${targetGroup.name} ($targetValue) -> Trying ${exercise.ex.id} -> cost: ${newSolution.cost}, diff ${current.cost - newSolution.cost} -> exploring it...');
            improvedForTarget = true;
            if (newSolution.cost < bestSolution.cost) {
              bestSolution = newSolution;
              print(
                  '${indent}Found better solution with cost ${bestSolution.cost}:');
              // print(
              //   '${indent}Exercises: ${newSolution.exercises.map((e) => "${e.ex.id}:${newSolution.sets[newSolution.exercises.indexOf(e)]}").join(", ")}');

              // Emit new best solution
              controller.add(newSolution.toSetGroup());
            }
            await explore(newSolution, controller, '$indent  ');
          } else {
            //      print(
            //        '${indent}Next target: ${targetGroup.name} ($targetValue) -> Trying ${exercise.ex.id} -> cost: ${newSolution.cost}, diff ${current.cost - newSolution.cost} -> not exploring it');
          }
        }
      }
    }
  }

  // Create stream controller to emit solutions
  final controller = StreamController<SetGroup>();

  // Start exploration and emit solutions
  controller.add(bestSolution.toSetGroup());
  explore(bestSolution, controller, "").then((_) {
    print('Workout generation (generateOptimalSetGroup) finished.');

    controller.close();
  });
  yield* controller.stream;
}
