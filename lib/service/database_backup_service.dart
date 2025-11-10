import 'dart:io';
import 'package:bodybuild/data/workouts/workout_database.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

/// Service for backing up and restoring the Drift SQLite database
///
/// **Uses VACUUM INTO (Official Drift Recommendation)**
///
/// This implementation follows the official Drift example:
/// https://drift.simonbinder.eu/docs/examples/existing_databases/#exporting-a-database
/// https://github.com/simolus3/drift/blob/develop/examples/app/lib/screens/backup/supported.dart
///
/// **Why VACUUM INTO instead of ATTACH DATABASE:**
/// - VACUUM INTO: Single SQLite command, creates complete compacted backup, simpler & more efficient
/// - ATTACH DATABASE: Multi-step process (attach, create tables, copy data), more complex & error-prone
///
/// **Requirements:**
/// - SQLite 3.37.0+ (2022) - bundled with NativeDatabase/drift_flutter
/// - For older SQLite versions (e.g., system SQLite on old Android), ATTACH DATABASE would be needed
///
/// **How it works:**
/// - Backup: `VACUUM INTO ?` creates a complete, optimized copy of the database
/// - Restore: Opens backup with sqlite3, validates with VACUUM INTO temp file, replaces current DB
class DatabaseBackupService {
  final WorkoutDatabase _database;

  DatabaseBackupService(this._database);

  /// Creates a backup of the entire database to the specified file
  ///
  /// Uses SQLite's VACUUM INTO command which:
  /// - Creates a complete copy of the database
  /// - Compacts the database (removes free pages)
  /// - Is atomic and efficient
  ///
  /// Returns true if successful, false otherwise
  Future<bool> createBackup(File backupFile) async {
    try {
      // Ensure parent directory exists
      await backupFile.parent.create(recursive: true);

      // Delete existing backup file if it exists
      // VACUUM INTO requires the target file to not exist
      if (await backupFile.exists()) {
        await backupFile.delete();
      }

      // Use VACUUM INTO to create a complete, compacted backup
      await _database.customStatement('VACUUM INTO ?', [backupFile.absolute.path]);

      return true;
    } catch (e) {
      print('Error creating backup: $e');
      return false;
    }
  }

  /// Restores the database from a backup file
  ///
  /// This follows the official Drift example approach:
  /// 1. Opens the backup file with sqlite3 package
  /// 2. Uses VACUUM INTO to copy it to a temporary location (validates it works)
  /// 3. Replaces the current database file with the validated backup
  ///
  /// WARNING: This will replace ALL current data with the backup data
  /// The database must be closed before calling this method
  ///
  /// Returns the path to the restored database file, or null if failed
  static Future<String?> restoreBackupStatic(File backupFile) async {
    try {
      // Verify backup file exists
      if (!await backupFile.exists()) {
        print('Backup file does not exist: ${backupFile.path}');
        return null;
      }

      // Open the backup database with sqlite3 to validate it
      final backupDb = sqlite3.open(backupFile.path);

      try {
        // Get the current database file path
        final dbFolder = await getApplicationDocumentsDirectory();
        final currentDbPath = p.join(dbFolder.path, 'workouts.sqlite');

        // Vacuum the backup into a temporary location first to validate it works
        final tempPath = await getTemporaryDirectory();
        final tempDb = p.join(tempPath.path, 'restore_temp.db');

        // Delete temp file if it exists
        final tempFile = File(tempDb);
        if (await tempFile.exists()) {
          await tempFile.delete();
        }

        // VACUUM INTO validates the backup and creates a clean copy
        backupDb.execute('VACUUM INTO ?', [tempDb]);

        // If we got here, the backup is valid. Replace the current database.
        await tempFile.copy(currentDbPath);
        await tempFile.delete();

        return currentDbPath;
      } finally {
        backupDb.dispose();
      }
    } catch (e) {
      print('Error restoring backup: $e');
      return null;
    }
  }
}
