import 'dart:convert';

import 'package:bodybuild/data/workouts/workout_database.dart';
import 'package:bodybuild/model/interchange/program_export.dart' show ProgramExport;
import 'package:bodybuild/model/workouts/template.dart';

import 'package:flutter/foundation.dart';

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

/// Service for importing programs from the interchange format
class ProgramImportService {
  final WorkoutDatabase _database;

  ProgramImportService(this._database);

  /// Parse and validate a program export JSON string
  ProgramExport? parseExportJson(String jsonString) {
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return ProgramExport.fromJson(json);
    } catch (e) {
      debugPrint('Failed to parse program export JSON: $e');
      return null;
    }
  }

  /// Import a program from the interchange format.
  /// Validates version compatibility, applies migrations if needed,
  /// and converts to WorkoutTemplates.
  /*
  Future<ProgramImportResult> importProgram(ProgramExport export) async {
    final logs = <String>[];
    final sourceVersion = export.exerciseDatasetVersion;

    logs.add('Importing program "${export.program.name}" from v$sourceVersion');

    // Check format version compatibility
    if (export.formatVersion > programExportFormatVersion) {
      return ProgramImportResult.failure(
        'Program export format v${export.formatVersion} is not supported. '
        'This app supports up to v$programExportFormatVersion. Please update the app.',
        logs: logs,
      );
    }

    // Check exercise dataset version compatibility
    if (sourceVersion > exerciseDatasetVersion) {
      return ProgramImportResult.failure(
        'Program requires exercise dataset v$sourceVersion, but this app only supports v$exerciseDatasetVersion. Please update the app.',
        logs: logs,
      );
    }

    // Apply migrations if needed
    ProgramState migratedProgram;
    bool migrationApplied = false;

    if (sourceVersion < exerciseDatasetVersion) {
      logs.add('Migrating from v$sourceVersion to v$exerciseDatasetVersion');
      try {
        migratedProgram = export.program.migrate(sourceVersion);
      } catch (e) {
        return ProgramImportResult.failure('Migration failed: $e', logs: logs);
      }
      migrationApplied = true;
    } else {
      migratedProgram = export.program;
    }

    // Validate all exercises exist
    final validationError = migratedProgram.validate();
    if (validationError != null) {
      return ProgramImportResult.failure(validationError, logs: logs);
    }

    // Convert to templates
    final templates = migratedProgram.toTemplates();
    logs.add('Created ${templates.length} workout templates');

    // Persist templates
    final templateService = TemplatePersistenceService(_database);
    for (final template in templates) {
      await templateService.createTemplate(template);
      logs.add('Saved template: ${template.name}');
    }

    return ProgramImportResult.ok(templates, logs: logs, migrationApplied: migrationApplied);
  }
  */
}
