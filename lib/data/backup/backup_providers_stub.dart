// Stub for web - backup service not available
import 'dart:io';

class DatabaseBackupService {
  DatabaseBackupService(Object? _);

  Future<bool> createBackup(File _) {
    throw UnsupportedError('Backup is not supported on web');
  }
}
