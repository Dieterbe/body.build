import 'package:ptc/data/programmer/exercises.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'setup.g.dart';

enum Level {
  beginner,
  intermediate,
  advanced,
  elite,
}

enum Sex {
  male,
  female,
}

class Parameters {
  late List<int> intensities;

  Parameters() {
    intensities = [];
  }
  static Parameters fromSettings(Settings s) {
    var p = Parameters();
    p.intensities = switch (s.level) {
      Level.beginner => [60],
      Level.intermediate => [60, 70],
      Level.advanced => [65, 85],
      Level.elite => [70, 75, 80, 90],
      // TODO: age affects intensity
    };
    /*
    novice -> 6-10 sets per muscle group per week
    trained -> 12-25 sets per muscle group per week
    elite -> 15 - 30 sets per muscle group per week

    Optimal gains rules of thumb
    novice trainees: 6-10 sets per muscle group per week
    trained: 12-20 sets, sometimes more

women -> can do a bit more probably

20-33% reduction in volume is generally appropriate during a cut compared to during a bulk (though at end of bulk, may have become advanced enough to eat the diff)

// other factors: PED, elite genetics, elderly a bit less

//////////////////////
in the setup, we ideally don't want to be too prescriptive in terms of sets volume per muscle group, such that the program
can prioritize exercises not just thru volume, also thru ordering
OTOH, we do want to be able to express "don't train at all - vs de-emph - vs normal - vs prioritize"

*/

    return p;
  }

  Parameters copyWith({List<int>? intensities}) {
    return Parameters()..intensities = intensities ?? this.intensities;
  }
}

class Settings {
  Level level = Level.beginner;
  Sex sex = Sex.male;
  List<Equipment> selectedEquipment = [];
  int age = 30;
  int weight = 75;
  int length = 178;
  Parameters paramSuggest = Parameters();
  Parameters paramOverrides = Parameters();

  Settings copyWith(
      {Level? level,
      Sex? sex,
      int? age,
      int? weight,
      int? length,
      List<Equipment>? selectedEquipment,
      Parameters? paramOverrides}) {
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
}

@Riverpod(keepAlive: true)
class Setup extends _$Setup {
  @override
  Settings build() {
    ref.onDispose(() {
      print('programmer setup provider disposed');
    });
    return Settings();
  }

  /* INTERNAL VALIDATION FUNCTIONS */
  (String?, int) _ageValidator(String? value) {
    if (value == null || value.isEmpty) {
      return ('Please enter an age', 0);
    }
    final age = int.tryParse(value);
    if (age == null || age < 0 || age > 120) {
      return ('Must be between 0 & 120', 0);
    }
    return (null, age);
  }

  (String?, int) _lengthValidator(String? value) {
    if (value == null || value.isEmpty) {
      return ('Please enter a length', 0);
    }
    final length = int.tryParse(value);
    if (length == null || length < 0 || length > 300) {
      return ('Must be between 0 & 300', 0);
    }
    return (null, length);
  }

  (String?, int) _weightValidator(String? value) {
    if (value == null || value.isEmpty) {
      return ('Please enter a weight', 0);
    }
    final weight = int.tryParse(value);
    if (weight == null || weight < 0 || weight > 800) {
      return ('Must be between 0 & 800', 0);
    }
    return (null, weight);
  }

  (String?, List<int>) _intensitiesValidator(String? value) {
    // you're allowed to not override
    if (value == null || value.isEmpty) {
      return (null, []);
    }
    final intensities = value.split(',').map((i) => int.tryParse(i)).toList();
    if (intensities.any((i) => i == null || i < 1 || i > 100)) {
      return ('Intensities must be between 1 & 100', []);
    }
    return (null, intensities.map((i) => i!).toList());
  }
  /* VALIDATION FUNCTIONS FOR TEXTFORMFIELDS */

  String? ageValidator(String? value) {
    final (msg, _) = _ageValidator(value);
    return msg;
  }

  String? lengthValidator(String? value) {
    final (msg, _) = _lengthValidator(value);
    return msg;
  }

  String? weightValidator(String? value) {
    final (msg, _) = _weightValidator(value);
    return msg;
  }

  String? intensitiesValidator(String? value) {
    final (msg, _) = _intensitiesValidator(value);
    return msg;
  }

  /* END VALIDATION FUNCTIONS */

  void setLevel(Level? level) => state = state.copyWith(level: level);
  void setSex(Sex? sex) => state = state.copyWith(sex: sex);
  void setAge(int? age) => state = state.copyWith(age: age);
  void setLength(int? length) => state = state.copyWith(length: length);
  void setWeight(int? weight) => state = state.copyWith(weight: weight);

  void setAgeMaybe(String value) {
    final (msg, age) = _ageValidator(value);
    if (msg == null) {
      setAge(age);
    }
  }

  void setLengthMaybe(String value) {
    final (msg, length) = _lengthValidator(value);
    if (msg == null) {
      setLength(length);
    }
  }

  void setWeightMaybe(String value) {
    final (msg, weight) = _weightValidator(value);
    if (msg == null) {
      setWeight(weight);
    }
  }

  void setIntensitiesMaybe(String value) {
    final (msg, intensities) = _intensitiesValidator(value);
    if (msg == null) {
      state = state.copyWith(
          paramOverrides:
              state.paramOverrides.copyWith(intensities: intensities));
    }
  }

  void addEquipment(Equipment equipment) => state = state.copyWith(
        selectedEquipment: [...state.selectedEquipment, equipment],
      );

  void removeEquipment(Equipment equipment) => state = state.copyWith(
        selectedEquipment:
            state.selectedEquipment.where((e) => e != equipment).toList(),
      );
}
