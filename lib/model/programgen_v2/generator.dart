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
  print('\nStarting workout generation:');
  print('Available exercises: ${exercises.length}');

  var bestSolution = SolutionNode.initial(targetRecruitment);
  var nodesExplored = 0;

  // Recursive function to explore solutions
  Future<SolutionNode> explore(
      SolutionNode current, StreamController<SetGroup> controller) async {
    nodesExplored++;
    if (nodesExplored % 1000 == 0) {
      print(
          'Explored $nodesExplored nodes, current best cost: ${bestSolution.cost}');
    }

    // Find highest remaining target
    final highest = current.findHighestTarget();

    if (highest == null) {
      // No significant targets remaining, potential solution
      if (current.cost < bestSolution.cost) {
        bestSolution = current;
        print('\nFound better solution:');
        print('Cost: ${current.cost}');
        print(
            'Exercises: ${current.exercises.map((e) => "${e.ex.id}:${current.setCounts[current.exercises.indexOf(e)]}").join(", ")}');

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
      >= 1.0 => (0.75, 1.0),
      0.75 => (0.5, 0.75),
      >= 0.5 => (0.5, 0.75), // Medium deficit: avoid overshooting
      _ => (0.5, 0.5), // Small deficit: precise matching
    };

    for (final exercise in exercises) {
      final recruitment = exercise.ex.recruitment(targetGroup);

      if (recruitment >= minRecruitment && recruitment <= maxRecruitment) {
        // Try adding one set for this exercise
        var newSolution = current.addSetFor(exercise);

        // Only explore this branch if it has potential
        // TODO: we may need to tolerate a small amount of worsening here, if it leads
        // to a great solution deeper down
        if (newSolution.cost < best.cost) {
          var result = await explore(newSolution, controller);
          if (result.cost < best.cost) {
            best = result;
          }
        }
      }
    }

    return best;
  }

  // Create stream controller to emit solutions
  final controller = StreamController<SetGroup>();

  // Start exploration and emit solutions
  explore(bestSolution, controller).then((_) {
    // Close stream when done
    controller.close();
  });

  // Return the stream
  yield* controller.stream;
}
