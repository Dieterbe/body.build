import 'dart:convert';
import 'dart:io';

import 'package:bodybuild/data/dataset/exercise_versioning.dart';
import 'package:bodybuild/model/interchange/program_export.dart';
import 'package:bodybuild/model/programmer/program_state.dart';
import 'package:bodybuild/model/workouts/template.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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

  /// Save export as a JSON file.
  /// On web/desktop: opens a save-file dialog via file_picker.
  /// On mobile: shares via the OS share sheet.
  Future<void> saveFile(ProgramExport export) async {
    final jsonString = toJson(export);
    final fileName = '${_sanitizeFileName(export.program.name)}.json';
    final bytes = Uint8List.fromList(utf8.encode(jsonString));

    if (kIsWeb || Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      await FilePicker.platform.saveFile(
        dialogTitle: 'Save Program',
        fileName: fileName,
        type: FileType.custom,
        allowedExtensions: ['json'],
        bytes: bytes,
      );
      return;
    }

    // Mobile: share via OS share sheet
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(bytes);
    await Share.shareXFiles([
      XFile(file.path, mimeType: 'application/json'),
    ], subject: 'Workout Program: ${export.program.name}');
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

  /// Sanitize filename for file system
  String _sanitizeFileName(String name) {
    return name.replaceAll(RegExp(r'[^\w\s-]'), '').replaceAll(RegExp(r'\s+'), '_').toLowerCase();
  }
}
