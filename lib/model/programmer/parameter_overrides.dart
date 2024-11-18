import 'package:ptc/data/programmer/groups.dart';

class MuscleGroupOverride {
  final ProgramGroup group;
  final int sets;

  MuscleGroupOverride(this.group, this.sets);
}

class ParameterOverrides {
  late List<int>? intensities;
  late int? setsPerweekPerMuscleGroup;
  late List<MuscleGroupOverride>? setsPerWeekPerMuscleGroupIndividual;

  ParameterOverrides({
    this.intensities,
    this.setsPerweekPerMuscleGroup,
    this.setsPerWeekPerMuscleGroupIndividual,
  });

  // explicitly specify all fields. useful for copying an override structure into another
  // if we want to explicitly set certain fields to their null values, we can't use copyWith()
  ParameterOverrides.full(
    this.intensities,
    this.setsPerweekPerMuscleGroup,
    this.setsPerWeekPerMuscleGroupIndividual,
  );

  ParameterOverrides copyWith({
    List<int>? intensities,
    int? setsPerweekPerMuscleGroup,
    List<MuscleGroupOverride>? muscleGroupOverrides,
  }) {
    return ParameterOverrides()
      ..intensities = intensities ?? this.intensities
      ..setsPerweekPerMuscleGroup =
          setsPerweekPerMuscleGroup ?? this.setsPerweekPerMuscleGroup
      ..setsPerWeekPerMuscleGroupIndividual =
          muscleGroupOverrides ?? setsPerWeekPerMuscleGroupIndividual;
  }
}
