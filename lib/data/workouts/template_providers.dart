import 'package:bodybuild/data/workouts/workout_providers.dart';
import 'package:bodybuild/model/interchange/program_export.dart';
import 'package:bodybuild/model/programmer/program_state.dart';
import 'package:bodybuild/model/workouts/template.dart' as model;
import 'package:bodybuild/service/program_import_service.dart';
import 'package:bodybuild/service/template_persistence_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'template_providers.g.dart';

@riverpod
TemplatePersistenceService templatePersistenceService(Ref ref) {
  final database = ref.watch(workoutDatabaseProvider);
  return TemplatePersistenceService(database);
}

@riverpod
class TemplateManager extends _$TemplateManager {
  @override
  Stream<List<model.WorkoutTemplate>> build() {
    final service = ref.watch(templatePersistenceServiceProvider);
    return service.watchAllTemplates();
  }

  Future<String> createTemplate(model.WorkoutTemplate template) async {
    final service = ref.read(templatePersistenceServiceProvider);
    return service.createTemplate(template);
  }

  Future<void> deleteTemplate(String id) async {
    final service = ref.read(templatePersistenceServiceProvider);
    await service.deleteTemplate(id);
  }

  /// Import a program from a [ProgramExport] (already parsed, migration applied by caller)
  Future<ProgramImportResult> importProgramFromExport(ProgramExport export) async {
    final database = ref.read(workoutDatabaseProvider);
    final importService = ProgramImportService(database);
    final result = await importService.importProgram(export);
    if (result.success) ref.invalidateSelf();
    return result;
  }

  /// Persist an already-migrated [ProgramState] as workout templates.
  Future<ProgramImportResult> importTemplatesFromProgram(ProgramState program) async {
    final templates = program.toTemplates();
    final service = ref.read(templatePersistenceServiceProvider);
    for (final template in templates) {
      await service.createTemplate(template);
    }
    ref.invalidateSelf();
    return ProgramImportResult.ok(templates);
  }
}
