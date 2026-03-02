import 'dart:convert';

import 'package:bodybuild/data/workouts/workout_database.dart' as db;
import 'package:bodybuild/model/programmer/workout.dart' as programmer;
import 'package:bodybuild/model/workouts/workout_template.dart' as model;
import 'package:drift/drift.dart';

class TemplatePersistenceService {
  final db.WorkoutDatabase _database;

  TemplatePersistenceService(this._database);

  // Convert Drift Template to model WorkoutTemplate
  model.WorkoutTemplate _toModel(db.Template template) {
    final decodedJson = json.decode(template.workoutJson);
    if (decodedJson is! Map<String, dynamic>) {
      throw FormatException(
        'Invalid JSON format in template ${template.id}: expected Map, got ${decodedJson.runtimeType}',
      );
    }

    return model.WorkoutTemplate(
      id: template.id,
      description: template.description,
      isBuiltin: template.isBuiltin,
      createdAt: template.createdAt,
      updatedAt: template.updatedAt,
      workout: programmer.Workout.fromJson(decodedJson),
    );
  }

  // Get all templates
  Future<List<model.WorkoutTemplate>> getAllTemplates() async {
    final templates = await _database.getAllTemplates();
    return templates.map(_toModel).toList();
  }

  // Watch all templates
  Stream<List<model.WorkoutTemplate>> watchAllTemplates() {
    return _database.watchAllTemplates().map((templates) => templates.map(_toModel).toList());
  }

  // Get template by ID
  Future<model.WorkoutTemplate?> getTemplateById(String id) async {
    final template = await _database.getTemplateById(id);
    if (template == null) return null;
    return _toModel(template);
  }

  // Create a new template
  Future<String> createTemplate(model.WorkoutTemplate template) async {
    await _database.insertTemplate(
      db.TemplatesCompanion.insert(
        id: template.id,
        description: Value(template.description),
        isBuiltin: Value(template.isBuiltin),
        workoutJson: json.encode(template.workout.toJson()),
        createdAt: template.createdAt,
        updatedAt: template.updatedAt,
      ),
    );
    return template.id;
  }

  // Delete a template
  Future<void> deleteTemplate(String id) async {
    await _database.deleteTemplate(id);
  }
}
