import 'dart:convert';
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
