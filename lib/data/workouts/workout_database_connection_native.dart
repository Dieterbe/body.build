import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Native platform database connection (mobile/desktop)
/// Uses LazyDatabase to defer opening until first access, then uses
/// NativeDatabase.createInBackground to run all database operations in a separate isolate
/// This prevents blocking the UI thread during heavy operations like bulk imports
QueryExecutor openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'workouts.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
