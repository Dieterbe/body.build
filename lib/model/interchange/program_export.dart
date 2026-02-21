import 'package:bodybuild/data/dataset/exercise_versioning.dart' as versioning;
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
    exerciseDatasetVersion: versioning.exerciseDatasetVersion,
    program: program,
    exportedAt: DateTime.now(),
    exportedFrom: exportedFrom,
  );

  /// Migrate and validate this export's program.
  /// Throws a [String] error message on failure.
  ProgramState migrateAndValidate() {
    if (formatVersion > programExportFormatVersion) {
      throw 'Export format v$formatVersion is not supported '
          '(max: v$programExportFormatVersion). Please update the app.';
    }
    if (exerciseDatasetVersion > versioning.exerciseDatasetVersion) {
      throw 'Export requires exercise dataset v$exerciseDatasetVersion, '
          'but this app only supports upto v${versioning.exerciseDatasetVersion}. Please update the app.';
    }

    final p = exerciseDatasetVersion < versioning.exerciseDatasetVersion
        ? program.migrate(exerciseDatasetVersion)
        : program;

    final validationError = p.validate();
    if (validationError != null) throw validationError;

    return p;
  }
}
