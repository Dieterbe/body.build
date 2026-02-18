import 'dart:convert';
import 'dart:io';

import 'package:bodybuild/data/dataset/exercise_versioning.dart';
import 'package:bodybuild/model/interchange/program_export.dart';
import 'package:bodybuild/model/programmer/program_state.dart';
import 'package:bodybuild/model/workouts/template.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Service for exporting workout templates as programs
class ProgramExportService {
  /// Create a ProgramExport from a list of templates.
  /// Groups templates by program name (extracted from workout name prefix).
  /// If templates don't share a common prefix, uses the provided programName.
  ProgramExport createExport({
    required List<WorkoutTemplate> templates,
    String? programName,
    String? exportedFrom,
  }) {
    if (templates.isEmpty) {
      throw ArgumentError('Cannot export empty template list');
    }

    // Extract workouts from templates
    final workouts = templates.map((t) => t.workout).toList();

    // Determine program name
    final name = programName ?? _inferProgramName(templates) ?? 'Exported Program';

    // Check if all templates are builtin
    final allBuiltin = templates.every((t) => t.isBuiltin);

    final program = ProgramState(name: name, workouts: workouts, builtin: allBuiltin);

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

  /// Export templates and share as JSON file
  Future<void> exportAndShare({
    required List<WorkoutTemplate> templates,
    String? programName,
  }) async {
    final export = createExport(
      templates: templates,
      programName: programName,
      exportedFrom: 'body.build mobile app',
    );

    final jsonString = toJson(export);

    // Write to temporary file
    final tempDir = await getTemporaryDirectory();
    final fileName = '${_sanitizeFileName(export.program.name)}.json';
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsString(jsonString);

    // Share the file
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Workout Program: ${export.program.name}',
      text: 'Exported from body.build',
    );
  }

  /// Infer program name from template names by finding common prefix
  String? _inferProgramName(List<WorkoutTemplate> templates) {
    if (templates.length == 1) {
      return templates.first.name;
    }

    // Look for common prefix ending with " / "
    final names = templates.map((t) => t.name).toList();
    final firstParts = names.first.split(' / ');

    if (firstParts.length < 2) {
      return null; // No program prefix
    }

    final programPrefix = firstParts.first;

    // Check if all templates share this prefix
    final allMatch = names.every((name) => name.startsWith('$programPrefix / '));

    return allMatch ? programPrefix : null;
  }

  /// Sanitize filename for file system
  String _sanitizeFileName(String name) {
    return name.replaceAll(RegExp(r'[^\w\s-]'), '').replaceAll(RegExp(r'\s+'), '_').toLowerCase();
  }
}
