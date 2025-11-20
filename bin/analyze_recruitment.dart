import 'package:bodybuild/data/dataset/ex.dart';
import 'package:bodybuild/data/dataset/program_group.dart';
import 'package:bodybuild/data/dataset/tweak.dart';

void main() {
  print('Analyzing exercise recruitment combinations...\n');

  // Go through all exercises
  for (final exercise in exes) {
    // Create all possible tweak combinations
    final tweakOpts = {for (final tweak in exercise.tweaks) tweak.name: tweak.opts.keys.toList()};
    final tweakCombos = Tweak.generateCombinations(tweakOpts);
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

String _formatTweakOptions(Map<String, String> options) {
  return options.entries.map((e) => '${e.key}: ${e.value}').join(', ');
}
