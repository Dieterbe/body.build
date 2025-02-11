import 'package:bodybuild/data/programmer/exercises.dart';
import 'package:bodybuild/data/programmer/groups.dart';

class RankedExercise {
  final Ex ex;
  final double rank;

  RankedExercise(this.ex, this.rank);
}

// sorts a list of exercises DESC by rank
// rank is the total recruitment
// if multiple exercises have identical recruitment profiles, only one is included
List<RankedExercise> rankExercises(List<Ex> input) {
  // Create a map to group exercises by their recruitment profile
  final profileMap = <String, RankedExercise>{};

  for (final ex in input) {
    // Create a string key representing the recruitment profile
    // Format: "group1:value1,group2:value2,..."
    // when we hash out Assign "modalities" further, we need to consider whether
    // it should be part of the profile
    final profile = ProgramGroup.values
        .map((pg) => '${pg.name}:${ex.recruitment(pg, {}).volume}')
        .join(',');

    final rank = ex.totalRecruitment({});
    profileMap[profile] = RankedExercise(ex, rank);
  }

  // Convert map values to list and sort by rank
  final ranks = profileMap.values.toList()
    ..sort((a, b) => b.rank.compareTo(a.rank));
  print('ranker filter: ${ranks.length} / ${input.length}');
  return ranks;
}
