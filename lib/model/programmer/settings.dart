import 'package:ptc/data/programmer/exercises.dart';
import 'package:ptc/model/programmer/level.dart';
import 'package:ptc/model/programmer/parameter_overrides.dart';
import 'package:ptc/model/programmer/parameters.dart';
import 'package:ptc/model/programmer/sex.dart';

class Settings {
  Level level = Level.beginner;
  Sex sex = Sex.male;
  List<Equipment> selectedEquipment = [];
  int age = 30;
  int weight = 75;
  int length = 178;
  Parameters paramSuggest = Parameters();
  ParameterOverrides paramOverrides = ParameterOverrides();

  // default constructor
  Settings() {
    paramSuggest = Parameters.fromSettings(this);
  }

  Settings copyWith(
      {Level? level,
      Sex? sex,
      int? age,
      int? weight,
      int? length,
      List<Equipment>? selectedEquipment,
      ParameterOverrides? paramOverrides}) {
    var newSettings = Settings()
      ..level = level ?? this.level
      ..sex = sex ?? this.sex
      ..age = age ?? this.age
      ..weight = weight ?? this.weight
      ..length = length ?? this.length
      ..selectedEquipment = selectedEquipment ?? this.selectedEquipment
      ..paramOverrides = paramOverrides ?? this.paramOverrides;
    newSettings.paramSuggest = Parameters.fromSettings(newSettings);
    return newSettings;
  }

  Parameters get paramFinal => paramSuggest.apply(paramOverrides);
}
