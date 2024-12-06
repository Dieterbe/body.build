import 'package:ptc/data/programmer/exercises.dart';
import 'package:ptc/data/programmer/groups.dart';
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
    return Settings.defaults();
  }

  /* INTERNAL VALIDATION FUNCTIONS */
  // (String?, val) -> if String not null = error
  // for some methods, an empty/unset value is an error, for others it isn't.
  // val is the value, if it is a correct one (sometimes null is correct)
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

  (String?, int) _heightValidator(String? value) {
    if (value == null || value.isEmpty) {
      return ('Please enter a length', 0);
    }
    final height = int.tryParse(value);
    if (height == null || height < 0 || height > 300) {
      return ('Must be between 0 & 300', 0);
    }
    return (null, height);
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

  (String?, int) _bodyFatValidator(String? value) {
    if (value == null || value.isEmpty) {
      return ('Please enter body fat percentage', 0);
    }
    final bf = int.tryParse(value);
    if (bf == null || bf < 0 || bf > 100) {
      return ('Must be between 0 & 100', 0);
    }
    return (null, bf);
  }

  (String?, int) _energyBalanceValidator(String? value) {
    if (value == null || value.isEmpty) {
      return ('Please enter energy balance percentage', 0);
    }
    final eb = int.tryParse(value);
    if (eb == null || eb < 50 || eb > 150) {
      return ('Must be between 50 & 150', 0);
    }
    return (null, eb);
  }

  (String?, double) _recoveryFactorValidator(String? value) {
    if (value == null || value.isEmpty) {
      return ('Please enter recovery factor', 0.0);
    }
    final rf = double.tryParse(value);
    if (rf == null || rf < 0.5 || rf > 1.2) {
      return ('Must be between 0.5 & 1.2', 0.0);
    }
    return (null, rf);
  }

  (String?, int) _workoutsPerWeekValidator(String? value) {
    if (value == null || value.isEmpty) {
      return ('Please enter workouts per week', 0);
    }
    final freq = int.tryParse(value);
    if (freq == null || freq < 1 || freq > 7) {
      return ('Must be between 1 & 7', 0);
    }
    return (null, freq);
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

  (String?, int?) _setsPerWeekPerMuscleGroupValidator(String? value) {
    if (value == null || value.isEmpty) {
      return (null, null); // Optional field, empty is valid
    }
    final volume = int.tryParse(value);
    if (volume == null || volume < 0 || volume > 30) {
      return ('Must be between 0 & 30', null);
    }
    return (null, volume);
  }

  /* VALIDATION FUNCTIONS FOR TEXTFORMFIELDS */

  String? ageValidator(String? value) => _ageValidator(value).$1;
  String? heightValidator(String? value) => _heightValidator(value).$1;
  String? weightValidator(String? value) => _weightValidator(value).$1;
  String? bodyFatValidator(String? value) => _bodyFatValidator(value).$1;
  String? energyBalanceValidator(String? v) => _energyBalanceValidator(v).$1;
  String? recoveryFactorValidator(String? v) => _recoveryFactorValidator(v).$1;
  String? workoutsPerWeekValidator(String? v) =>
      _workoutsPerWeekValidator(v).$1;
  String? intensitiesValidator(String? v) => _intensitiesValidator(v).$1;
  String? setsPerWeekPerMuscleGroupValidator(String? v) =>
      _setsPerWeekPerMuscleGroupValidator(v).$1;

  /* END VALIDATION FUNCTIONS */

  void setLevel(Level? level) {
    if (level != null) {
      state = state.copyWith(level: level);
    }
  }

  void setSex(Sex? sex) {
    if (sex != null) {
      state = state.copyWith(sex: sex);
    }
  }

  void setAge(int? age) {
    if (age != null) {
      state = state.copyWith(age: age);
    }
  }

  void setHeight(int? length) {
    if (length != null) {
      state = state.copyWith(height: length);
    }
  }

  void setWeight(int? weight) {
    if (weight != null) {
      state = state.copyWith(weight: weight);
    }
  }

  void setBodyFat(int? bodyFat) {
    if (bodyFat != null) {
      state = state.copyWith(bodyFat: bodyFat);
    }
  }

  void setEnergyBalance(int? energyBalance) {
    if (energyBalance != null) {
      state = state.copyWith(energyBalance: energyBalance);
    }
  }

  void setRecoveryFactor(double? recoveryFactor) {
    if (recoveryFactor != null) {
      state = state.copyWith(recoveryFactor: recoveryFactor);
    }
  }

  void setWorkoutsPerWeek(int? freq) {
    if (freq != null) {
      state = state.copyWith(workoutsPerWeek: freq);
    }
  }

  void setAgeMaybe(String value) {
    final (msg, age) = _ageValidator(value);
    if (msg == null) {
      setAge(age);
    }
  }

  void setHeightMaybe(String value) {
    final (msg, height) = _heightValidator(value);
    if (msg == null) {
      setHeight(height);
    }
  }

  void setWeightMaybe(String value) {
    final (msg, weight) = _weightValidator(value);
    if (msg == null) {
      setWeight(weight);
    }
  }

  void setBodyFatMaybe(String value) {
    final (msg, bf) = _bodyFatValidator(value);
    if (msg == null) {
      setBodyFat(bf);
    }
  }

  void setEnergyBalanceMaybe(String value) {
    final (msg, eb) = _energyBalanceValidator(value);
    if (msg == null) {
      setEnergyBalance(eb);
    }
  }

  void setRecoveryFactorMaybe(String value) {
    final (msg, rf) = _recoveryFactorValidator(value);
    if (msg == null) {
      setRecoveryFactor(rf);
    }
  }

  void setWorkoutsPerWeekMaybe(String value) {
    final (msg, freq) = _workoutsPerWeekValidator(value);
    if (msg == null) {
      setWorkoutsPerWeek(freq);
    }
  }

  void setIntensitiesMaybe(String value) {
    final (msg, intensities) = _intensitiesValidator(value);
    if (msg == null) {
      state = state.copyWith(
          paramOverrides: state.paramOverrides.copyWith(
        intensities: intensities,
      ));
    }
  }

  void setSetsPerWeekPerMuscleGroupMaybe(String value) {
    final (msg, volume) = _setsPerWeekPerMuscleGroupValidator(value);
    if (msg == null) {
      state = state.copyWith(
        paramOverrides: state.paramOverrides.copyWith(
          setsPerWeekPerMuscleGroup: volume,
        ),
      );
    }
  }

  void addMuscleGroupOverride(ProgramGroup group) {
    final newOverrides = [
      ...?state.paramOverrides.setsPerWeekPerMuscleGroupIndividual
    ];
    newOverrides.add(MuscleGroupOverride(group, 1));

    state = state.copyWith(
      paramOverrides: state.paramOverrides.copyWith(
        setsPerWeekPerMuscleGroupIndividual: newOverrides,
      ),
    );
  }

  void removeMuscleGroupOverride(ProgramGroup group) {
    final newOverrides = [
      ...?state.paramOverrides.setsPerWeekPerMuscleGroupIndividual
    ];
    newOverrides.removeWhere((override) => override.group == group);

    state = state.copyWith(
      paramOverrides: state.paramOverrides.copyWith(
        setsPerWeekPerMuscleGroupIndividual: newOverrides,
      ),
    );
  }

  void updateMuscleGroupOverride(ProgramGroup group, String value) {
    final (msg, sets) = _setsPerWeekPerMuscleGroupValidator(value);
    if (msg == null && sets != null) {
      final newOverrides = [
        ...?state.paramOverrides.setsPerWeekPerMuscleGroupIndividual
      ];
      final index =
          newOverrides.indexWhere((override) => override.group == group);
      if (index != -1) {
        newOverrides[index] = MuscleGroupOverride(group, sets);
        state = state.copyWith(
          paramOverrides: state.paramOverrides.copyWith(
            setsPerWeekPerMuscleGroupIndividual: newOverrides,
          ),
        );
      }
    }
  }

  void addEquipment(Equipment equipment) => state = state.copyWith(
        selectedEquipment: [...state.selectedEquipment, equipment],
      );

  void removeEquipment(Equipment equipment) => state = state.copyWith(
        selectedEquipment:
            state.selectedEquipment.where((e) => e != equipment).toList(),
      );

  void addExcludedExercise(Ex exercise) {
    final excl = Set<Ex>.from(state.paramOverrides.excludedExercises ?? {});
    if (excl.add(exercise)) {
      state = state.copyWith(
        paramOverrides: state.paramOverrides.copyWith(
          excludedExercises: excl,
        ),
      );
    }
  }

  void removeExcludedExercise(Ex exercise) {
    final excl = Set<Ex>.from(state.paramOverrides.excludedExercises ?? {});
    excl.remove(exercise);
    state = state.copyWith(
      paramOverrides: state.paramOverrides.copyWith(
        excludedExercises: excl,
      ),
    );
  }

  void addExcludedBase(EBase base) {
    final excl = Set<EBase>.from(state.paramOverrides.excludedBases ?? {});
    if (excl.add(base)) {
      state = state.copyWith(
        paramOverrides: state.paramOverrides.copyWith(
          excludedBases: excl,
        ),
      );
    }
  }

  void removeExcludedBase(EBase base) {
    final excl = Set<EBase>.from(state.paramOverrides.excludedBases ?? {});
    excl.remove(base);
    state = state.copyWith(
      paramOverrides: state.paramOverrides.copyWith(
        excludedBases: excl,
      ),
    );
  }
}
