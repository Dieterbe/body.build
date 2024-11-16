class ParameterOverrides {
  late List<int>? intensities;

  ParameterOverrides({this.intensities});
  // explicitly specify all fields. useful for copying an override structure into another
  // if we want to explicitly set certain fields to their null values, we can't use copyWith()
  ParameterOverrides.full(this.intensities);

  ParameterOverrides copyWith({List<int>? intensities}) {
    return ParameterOverrides()
      ..intensities =
          (intensities?.isNotEmpty == true) ? intensities! : this.intensities;
  }
}
