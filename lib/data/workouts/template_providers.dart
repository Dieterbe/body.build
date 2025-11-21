import 'package:bodybuild/data/workouts/workout_providers.dart';
import 'package:bodybuild/model/workouts/template.dart' as model;
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

  Future<String> createTemplate({
    required String id,
    required String name,
    String? description,
    bool isBuiltin = false,
    required List<model.TemplateSet> sets,
  }) async {
    final service = ref.read(templatePersistenceServiceProvider);
    return service.createTemplate(
      id: id,
      name: name,
      description: description,
      isBuiltin: isBuiltin,
      sets: sets,
    );
  }

  Future<void> deleteTemplate(String id) async {
    final service = ref.read(templatePersistenceServiceProvider);
    await service.deleteTemplate(id);
  }
}
