import 'package:bodybuild/data/programmer/exercises.dart';
import 'package:bodybuild/data/programmer/groups.dart';
import 'package:bodybuild/model/programgen_v1/rank.dart';

// Find connected components of exercises based on shared program groups
// Unfortunately, since some lower body exercises also recruit some upper body muscles,
// and vice versa, we need to ignore some groups to be able to split off into >1 components
// this is the tradeoff we make: either we are super accurate (ignore no groups), but spend too long
// computing, or we split up into components to have more manageable groups, but at the cost of
// some accuracy
// if we have 1 big component it was 286M total combos
// 2 separate components -> 9k and 220k combos
List<List<RankedExercise>> findExerciseComponents(
    Iterable<RankedExercise> exercises, Map<ProgramGroup, double> targets) {
  // Always ignore these groups when finding components
  final alwaysIgnoredGroups = {
    ProgramGroup.wristFlexors,
    ProgramGroup.wristExtensors,
  };

  // Groups to ignore for upper/lower body exercises
  final upperBodyIgnoredGroups = {
    ProgramGroup.abs,
    ProgramGroup.hams,
    ProgramGroup.gluteMax,
    ProgramGroup.spinalErectors,
  };

  final lowerBodyIgnoredGroups = {
    ProgramGroup.upperTraps,
    ProgramGroup.lats,
  };

  // Helper to determine if exercise is primarily lower body
  bool isLowerBodyExercise(Ex ex) {
    final lowerBodyGroups = {
      ProgramGroup.quadsVasti,
      ProgramGroup.quadsRF,
      ProgramGroup.hams,
      ProgramGroup.hamsShortHead,
      ProgramGroup.gluteMax,
      ProgramGroup.gluteMed,
      ProgramGroup.gastroc,
      ProgramGroup.soleus,
      ProgramGroup.spinalErectors,
    };

    // Sum recruitment for lower body groups
    final lowerBodyRecruitment = lowerBodyGroups
        .map((pg) => ex.recruitment(pg, {}))
        .fold(0.0, (sum, val) => sum + val.volume);

    // Sum recruitment for all groups
    final totalRecruitment = ProgramGroup.values
        .map((pg) => ex.recruitment(pg, {}))
        .fold(0.0, (sum, val) => sum + val.volume);

    // Consider it lower body if >50% of total recruitment is lower body
    return lowerBodyRecruitment / totalRecruitment > 0.5;
  }

  // Get active program groups for each exercise
  final exerciseGroups = <RankedExercise, Set<ProgramGroup>>{};
  for (final ex in exercises) {
    final isLower = isLowerBodyExercise(ex.ex);
    final ignoredGroups = {...alwaysIgnoredGroups};

    // Add additional groups to ignore based on exercise type
    ignoredGroups
        .addAll(isLower ? lowerBodyIgnoredGroups : upperBodyIgnoredGroups);

    exerciseGroups[ex] = ProgramGroup.values
        .where((pg) =>
            !ignoredGroups.contains(pg) &&
            ex.ex.recruitment(pg, {}).volume > 0 &&
            targets[pg]! > 0)
        .toSet();
  }

  // Find connected components using DFS
  final visited = <RankedExercise>{};
  final components = <List<RankedExercise>>[];

  void dfs(RankedExercise start, List<RankedExercise> component) {
    visited.add(start);
    component.add(start);

    for (final other in exercises) {
      if (!visited.contains(other)) {
        // Check if exercises share any program groups
        final sharedGroups =
            exerciseGroups[start]!.intersection(exerciseGroups[other]!);
        if (sharedGroups.isNotEmpty) {
          dfs(other, component);
        }
      }
    }
  }

  for (final ex in exercises) {
    if (!visited.contains(ex)) {
      final component = <RankedExercise>[];
      dfs(ex, component);
      components.add(component);
    }
  }

  return components;
}
