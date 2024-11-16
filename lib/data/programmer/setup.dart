import 'package:ptc/data/programmer/exercises.dart';
import 'package:ptc/model/programmer/level.dart';
import 'package:ptc/model/programmer/parameter_overrides.dart';
import 'package:ptc/model/programmer/settings.dart';
import 'package:ptc/model/programmer/sex.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'setup.g.dart';

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

  (String?, List<int>?) _intensitiesValidator(String? value) {
    // you're allowed to not override
    if (value == null || value.isEmpty) {
      return (null, null);
    }
    final intensities = value.split(',').map((i) => int.tryParse(i)).toList();
    if (intensities.any((i) => i == null || i < 1 || i > 100)) {
      return ('Intensities must be between 1 & 100', null);
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
      state =
          state.copyWith(paramOverrides: ParameterOverrides.full(intensities));
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
