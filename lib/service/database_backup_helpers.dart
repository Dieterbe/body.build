import 'dart:io';
// Conditionally import the backup service - only available on non-web
import 'package:bodybuild/service/database_backup_service.dart'
    if (dart.library.html) 'database_backup_helpers_stub.dart';
import 'package:path/path.dart' as path;

/// Helper functions for database backup that don't require sqlite3
/// These can be used on all platforms including web

/// Gets the default backup filename with timestamp
/// Uses .backup extension instead of .db so file managers don't hide it
String getDefaultBackupFilename() {
  final now = DateTime.now();
  final timestamp =
      '${now.year}${now.month.toString().padLeft(2, '0')}'
      '${now.day.toString().padLeft(2, '0')}_'
      '${now.hour.toString().padLeft(2, '0')}'
      '${now.minute.toString().padLeft(2, '0')}';
  return 'bodybuild_$timestamp.backup';
}

/// Gets backup file info (size, modification date)
Future<Map<String, dynamic>?> getBackupInfo(File backupFile) async {
  try {
    if (!await backupFile.exists()) return null;

    final stat = await backupFile.stat();
    return {
      'path': backupFile.path,
      'size': stat.size,
      'modified': stat.modified,
      'filename': path.basename(backupFile.path),
    };
  } catch (e) {
    print('Error getting backup info: $e');
    return null;
  }
}

/// Restores database from backup file
/// Delegates to DatabaseBackupService.restoreBackupStatic
Future<String?> restoreBackup(File backupFile) async {
  return await DatabaseBackupService.restoreBackupStatic(backupFile);
}
