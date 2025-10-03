import 'package:bodybuild/data/programmer/exercises.dart';
import 'package:bodybuild/data/programmer/groups.dart';
import 'package:bodybuild/data/programmer/tweak.dart';

void main() {
  print('Analyzing exercise recruitment combinations...\n');

  // Go through all exercises
  for (final exercise in exes) {
    // Create all possible tweak combinations
    final tweakCombos = _generateTweakCombinations(exercise.tweaks);
    // HERE analysis
    // For each combination, check recruitment for all program groups
    for (final tweakOptions in tweakCombos) {
      // Check recruitment for each program group
      for (final group in ProgramGroup.values) {
        final result = exercise.recruitment(group, tweakOptions);

        // If recruitment has volume > 0 and merged non-zero values
        if (result.volume > 0 && result.multiplied) {
          print('Exercise: ${exercise.id}');
          print('Program Group: ${group.displayNameShort}');
          print('Tweaks: ${_formatTweakOptions(tweakOptions)}');
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

List<Map<String, String>> _generateTweakCombinations(List<Tweak> tweaks) {
  if (tweaks.isEmpty) return [<String, String>{}];

  final combinations = <Map<String, String>>[];
  final first = tweaks.first;
  final rest = tweaks.sublist(1);

  // Get combinations for the rest of the tweaks
  final subCombinations = _generateTweakCombinations(rest);

  // For each option of the first tweak
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

String _formatTweakOptions(Map<String, String> options) {
  return options.entries.map((e) => '${e.key}: ${e.value}').join(', ');
}
