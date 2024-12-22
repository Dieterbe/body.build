import 'package:ptc/data/programmer/equipment.dart';
import 'package:ptc/data/programmer/exercise_base.dart';
import 'package:ptc/data/programmer/exercises.dart';
import 'package:ptc/data/programmer/groups.dart';
import 'package:ptc/model/programmer/activity_level.dart';
import 'package:ptc/model/programmer/bmr_method.dart';
import 'package:ptc/model/programmer/level.dart';
import 'package:ptc/model/programmer/parameter_overrides.dart';
import 'package:ptc/model/programmer/parameters.dart';
import 'package:ptc/model/programmer/settings.dart';
import 'package:ptc/model/programmer/sex.dart';
import 'package:ptc/data/programmer/current_setup_profile_provider.dart';
import 'package:ptc/data/programmer/setup_persistence_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'setup.g.dart';

@Riverpod(keepAlive: true)
class Setup extends _$Setup {
  @override
  Settings build() {
    ref.onDispose(() {
      print('programmer setup provider disposed');
    });

    // Watch the current profile ID to rebuild when it changes
    ref.listen(currentSetupProfileProvider, (previous, next) async {
      if (next.value == null) return;
      final service = await ref.read(setupPersistenceProvider.future);
      final profile = await service.loadProfile(next.value!);
      if (profile != null) {
        state = profile;
      }
    });

    return Settings.defaults();
  }

  Future<void> _saveCurrentProfile() async {
    final currentProfile = await ref.read(currentSetupProfileProvider.future);
    final service = await ref.read(setupPersistenceProvider.future);
    await service.saveProfile(currentProfile, state);
  }

  void _updateState(Settings Function(Settings) update) {
    final newState = update(state);
    state = newState.copyWith(
      paramSuggest: Parameters.fromSettings(newState),
    );
    _saveCurrentProfile();
  }

  /* INTERNAL VALIDATION FUNCTIONS */
  // (String?, val) -> if String not null = error
  // for some methods, an empty/unset value is an error, for others it isn't.
  // val is the value, if it is a correct one (sometimes null is correct)
  (String?, double) _ageValidator(String? value) {
    if (value == null || value.isEmpty) {
      return ('Please enter an age', 0);
    }
    final age = double.tryParse(value);
    if (age == null || age < 0 || age > 120) {
      return ('Must be between 0 & 120', 0);
    }
    return (null, age);
  }

  (String?, double) _heightValidator(String? value) {
    if (value == null || value.isEmpty) {
      return ('Please enter a length', 0);
    }
    final height = double.tryParse(value);
    if (height == null || height < 0 || height > 300) {
      return ('Must be between 0 & 300', 0);
    }
    return (null, height);
  }

