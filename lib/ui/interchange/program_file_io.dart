import 'dart:convert';
import 'dart:io';
import 'dart:js_interop';

import 'package:bodybuild/model/interchange/program_export.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:web/web.dart' as web if (dart.library.io) '';

/// Pick a JSON file and parse it as a [ProgramExport].
/// Returns null if the user cancelled or the file is invalid.
/// May throw an exception if the file is invalid.
Future<ProgramExport?> pickProgramFile() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['json'],
    withData: true,
  );
  if (result == null || result.files.isEmpty) return null;

  final bytes = result.files.firstOrNull?.bytes;
  if (bytes == null) return null;

  final jsonString = utf8.decode(bytes);
  final json = jsonDecode(jsonString) as Map<String, dynamic>;
  return ProgramExport.fromJson(json);
}

/// Save a [ProgramExport] as a JSON file.
/// On web: triggers browser download.
/// On desktop: opens a save-file dialog via file_picker.
/// On mobile: shares via the OS share sheet.
Future<void> saveProgramFile(ProgramExport export) async {
  final jsonString = const JsonEncoder.withIndent('  ').convert(export.toJson());
  final fileName = '${_sanitizeFileName(export.program.name)}.json';
  final bytes = Uint8List.fromList(utf8.encode(jsonString));

  if (kIsWeb) {
    // Web: trigger download using blob
    final jsBytes = bytes.toJS;
    final parts = [jsBytes].toJS;
    final blob = web.Blob(parts, web.BlobPropertyBag(type: 'application/json'));
    final url = web.URL.createObjectURL(blob);
    final anchor = web.HTMLAnchorElement()
      ..href = url
      ..download = fileName;
    web.document.body!.appendChild(anchor);
    anchor.click();
    web.document.body!.removeChild(anchor);
    web.URL.revokeObjectURL(url);
    return;
  }

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // Desktop: use file picker save dialog
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
