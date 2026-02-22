import 'package:bodybuild/data/workouts/workout_providers.dart';
import 'package:bodybuild/model/programmer/program_state.dart';
import 'package:bodybuild/model/workouts/template.dart' as model;
import 'package:bodybuild/service/template_persistence_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'template_provider.g.dart';

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

  /// Persist an already-migrated [ProgramState] as workout templates.
  Future<void> importTemplatesFromProgram(ProgramState program) async {
    final templates = program.toTemplates();
    final service = ref.read(templatePersistenceServiceProvider);
    for (final template in templates) {
      await service.createTemplate(template);
    }
    ref.invalidateSelf();
  }
}
