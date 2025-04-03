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
