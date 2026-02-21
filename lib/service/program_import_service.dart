import 'package:bodybuild/model/workouts/template.dart';

/// Result of a program import operation
class ProgramImportResult {
  final bool success;
  final List<WorkoutTemplate> templates;
  final List<String> logs;
  final String? error;
  final bool migrationApplied;

  const ProgramImportResult({
    required this.success,
    this.templates = const [],
    this.logs = const [],
    this.error,
    this.migrationApplied = false,
  });

  factory ProgramImportResult.failure(String error, {List<String> logs = const []}) {
    return ProgramImportResult(success: false, error: error, logs: logs);
  }

  factory ProgramImportResult.ok(
    List<WorkoutTemplate> templates, {
    List<String> logs = const [],
    bool migrationApplied = false,
  }) {
    return ProgramImportResult(
      success: true,
      templates: templates,
      logs: logs,
      migrationApplied: migrationApplied,
    );
  }
}
