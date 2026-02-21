import 'dart:convert';
import 'dart:io';

import 'package:bodybuild/model/interchange/program_export.dart';
import 'package:bodybuild/service/program_export_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Pick a JSON file and parse it as a [ProgramExport].
/// Returns null if the user cancelled or the file is invalid.
Future<ProgramExport?> pickProgramFile() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['json'],
    withData: true,
  );
  if (result == null || result.files.isEmpty) return null;

  final bytes = result.files.firstOrNull?.bytes;
  if (bytes == null) return null;

  try {
    final jsonString = utf8.decode(bytes);
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return ProgramExport.fromJson(json);
  } catch (e) {
    debugPrint('Failed to parse picked file: $e');
    return null;
  }
}

/// Save a [ProgramExport] as a JSON file.
/// On web/desktop: opens a save-file dialog via file_picker.
/// On mobile: shares via the OS share sheet.
Future<void> saveProgramFile(ProgramExport export) async {
  final jsonString = ProgramExportService().toJson(export);
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

String _sanitizeFileName(String name) =>
    name.replaceAll(RegExp(r'[^\w\s-]'), '').replaceAll(RegExp(r'\s+'), '_').toLowerCase();
