import 'package:ptc/data/programmer/groups.dart';
import 'package:ptc/data/programmer/exercises.dart';

class MuscleGroupOverride {
  final ProgramGroup group;
  final int sets;

  MuscleGroupOverride(this.group, this.sets);
}

class ParameterOverrides {
  final List<int>? intensities;
  final int? setsPerweekPerMuscleGroup;
  final List<MuscleGroupOverride>? setsPerWeekPerMuscleGroupIndividual;
  final Set<Ex>? excludedExercises;
  final Set<EBase>? excludedBases;

  ParameterOverrides({
    this.intensities,
    this.setsPerweekPerMuscleGroup,
    this.setsPerWeekPerMuscleGroupIndividual,
    this.excludedExercises,
    this.excludedBases,
  });

  // explicitly specify all fields. useful for copying an override structure into another
  // if we want to explicitly set certain fields to their null values, we can't use copyWith()
  ParameterOverrides.full(
    this.intensities,
    this.setsPerweekPerMuscleGroup,
    this.setsPerWeekPerMuscleGroupIndividual,
    this.excludedExercises,
    this.excludedBases,
  );

  ParameterOverrides copyWith({
    List<int>? intensities,
    int? setsPerweekPerMuscleGroup,
    List<MuscleGroupOverride>? muscleGroupOverrides,
    Set<Ex>? excludedExercises,
    Set<EBase>? excludedBases,
  }) =>
      ParameterOverrides(
        intensities: intensities ?? this.intensities,
        setsPerweekPerMuscleGroup:
            setsPerweekPerMuscleGroup ?? this.setsPerweekPerMuscleGroup,
        setsPerWeekPerMuscleGroupIndividual:
            muscleGroupOverrides ?? setsPerWeekPerMuscleGroupIndividual,
        excludedExercises: excludedExercises ?? this.excludedExercises,
        excludedBases: excludedBases ?? this.excludedBases,
      );
}
