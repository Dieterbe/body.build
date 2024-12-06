import 'package:ptc/data/programmer/exercises.dart';
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
    @JsonKey(toJson: _equipmentListToJson, fromJson: _equipmentListFromJson)
    @Default([])
    List<Equipment> selectedEquipment,
    @Default(30) int age,
    @Default(75) int weight,
    @Default(178) int height,
    @Default(15) int bodyFat, // percentage
    @Default(100) int energyBalance, // percentage (100 = maintenance)
    @Default(1.0) double recoveryFactor, // Recovery quality factor (0.5 - 1.2)
    @Default(3) int workoutsPerWeek,
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
    List<Equipment> selectedEquipment = const [],
    int age = 30,
    int weight = 75,
    int height = 178,
    int bodyFat = 15,
    int energyBalance = 100,
    double recoveryFactor = 1.0,
    int workoutsPerWeek = 3,
    ParameterOverrides paramOverrides = const ParameterOverrides(),
  }) {
    final tempSettings = Settings(
      level: level,
      sex: sex,
      selectedEquipment: selectedEquipment,
      age: age,
      weight: weight,
      height: height,
      bodyFat: bodyFat,
      energyBalance: energyBalance,
      recoveryFactor: recoveryFactor,
      workoutsPerWeek: workoutsPerWeek,
      paramSuggest: Parameters(),
      paramOverrides: paramOverrides,
    );

    return tempSettings.copyWith(
        paramSuggest: Parameters.fromSettings(tempSettings));
  }

  Parameters get paramFinal => paramSuggest.apply(paramOverrides);
}

List<String> _equipmentListToJson(List<Equipment> equipment) =>
    equipment.map((e) => e.name).toList();

List<Equipment> _equipmentListFromJson(List<dynamic> json) =>
    json.map((e) => Equipment.values.firstWhere((eq) => eq.name == e)).toList();
