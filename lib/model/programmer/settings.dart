import 'package:ptc/data/programmer/equipment.dart';
import 'package:ptc/data/programmer/exercises.dart';
import 'package:ptc/model/programmer/activity_level.dart';
import 'package:ptc/model/programmer/bmr_method.dart';
import 'package:ptc/model/programmer/level.dart';
import 'package:ptc/model/programmer/parameter_overrides.dart';
import 'package:ptc/model/programmer/parameters.dart';
import 'package:ptc/model/programmer/sex.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings.freezed.dart';
part 'settings.g.dart';

@freezed
class Settings with _$Settings {
  const Settings._(); // Private constructor for custom methods

  // This is the main constructor, for Freezed.
  // Look at the defaults constructor below
  const factory Settings({
    @Default(Level.beginner) Level level,
    @Default(Sex.male) Sex sex,
    @JsonKey(toJson: _equipmentSetToJson, fromJson: _equipmentSetFromJson)
    @Default({})
    Set<Equipment> availEquipment,
    @Default(30) double age,
    @Default(75) double weight,
    @Default(178) double height,
    @Default(null) double? bodyFat, // percentage
    @Default(100) int energyBalance, // percentage (100 = maintenance)
    @Default(1.0) double recoveryFactor, // Recovery quality factor (0.5 - 1.2)
    @Default(3) int workoutsPerWeek,
    @Default(BMRMethod.tenHaaf) BMRMethod bmrMethod,
    @Default(ActivityLevel.sedentary) ActivityLevel activityLevel,
    required Parameters paramSuggest,
    required ParameterOverrides paramOverrides,
  }) = _Settings;

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);
  // this constructor sets paramSuggest correctly based on the settings
  // normally, we'd do this in the default constructor, but Freezed doesn't allow that
  factory Settings.defaults({
    Level level = Level.beginner,
    Sex sex = Sex.male,
    Set<Equipment> availEquipment = const {},
    double age = 30,
    double weight = 75,
    double height = 178,
    double? bodyFat,
    int energyBalance = 100,
    double recoveryFactor = 1.0,
    int workoutsPerWeek = 3,
    BMRMethod bmrMethod = BMRMethod.cunningham,
    ActivityLevel activityLevel = ActivityLevel.sedentary,
    ParameterOverrides paramOverrides = const ParameterOverrides(),
  }) {
    final tempSettings = Settings(
      level: level,
      sex: sex,
      availEquipment: availEquipment,
      age: age,
      weight: weight,
      height: height,
      bodyFat: bodyFat,
      energyBalance: energyBalance,
      recoveryFactor: recoveryFactor,
      workoutsPerWeek: workoutsPerWeek,
      bmrMethod: bmrMethod,
      activityLevel: activityLevel,
      paramSuggest: Parameters(),
      paramOverrides: paramOverrides,
    );

    return tempSettings.copyWith(
        paramSuggest: Parameters.fromSettings(tempSettings));
  }

  Parameters get paramFinal => paramSuggest.apply(paramOverrides);
  List<Ex> get availableExercises => getAvailableExercises(
        excludedExercises: paramOverrides.excludedExercises,
        excludedBases: paramOverrides.excludedBases,
        availEquipment: availEquipment,
      );

  double getPAL() {
    switch (activityLevel) {
      case ActivityLevel.sedentary:
        return 1;
      case ActivityLevel.somewhatActive:
        return sex == Sex.male ? 1.11 : 1.12;
      case ActivityLevel.active:
        return sex == Sex.male ? 1.25 : 1.27;
      case ActivityLevel.veryActive:
        return sex == Sex.male ? 1.48 : 1.45;
    }
  }
}

List<String> _equipmentSetToJson(Set<Equipment> equipment) =>
    equipment.map((e) => e.name).toList();

Set<Equipment> _equipmentSetFromJson(List<dynamic> json) =>
    json.map((e) => Equipment.values.firstWhere((eq) => eq.name == e)).toSet();
