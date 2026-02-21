import 'package:bodybuild/data/dataset/exercise_versioning.dart';
import 'package:bodybuild/model/programmer/program_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'program_export.freezed.dart';
part 'program_export.g.dart';

/// Current version of the interchange format schema.
/// Increment when making breaking changes to the ProgramExport structure.
const int programExportFormatVersion = 1;

/// Interchange format for exporting/importing programs between devices.
/// Contains the program data along with version metadata for compatibility checking.
@freezed
abstract class ProgramExport with _$ProgramExport {
  const factory ProgramExport({
    /// Version of the interchange format schema (for future migrations)
    @Default(programExportFormatVersion) int formatVersion,

    /// Version of the exercise dataset used when creating this export
    required int exerciseDatasetVersion,
    required ProgramState program,
    DateTime? exportedAt,
    String? exportedFrom,
  }) = _ProgramExport;

  factory ProgramExport.fromJson(Map<String, dynamic> json) => _$ProgramExportFromJson(json);

  /// Create an export from a [ProgramState], stamping the current dataset version and timestamp.
  factory ProgramExport.fromProgram(ProgramState program, {String? exportedFrom}) => ProgramExport(
    exerciseDatasetVersion: exerciseDatasetVersion,
    program: program,
    exportedAt: DateTime.now(),
    exportedFrom: exportedFrom,
  );

  /// Migrate and validate a program without needing a DB.
  /// Returns the migrated [ProgramState] and whether migration was applied.
  /// Throws a [String] error message on failure.
  static ProgramState migrateAndValidate(ProgramExport export) {
    if (export.formatVersion > programExportFormatVersion) {
      throw 'Export format v${export.formatVersion} is not supported '
          '(max: v$programExportFormatVersion). Please update the app.';
    }
    if (export.exerciseDatasetVersion > exerciseDatasetVersion) {
      throw 'Export requires exercise dataset v${export.exerciseDatasetVersion}, '
          'but this app only supports upto v$exerciseDatasetVersion. Please update the app.';
    }

    final program = export.exerciseDatasetVersion < exerciseDatasetVersion
        ? export.program.migrate(export.exerciseDatasetVersion)
        : export.program;

    final validationError = program.validate();
    if (validationError != null) throw validationError;

    return program;
  }
}
