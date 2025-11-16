import 'package:bodybuild/data/dataset/exercises.dart';
import 'package:bodybuild/model/programmer/set_group.dart';

/// Represents a base exercise with all its variations
class GroupedExercise {
  final Ex baseExercise;
  final List<Sets> variations;
  final bool isExpanded;

  const GroupedExercise({
    required this.baseExercise,
    required this.variations,
    this.isExpanded = false,
  });

  GroupedExercise copyWith({Ex? baseExercise, List<Sets>? variations, bool? isExpanded}) {
    return GroupedExercise(
      baseExercise: baseExercise ?? this.baseExercise,
      variations: variations ?? this.variations,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}