  (String?, double) _weightValidator(String? value) {
    if (value == null || value.isEmpty) {
      return ('Please enter a weight', 0);
    }
    final weight = double.tryParse(value);
    if (weight == null || weight < 0 || weight > 800) {
      return ('Must be between 0 & 800', 0);
    }
    return (null, weight);
  }

// can be unset
  (String?, double?) _bodyFatValidator(String? value) {
    if (value == null || value.isEmpty) {
      return (null, null);
    }
    final bf = double.tryParse(value);
    if (bf == null || bf < 0 || bf > 100) {
      return ('Must be between 0 & 100', null);
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

  (String?, int) _workoutDurationValidator(String? value) {
    if (value == null || value.isEmpty) {
      return ('Please enter workout duration', 0);
    }
    final duration = int.tryParse(value);
    if (duration == null || duration < 10 || duration > 180) {
      return ('Must be between 10 & 180', 0);
    }
    return (null, duration);
  }

  (String?, double) _thermicEffectValidator(String? value) {
    if (value == null || value.isEmpty) {
      return ('Please enter a TEF factor', 0);
    }
    final effect = double.tryParse(value);
    if (effect == null || effect < 0.8 || effect > 1.25) {
      return ('Must be between 0.8 & 1.25', 0.1);
    }
    return (null, effect);
  }

  (String?, double) _adaptiveThermogenesisValidator(String? value) {
    if (value == null || value.isEmpty) {
      return ('Please enter adaptive thermogenesis multiplier', 0.0);
    }
    final effect = double.tryParse(value);
    if (effect == null || effect < 0.5 || effect > 1.5) {
      return ('Must be between 0.5 & 1.5', 0.0);
    }
    return (null, effect);
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
  String? workoutDurationValidator(String? v) =>
      _workoutDurationValidator(v).$1;
  String? thermicEffectValidator(String? value) =>
      _thermicEffectValidator(value).$1;
  String? adaptiveThermogenesisValidator(String? value) =>
      _adaptiveThermogenesisValidator(value).$1;

  /* END VALIDATION FUNCTIONS */

  void setLevel(Level? level) {
    if (level != null) {
      _updateState((s) => s.copyWith(level: level));
    }
  }

  void setSex(Sex? sex) {
    if (sex != null) {
      _updateState((s) => s.copyWith(sex: sex));
    }
  }

  void setAge(double? age) {
    if (age != null) {
      _updateState((s) => s.copyWith(age: age));
    }
  }

  void setHeight(double? length) {
    if (length != null) {
      _updateState((s) => s.copyWith(height: length));
    }
  }

  void setWeight(double? weight) {
    if (weight != null) {
      _updateState((s) => s.copyWith(weight: weight));
    }
  }

  void setBodyFat(double? bodyFat) {
    _updateState((s) => s.copyWith(bodyFat: bodyFat));
  }

  void setBMRMethod(BMRMethod method) {
    _updateState((s) => s.copyWith(bmrMethod: method));
  }

  void setActivityLevel(ActivityLevel level) {
    _updateState((s) => s.copyWith(activityLevel: level));
  }

  void setEnergyBalance(int? energyBalance) {
    if (energyBalance != null) {
      _updateState((s) => s.copyWith(energyBalance: energyBalance));
    }
  }

  void setRecoveryFactor(double? recoveryFactor) {
    if (recoveryFactor != null) {
      _updateState((s) => s.copyWith(recoveryFactor: recoveryFactor));
    }
  }

  void setWorkoutsPerWeek(int? freq) {
    if (freq != null) {
      _updateState((s) => s.copyWith(workoutsPerWeek: freq));
    }
  }

  void setWorkoutDuration(int duration) {
    _updateState((s) => s.copyWith(workoutDuration: duration));
  }

  void setThermicEffect(double value) {
    state = state.copyWith(tefFactor: value);
  }

  void setAdaptiveThermogenesis(double value) {
    state = state.copyWith(atFactor: value);
  }

  void setWorkoutDurationMaybe(String value) {
    final (msg, duration) = _workoutDurationValidator(value);
    if (msg == null) {
      setWorkoutDuration(duration);
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

  void setThermicEffectMaybe(String value) {
    final (msg, effect) = _thermicEffectValidator(value);
    if (msg == null) {
      setThermicEffect(effect);
    }
  }

  void setAdaptiveThermogenesisMaybe(String value) {
    final (msg, effect) = _adaptiveThermogenesisValidator(value);
    if (msg == null) {
      setAdaptiveThermogenesis(effect);
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

  /* EQUIPMENT MANAGEMENT */
  void addEquipment(Equipment equipment) {
    _updateState(
        (s) => s.copyWith(availEquipment: {...s.availEquipment, equipment}));
  }

  void removeEquipment(Equipment equipment) {
    _updateState((s) => s.copyWith(
        availEquipment: s.availEquipment.where((e) => e != equipment).toSet()));
  }

  void setEquipment(Set<Equipment> equipment) {
    _updateState((s) => s.copyWith(availEquipment: equipment));
  }

  /* EXERCISE EXCLUSION */
  void addExcludedExercise(Ex exercise) {
    final excl = Set<Ex>.from(state.paramOverrides.excludedExercises ?? {});
    if (excl.add(exercise)) {
      _updateState((s) => s.copyWith(
            paramOverrides: s.paramOverrides.copyWith(
              excludedExercises: excl,
            ),
          ));
    }
  }

  void removeExcludedExercise(Ex exercise) {
    final excl = Set<Ex>.from(state.paramOverrides.excludedExercises ?? {});
    excl.remove(exercise);
    _updateState((s) => s.copyWith(
          paramOverrides: s.paramOverrides.copyWith(
            excludedExercises: excl,
          ),
        ));
  }

  void addExcludedBase(EBase base) {
    final excl = Set<EBase>.from(state.paramOverrides.excludedBases ?? {});
    if (excl.add(base)) {
      _updateState((s) => s.copyWith(
            paramOverrides: s.paramOverrides.copyWith(
              excludedBases: excl,
            ),
          ));
    }
  }

  void removeExcludedBase(EBase base) {
    final excl = Set<EBase>.from(state.paramOverrides.excludedBases ?? {});
    excl.remove(base);
    _updateState((s) => s.copyWith(
          paramOverrides: s.paramOverrides.copyWith(
            excludedBases: excl,
          ),
        ));
  }
}
