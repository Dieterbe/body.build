import 'package:ptc/data/programmer/exercises.dart';
import 'package:ptc/data/programmer/groups.dart';

class RankedExercise {
  final Ex ex;
  final double rank;

  RankedExercise(this.ex, this.rank);
}

// return a list of all known exercises, sorted DESC by rank
// rank is the total recruitment
// if multiple exercises have identical recruitment profiles, only one is included
List<RankedExercise> rankExercises() {
  // Create a map to group exercises by their recruitment profile
  final profileMap = <String, RankedExercise>{};

  for (final ex in exes) {
    // Create a string key representing the recruitment profile
    // Format: "group1:value1,group2:value2,..."
    final profile = ProgramGroup.values
        .map((pg) => '${pg.name}:${ex.recruitment(pg)}')
        .join(',');

    final rank = ex.totalRecruitment();
    profileMap[profile] = RankedExercise(ex, rank);
  }

  // Convert map values to list and sort by rank
  final ranks = profileMap.values.toList()
    ..sort((a, b) => b.rank.compareTo(a.rank));
  print('ranker filter: ${ranks.length} / ${exes.length}');
  return ranks;
}
