import 'dart:convert';
import 'package:bodybuild/data/dataset/ex.dart';
import 'package:bodybuild/data/dataset/program_group.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'template.freezed.dart';
part 'template.g.dart';

@freezed
abstract class WorkoutTemplate with _$WorkoutTemplate {
  const WorkoutTemplate._();

  const factory WorkoutTemplate({
    required String id,
    required String name,
    String? description,
    @Default(false) bool isBuiltin,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default([]) List<TemplateSet> sets,
  }) = _WorkoutTemplate;

  factory WorkoutTemplate.fromJson(Map<String, dynamic> json) => _$WorkoutTemplateFromJson(json);

  /// Calculate total recruitment for each ProgramGroup across all exercises in this template
  Map<ProgramGroup, double> calculateRecruitments() {
    // Build a map of exercise IDs to Ex objects for quick lookup
    final exerciseMap = {for (final ex in exes) ex.id: ex};

    return sets.fold<Map<ProgramGroup, double>>({}, (recruitments, templateSet) {
      final exercise = exerciseMap[templateSet.exerciseId];
      if (exercise == null) return recruitments;

      // Accumulate recruitment for each muscle group
      return {
        ...recruitments,
        for (final pg in ProgramGroup.values)
          pg: (recruitments[pg] ?? 0) + exercise.recruitment(pg, templateSet.tweaks).volume,
      };
    });
  }
}

@freezed
abstract class TemplateSet with _$TemplateSet {
  const TemplateSet._();

  const factory TemplateSet({
    required String id,
    required String templateId,
    required String exerciseId,
    @Default({}) Map<String, String> tweaks,
    required int setOrder,
    required DateTime createdAt,
  }) = _TemplateSet;

  factory TemplateSet.fromJson(Map<String, dynamic> json) => _$TemplateSetFromJson(json);

  String get tweaksJson => json.encode(tweaks);

  static Map<String, String> tweaksFromJson(String jsonStr) {
    if (jsonStr.isEmpty) return {};
    final decoded = json.decode(jsonStr);
    return Map<String, String>.from(decoded);
  }
}
