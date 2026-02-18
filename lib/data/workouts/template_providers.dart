import 'package:bodybuild/data/workouts/workout_providers.dart';
import 'package:bodybuild/model/interchange/program_export.dart';
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

  /// Import a program from JSON string (interchange format)
  Future<ProgramImportResult> importProgramFromJson(String jsonString) async {
    final database = ref.read(workoutDatabaseProvider);
    final importService = ProgramImportService(database);

    final export = importService.parseExportJson(jsonString);
    if (export == null) {
      return ProgramImportResult.failure('Invalid program format');
    }

    final result = await importService.importProgram(export);
    if (result.success) {
      ref.invalidateSelf();
    }
    return result;
  }
}
