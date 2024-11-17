class ParameterOverrides {
  late List<int>? intensities;
  late int? setsPerweekPerMuscleGroup;

  ParameterOverrides({this.intensities, this.setsPerweekPerMuscleGroup});
  // explicitly specify all fields. useful for copying an override structure into another
  // if we want to explicitly set certain fields to their null values, we can't use copyWith()
  ParameterOverrides.full(this.intensities, this.setsPerweekPerMuscleGroup);

  ParameterOverrides copyWith(
      {List<int>? intensities, int? setsPerweekPerMuscleGroup}) {
    return ParameterOverrides()
      ..intensities = intensities ?? this.intensities
      ..setsPerweekPerMuscleGroup =
          setsPerweekPerMuscleGroup ?? this.setsPerweekPerMuscleGroup;
  }
}
