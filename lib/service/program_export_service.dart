import 'dart:convert';

import 'package:bodybuild/data/dataset/exercise_versioning.dart';
import 'package:bodybuild/model/interchange/program_export.dart';
import 'package:bodybuild/model/programmer/program_state.dart';
import 'package:bodybuild/model/workouts/template.dart';

/// Service for exporting workout templates as programs
class ProgramExportService {
  /// Create a ProgramExport from a list of templates.
  ProgramExport createExportFromTemplates({
    required List<WorkoutTemplate> templates,
    String? programName,
    String? exportedFrom,
  }) {
    if (templates.isEmpty) {
      throw ArgumentError('Cannot export empty template list');
    }

    final workouts = templates.map((t) => t.workout).toList();
    final name = programName ?? _inferProgramName(templates) ?? 'Exported Program';
    final allBuiltin = templates.every((t) => t.isBuiltin);
    final program = ProgramState(name: name, workouts: workouts, builtin: allBuiltin);

    return ProgramExport(
      exerciseDatasetVersion: exerciseDatasetVersion,
      program: program,
      exportedAt: DateTime.now(),
      exportedFrom: exportedFrom,
    );
  }

  /// Create a ProgramExport directly from a ProgramState.
  ProgramExport createExportFromProgram({required ProgramState program, String? exportedFrom}) {
    return ProgramExport(
      exerciseDatasetVersion: exerciseDatasetVersion,
      program: program,
      exportedAt: DateTime.now(),
      exportedFrom: exportedFrom,
    );
  }

  /// Serialize a ProgramExport to JSON string
  String toJson(ProgramExport export) {
    return const JsonEncoder.withIndent('  ').convert(export.toJson());
  }

  /// Infer program name from template names by finding common prefix
  String? _inferProgramName(List<WorkoutTemplate> templates) {
    if (templates.length == 1) return templates.first.name;

    final names = templates.map((t) => t.name).toList();
    final firstParts = names.first.split(' / ');
    if (firstParts.length < 2) return null;

    final programPrefix = firstParts.first;
    final allMatch = names.every((name) => name.startsWith('$programPrefix / '));
    return allMatch ? programPrefix : null;
  }
}
