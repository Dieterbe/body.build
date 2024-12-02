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

  String? ageValidator(String? value) {
    final (msg, _) = _ageValidator(value);
    return msg;
  }

  String? heightValidator(String? value) {
    final (msg, _) = _heightValidator(value);
    return msg;
  }

  String? weightValidator(String? value) {
    final (msg, _) = _weightValidator(value);
    return msg;
  }

  String? bodyFatValidator(String? value) {
    final (msg, _) = _bodyFatValidator(value);
    return msg;
  }

  String? energyBalanceValidator(String? value) {
    final (msg, _) = _energyBalanceValidator(value);
    return msg;
  }

  String? recoveryFactorValidator(String? value) {
    final (msg, _) = _recoveryFactorValidator(value);
    return msg;
  }

  String? workoutsPerWeekValidator(String? value) {
    final (msg, _) = _workoutsPerWeekValidator(value);
    return msg;
  }

  String? intensitiesValidator(String? value) {
    final (msg, _) = _intensitiesValidator(value);
    return msg;
  }

  String? setsPerWeekPerMuscleGroupValidator(String? value) {
    final (msg, _) = _setsPerWeekPerMuscleGroupValidator(value);
    return msg;
  }

  /* END VALIDATION FUNCTIONS */

  void setLevel(Level? level) => state = state.copyWith(level: level);
  void setSex(Sex? sex) => state = state.copyWith(sex: sex);
  void setAge(int? age) => state = state.copyWith(age: age);
  void setHeight(int? length) => state = state.copyWith(height: length);
  void setWeight(int? weight) => state = state.copyWith(weight: weight);
  void setBodyFat(int? bodyFat) => state = state.copyWith(bodyFat: bodyFat);
  void setEnergyBalance(int? energyBalance) =>
      state = state.copyWith(energyBalance: energyBalance);
  void setRecoveryFactor(double? recoveryFactor) =>
      state = state.copyWith(recoveryFactor: recoveryFactor);
  void setWorkoutsPerWeek(int? freq) =>
      state = state.copyWith(workoutsPerWeek: freq);

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
          paramOverrides: ParameterOverrides.full(
              intensities,
              state.paramOverrides.setsPerweekPerMuscleGroup,
              state.paramOverrides.setsPerWeekPerMuscleGroupIndividual,
              state.paramOverrides.excludedExercises,
              state.paramOverrides.excludedBases));
    }
  }

  void setSetsPerWeekPerMuscleGroupMaybe(String value) {
    final (msg, volume) = _setsPerWeekPerMuscleGroupValidator(value);
    if (msg == null) {
      state = state.copyWith(
        paramOverrides: ParameterOverrides.full(
            state.paramOverrides.intensities,
            volume,
            state.paramOverrides.setsPerWeekPerMuscleGroupIndividual,
            state.paramOverrides.excludedExercises,
            state.paramOverrides.excludedBases),
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
        muscleGroupOverrides: newOverrides,
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
        muscleGroupOverrides: newOverrides,
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
            muscleGroupOverrides: newOverrides,
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
