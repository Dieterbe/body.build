import 'dart:convert';
import 'dart:io';

import 'package:bodybuild/model/interchange/program_export.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
// Web-specific imports
import 'package:universal_html/html.dart' as html;

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
  final jsonString = const JsonEncoder.withIndent('  ').convert(export.toJson());
  final fileName = '${_sanitizeFileName(export.program.name)}.json';
  final bytes = Uint8List.fromList(utf8.encode(jsonString));

  if (kIsWeb) {
    // Web: use download
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..download = fileName
      ..click();
    html.Url.revokeObjectUrl(url);
    return;
  }

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    final result = await FilePicker.platform.saveFile(
      dialogTitle: 'Save Program',
      fileName: fileName,
      type: FileType.custom,
      allowedExtensions: ['json'],
      bytes: bytes,
    );
    if (result == null) {
      // User cancelled
      return;
    }
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
