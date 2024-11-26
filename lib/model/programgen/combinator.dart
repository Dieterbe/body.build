import 'package:ptc/model/programgen/rank.dart';
import 'package:ptc/model/programgen/util.dart';

combinator(List<RankedExercise> exercises, int minExercises, int maxExercises,
    Function(List<RankedExercise>) callback) {
  var results = 0;
  var totalResults = 0;
  for (var numExercises = minExercises;
      numExercises <= maxExercises;
      numExercises++) {
    totalResults += unorderedUniqueCombinations(numExercises, exercises.length);
  }
  for (var numExercises = minExercises;
      numExercises <= maxExercises;
      numExercises++) {
    // Generate all unique combinations of exactly numExercises exercises
    // and call callback with each one
    void generateCombinations(List<RankedExercise> current, int start) {
      if (current.length == numExercises) {
        results++;
        if (results % 10000 == 0) {
          print('combinator at $results / $totalResults');
        }
        callback(current);
        return;
      }

      for (var i = start; i < exercises.length; i++) {
        current.add(exercises[i]);
        generateCombinations(current, i + 1);
        current.removeLast();
      }
    }

    generateCombinations([], 0);
  }
}
