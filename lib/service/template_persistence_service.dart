import 'package:bodybuild/data/workouts/workout_database.dart' as db;
import 'package:bodybuild/model/workouts/template.dart' as model;
import 'package:drift/drift.dart';

class TemplatePersistenceService {
  final db.WorkoutDatabase _database;

  TemplatePersistenceService(this._database);

  // Convert Drift Template to model WorkoutTemplate with sets
  Future<model.WorkoutTemplate> _templateWithSets(db.Template template) async {
    final sets = await _database.getTemplateSets(template.id);
    return model.WorkoutTemplate(
      id: template.id,
      name: template.name,
      description: template.description,
      isBuiltin: template.isBuiltin,
      createdAt: template.createdAt,
      updatedAt: template.updatedAt,
      sets: sets
          .map(
            (s) => model.TemplateSet(
              id: s.id,
              templateId: s.templateId,
              exerciseId: s.exerciseId,
              tweaks: model.TemplateSet.tweaksFromJson(s.tweaks),
              setOrder: s.setOrder,
              createdAt: s.createdAt,
            ),
          )
          .toList(),
    );
  }

  // Get all templates with their sets
  Future<List<model.WorkoutTemplate>> getAllTemplates() async {
    final templates = await _database.getAllTemplates();
    return Future.wait(templates.map(_templateWithSets));
  }

  // Watch all templates with their sets
  Stream<List<model.WorkoutTemplate>> watchAllTemplates() {
    return _database.watchAllTemplates().asyncMap((templates) async {
      return Future.wait(templates.map(_templateWithSets));
    });
  }

  // Get template by ID with sets
  Future<model.WorkoutTemplate?> getTemplateById(String id) async {
    final template = await _database.getTemplateById(id);
    if (template == null) return null;
    return _templateWithSets(template);
  }

  // Create a new template with sets
  Future<String> createTemplate({
    required String id,
    required String name,
    String? description,
    bool isBuiltin = false,
    required List<model.TemplateSet> sets,
  }) async {
    final now = DateTime.now();

    await _database.insertTemplate(
      db.TemplatesCompanion.insert(
        id: id,
        name: name,
        description: Value(description),
        isBuiltin: Value(isBuiltin),
        createdAt: now,
        updatedAt: now,
      ),
    );

    // Insert sets
    for (final set in sets) {
      await _database.insertTemplateSet(
        db.TemplateSetsCompanion.insert(
          id: set.id,
          templateId: id,
          exerciseId: set.exerciseId,
          tweaks: set.tweaksJson,
          setOrder: set.setOrder,
          createdAt: now,
        ),
      );
    }

    return id;
  }

  // Delete a template and its sets
  Future<void> deleteTemplate(String id) async {
    await _database.deleteTemplateSets(id);
    await _database.deleteTemplate(id);
  }
}
