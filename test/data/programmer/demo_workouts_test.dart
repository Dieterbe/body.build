import 'package:flutter_test/flutter_test.dart';
import 'package:bodybuild/data/programmer/demo_workouts.dart';

void main() {
  group('Demo Workout Validation', () {
    test('demo1 should be valid after migration', () {
      // The demo workout should be valid (no validation errors)
      // This ensures that all exercises exist, tweaks are valid, and set counts are within limits
      final validationResult = demo1.validate();

      expect(
        validationResult,
        isNull,
        reason: 'Demo workout should be valid but got error: ${validationResult ?? 'unknown'}',
      );
    });
  });
}
