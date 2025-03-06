import 'package:bodybuild/data/programmer/exercises.dart';
import 'package:bodybuild/data/programmer/groups.dart';
import 'package:bodybuild/data/programmer/modifier.dart';

void main() {
  print('Analyzing exercise recruitment combinations...\n');

  // Go through all exercises
  for (final exercise in exes) {
    // Create all possible modifier combinations
    final modifierCombinations =
        _generateModifierCombinations(exercise.modifiers);

    // For each combination, check recruitment for all program groups
    for (final modifierOptions in modifierCombinations) {
      // Check recruitment for each program group
      for (final group in ProgramGroup.values) {
        final result = exercise.recruitment(group, modifierOptions);

        // If recruitment has volume > 0 and merged non-zero values
        if (result.volume > 0 && result.multiplied) {
          print('Exercise: ${exercise.id}');
          print('Program Group: ${group.displayName}');
          print('Modifiers: ${_formatModifierOptions(modifierOptions)}');
          print('Recruitment: ${result.volume}');
          if (result.modality != null) {
            print('Modality: ${result.modality}');
          }
          print('---\n');
        }
      }
    }
  }
}

List<Map<String, String>> _generateModifierCombinations(
    List<Modifier> modifiers) {
  if (modifiers.isEmpty) return [<String, String>{}];

  final combinations = <Map<String, String>>[];
  final first = modifiers.first;
  final rest = modifiers.sublist(1);

  // Get combinations for the rest of the modifiers
  final subCombinations = _generateModifierCombinations(rest);

  // For each option of the first modifier
  for (final option in first.opts.keys) {
    // Combine with each sub-combination
    for (final subCombo in subCombinations) {
      final newCombo = Map<String, String>.from(subCombo);
      newCombo[first.name] = option;
      combinations.add(newCombo);
    }
  }

  return combinations;
}

String _formatModifierOptions(Map<String, String> options) {
  return options.entries.map((e) => '${e.key}: ${e.value}').join(', ');
}
