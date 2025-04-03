import 'package:bodybuild/data/programmer/groups.dart';

enum Source {
  jeffNippard,
}

class Rating {
  final Source source;
  final double score;
  final List<ProgramGroup> pg;
  final String comment;
  final Map<String, String> modifiers;
  final Set<String> cues;
  const Rating({
    required this.source,
    required this.score,
    required this.pg,
    required this.comment,
    required this.modifiers,
    required this.cues,
  });
}

const ratingRowChestSupported = Rating(
  source: Source.jeffNippard,
  score: 7 / 7,
  pg: [
    ProgramGroup.lats,
    ProgramGroup.middleTraps,
  ],
  comment: '''
Jeff ranks the exercise [here](https://www.youtube.com/watch?v=jLvqKgW-_G8&t=8m53s)
and then upgrades it [here](https://www.youtube.com/watch?v=jLvqKgW-_G8&t=11m33s) to special+ ranking''',
  modifiers: {},
  cues: {},
);
const ratingRowCable = Rating(
  source: Source.jeffNippard,
  score: 6 / 7,
  pg: [
    ProgramGroup.lats,
    ProgramGroup.middleTraps,
  ],
  comment: '''
Jeff ranks the exercise [here](https://www.youtube.com/watch?v=jLvqKgW-_G8&t=9m22s)''',
  modifiers: {'spine': 'dynamic'},
  cues: {},
);
