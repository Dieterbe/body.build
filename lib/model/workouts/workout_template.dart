import 'package:bodybuild/data/dataset/program_group.dart';
import 'package:bodybuild/model/programmer/workout.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_template.freezed.dart';
part 'workout_template.g.dart';

@freezed
abstract class WorkoutTemplate with _$WorkoutTemplate {
  const WorkoutTemplate._();

  const factory WorkoutTemplate({
    required String id,
    String? description,
    @Default(false) bool isBuiltin,
    required DateTime createdAt,
    required DateTime updatedAt,
    required Workout workout,
  }) = _WorkoutTemplate;

  factory WorkoutTemplate.fromJson(Map<String, dynamic> json) => _$WorkoutTemplateFromJson(json);

  /// Convenience accessor for the workout name
  String get name => workout.name;

  /// Calculate total recruitment for each ProgramGroup across all exercises in this template
  Map<ProgramGroup, double> calculateRecruitments() {
    return workout.setGroups.expand((g) => g.sets).fold<Map<ProgramGroup, double>>({}, (
      recruitments,
      sets,
    ) {
      if (sets.ex == null) return recruitments;

      // Accumulate recruitment for each muscle group
      return {
        for (final pg in ProgramGroup.values)
          pg: (recruitments[pg] ?? 0) + sets.ex!.recruitment(pg, sets.tweakOptions).volume * sets.n,
      };
    });
  }

  /// Expand setGroups into a flat ordered list of (exerciseId, tweaks, reps, rir)
  /// records, interleaving sets within each group according to their repeat
  /// count `n`. reps and rir are the targets to pre-fill on the planned sets,
  /// and are null when the program didn't specify them.
  /// This is used when starting a workout from a template.
  List<({String exerciseId, Map<String, String> tweaks, int? reps, int? rir})> toFlatSets() {
    final result = <({String exerciseId, Map<String, String> tweaks, int? reps, int? rir})>[];
    for (final group in workout.setGroups) {
      final maxN = group.sets.map((s) => s.n).fold(1, (a, b) => a > b ? a : b);
      for (var round = 0; round < maxN; round++) {
        for (final sets in group.sets) {
          if (round < sets.n) {
            final exerciseId = sets.ex?.id;
            if (exerciseId == null) {
              throw Exception(
                'Exercise not found in workout "${workout.name}": ${sets.ex?.id ?? 'null'}',
              );
            }
            result.add((
              exerciseId: exerciseId,
              tweaks: sets.tweakOptions,
              reps: sets.reps,
              rir: sets.rir,
            ));
          }
        }
      }
    }
    return result;
  }
}
