import 'package:bodybuild/data/programmer/equipment.dart';
import 'package:bodybuild/data/programmer/exercises.dart';
import 'package:bodybuild/model/programmer/activity_level.dart';
import 'package:bodybuild/model/programmer/bmr_method.dart';
import 'package:bodybuild/model/programmer/level.dart';
import 'package:bodybuild/model/programmer/parameter_overrides.dart';
import 'package:bodybuild/model/programmer/parameters.dart';
import 'package:bodybuild/model/programmer/sex.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bodybuild/util/formulas.dart';

part 'settings.freezed.dart';
part 'settings.g.dart';

@freezed
abstract class Settings with _$Settings {
  const Settings._(); // Private constructor for custom methods

  // This is the main constructor, for Freezed.
  // Look at the defaults constructor below
  const factory Settings({
    @Default('unnamed profile') String name,
    // Personal information
    @Default(Level.beginner) Level level,
    @Default(Sex.male) Sex sex,
    @Default(30) double age,
    @Default(75) double weight,
    @Default(178) double height,
    @Default(null) double? bodyFat, // percentage
    @Default(100) int energyBalance, // percentage (100 = maintenance)
    @Default(1.0) double recoveryFactor, // Recovery quality factor (0.5 - 1.2)
    @Default(1.2) double tefFactor, // Thermic effect of food
    @Default(1.0) double atFactor, // Adaptive thermogenesis
    @Default(3) int workoutsPerWeek,
    @Default(60) int workoutDuration, // minutes
    @Default(ActivityLevel.sedentary) ActivityLevel activityLevel,
    // other
    @Default(BMRMethod.tenHaaf) BMRMethod bmrMethod,
    @JsonKey(toJson: _equipmentSetToJson, fromJson: _equipmentSetFromJson)
    @Default({})
    Set<Equipment> availEquipment,
    required Parameters paramSuggest,
    required ParameterOverrides paramOverrides,
  }) = _Settings;

  factory Settings.fromJson(Map<String, dynamic> json) => _$SettingsFromJson(json);
  // this constructor sets paramSuggest correctly based on the settings
  // normally, we'd do this in the default constructor, but Freezed doesn't allow that
  factory Settings.defaults({
    String name = 'unnamed profile',
    // Personal information
    Level level = Level.beginner,
    Sex sex = Sex.male,
    double age = 30,
    double weight = 75,
    double height = 178,
    double? bodyFat,
    int energyBalance = 100,
    double recoveryFactor = 1.0,
    double tefFactor = 1.2,
    double atFactor = 1.0,
    int workoutsPerWeek = 3,
    int workoutDuration = 60,
    ActivityLevel activityLevel = ActivityLevel.sedentary,

    // other
    BMRMethod bmrMethod = BMRMethod.tenHaaf,
    ParameterOverrides paramOverrides = const ParameterOverrides(),
  }) {
    final tempSettings = Settings(
      name: name,
      // Personal information
      level: level,
      sex: sex,
      age: age,
      weight: weight,
      height: height,
      bodyFat: bodyFat,
      energyBalance: energyBalance,
      recoveryFactor: recoveryFactor,
      tefFactor: tefFactor,
      atFactor: atFactor,
      workoutsPerWeek: workoutsPerWeek,
      workoutDuration: workoutDuration,
      activityLevel: activityLevel,
      // other
      paramSuggest: Parameters(),
      paramOverrides: paramOverrides,
      availEquipment: Equipment.values.toSet(),
      bmrMethod: bmrMethod,
    );

    return tempSettings.copyWith(paramSuggest: Parameters.fromSettings(tempSettings));
  }

  Parameters get paramFinal => paramSuggest.apply(paramOverrides);
  List<Ex> get availableExercises => getAvailableExercises(
    excludedExercises: paramOverrides.excludedExercises,
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

  double getBMR() {
    switch (bmrMethod) {
      case BMRMethod.cunningham:
        return bmrCunningham(weight, bodyFat ?? 0);
      case BMRMethod.tenHaaf:
        return bmrTenHaaf(weight, height, age, sex);
      case BMRMethod.tinsley:
        return bmrTinsley(weight);
    }
  }

  double getDisplacedEE(int duration) {
    return (getBMR() * getPAL() * atFactor) / (24 * 60) * duration;
  }

  // In the PTC course, we learned that for most people, not counting the EPOC is
  // okay because we count the basal expenditure
  // during workouts twice.  Whereas for highly physically active people,
  // the displaced resting EE is rather significant, so we could account for it.
  // However, here in code, we can always do the more accurate thing
  (double gross, double displaced, double epoc, double net) getTrainingEE(int duration) {
    final grossTrainingEE = 0.1 * weight * duration;
    final displacedEE = getDisplacedEE(duration);
    // we know that "most workouts (pobably around 30sets)" have epoc of 50
    // and workouts of 50-60 sets have an epoc up to 115
    // therefore this seems reasonable:
    final sets =
        duration / 2.5; // conditioned athletes actually will get more work done however, still
    final epoc = sets * 2;
    final netTrainingEE = grossTrainingEE - displacedEE + epoc;

    return (grossTrainingEE, displacedEE, epoc, netTrainingEE);
  }

  getDailyEE(double trainingEE) {
    return (getBMR() * getPAL() + trainingEE) * tefFactor * atFactor;
  }
}

List<String> _equipmentSetToJson(Set<Equipment> equipment) => equipment.map((e) => e.name).toList();

Set<Equipment> _equipmentSetFromJson(List<dynamic> json) =>
    json.map((e) => Equipment.values.firstWhere((eq) => eq.name == e)).toSet();
