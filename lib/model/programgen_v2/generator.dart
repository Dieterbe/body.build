import 'dart:async';
import 'dart:isolate';
import 'package:bodybuild/data/programmer/groups.dart';
import 'package:bodybuild/model/programgen_v1/rank.dart';
import 'package:bodybuild/model/programmer/set_group.dart';
import 'package:bodybuild/model/programgen_v2/solution_node.dart';
import 'package:bodybuild/model/programmer/settings.dart';

/// Parameters for workout generation
class WorkoutGenerationParams {
  final Map<ProgramGroup, double> targetRecruitment;
  final Settings setup;
  final SendPort sendPort;

  const WorkoutGenerationParams(
    this.targetRecruitment,
    this.setup,
    this.sendPort,
  );
}

/// Generates an optimized SetGroup that matches the desired recruitment targets
/// for each ProgramGroup as closely as possible while minimizing overshoot.
/// Returns a stream of solutions, with each new solution being better than the last.
Stream<SetGroup> generateOptimalSetGroup(
    Map<ProgramGroup, double> targetRecruitment, Settings setup) async* {
  final receivePort = ReceivePort();

  final params = WorkoutGenerationParams(
    targetRecruitment,
    setup,
    receivePort.sendPort,
  );

  await Isolate.spawn(_generateInIsolate, params);

  await for (final solution in receivePort) {
    if (solution is SetGroup) {
      yield solution;
    } else if (solution == null) {
      // End of stream
      break;
    }
  }

  receivePort.close();
}

/// Isolate entry point
void _generateInIsolate(WorkoutGenerationParams params) {
  print('Workout generation (generateOptimalSetGroup) start');

  final exercises = rankExercises(params.setup.availableExercises);

  print('Available exercises: ${exercises.length}');
  // caches to save CPU at runtime..
  final totalRecruitments =
      exercises.map((e) => e.ex.totalRecruitmentFiltered(0.5)).toList();
  // recruitment[i] = for exercise[i], its filtered recruitments for all PG's
  final recruitments = List.generate(
    exercises.length,
    (i) => Map.fromEntries(
      ProgramGroup.values.map(
        (group) => MapEntry(
            group, exercises[i].ex.recruitmentFiltered(group, 0.5).volume),
      ),
    ),
  );

  print('Workout generation (generateOptimalSetGroup) start');
  print('Available exercises: ${exercises.length}');

  var bestSolution =
      SolutionNode.initial(exercises, recruitments, params.targetRecruitment);
  print('Best solution cost: ${bestSolution.cost}');
  var nodesExplored = 0;

  // Recursive function to explore solutions
  Future<void> explore(SolutionNode current, String indent) async {
    nodesExplored++;
    //if (nodesExplored > 500000) {
    //  return current;
    // }
    if (nodesExplored % 10000 == 0) {
      // give UI a chance to update
      await Future.delayed(const Duration(milliseconds: 10));
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
      for (final (i, _) in exercises.indexed) {
        final recruitment = recruitments[i][targetGroup]!;

        if (recruitment >= minRecruitment && recruitment <= maxRecruitment) {
          // TODO: once we dip under minRecruitment we can probably break out
          // Try adding one set for this exercise
          var newSolution = current.addSetFor(i);

// -- the whole comment below is from before we changed cost calculation to be relative to target --
// -- i don't remember/understand where the 0.7 came from --
          // All children that sufficiently improve upon their parent, are worth exploring.
          // even if e.g. the 2nd child does not improve upon the first child
          // if an exercise has total recruitment of, say 5, to be considered a good addition,
          // you would expect it to:
          // - add 4 of useful volume
          // - worst case, add 1 of overshoot
          // therefore, to have a score of at least 4 -2 = 2. for now we have a higher bar: to at least increase the score by 3.5
          // if not, too much of the recruitment goes towards overshooting sets

          //  if (newSolution.cost <= current.cost - (totalRecruitments[i] * 0.7)) {
          if (newSolution.cost < current.cost) {
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
              params.sendPort.send(bestSolution.toSetGroup());
            }
            await explore(newSolution, '$indent  ');
          } else {
            //      print(
            //        '${indent}Next target: ${targetGroup.name} ($targetValue) -> Trying ${exercise.ex.id} -> cost: ${newSolution.cost}, diff ${current.cost - newSolution.cost} -> not exploring it');
          }
        }
      }
    }
  }

  // Start exploration and emit solutions
  params.sendPort.send(bestSolution.toSetGroup());
  explore(bestSolution, "").then((_) {
    print('Workout generation (generateOptimalSetGroup) finished.');
    params.sendPort.send(null); // Signal completion
  });
}
