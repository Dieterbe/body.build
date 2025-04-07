import 'package:bodybuild/data/programmer/groups.dart';

enum Source {
  jeffNippard,
  mennoHenselmans,
}

/* note that in jeff's videos, sometimes a rating is dependent on:
- your weight lift status (beginner - intermediate - advanced)
- what feels good to you - e.g. guillotine press vs bench press with bar further back
- type of exact machine (e.g. machine press)
we don't support all that nuance yet. for now let's just use the metrics
*/
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
    this.modifiers = const {},
    this.cues = const {},
  });
}
