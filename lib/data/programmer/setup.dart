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
  Future<Settings> build() async {
    ref.onDispose(() {
      print('programmer setup provider disposed');
    });

    // Watch the current profile ID to rebuild when it changes
    final profileId = await ref.watch(currentSetupProfileProvider.future);
    final service = await ref.read(setupPersistenceProvider.future);
    final profile = await service.loadProfile(profileId);

    return profile ?? Settings.defaults();
  }

  Future<void> _saveCurrentProfile() async {
    final profileId = await ref.read(currentSetupProfileProvider.future);
    final service = await ref.read(setupPersistenceProvider.future);
    final settings = await future;
    await service.saveProfile(profileId, settings);
  }

  Future<void> _updateState(Settings Function(Settings) update) async {
    final settings = await future;
    final newSettings = update(settings);
    state = AsyncData(newSettings.copyWith(
      paramSuggest: Parameters.fromSettings(newSettings),
    ));
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

  (String?, double) _tefFactorValidator(String? value) {
    if (value == null || value.isEmpty) {
      return ('Please enter a TEF factor', 0);
    }
    final effect = double.tryParse(value);
    if (effect == null || effect < 0.8 || effect > 1.25) {
      return ('Must be between 0.8 & 1.25', 0.1);
    }
    return (null, effect);
  }

  (String?, double) _atFactorValidator(String? value) {
    if (value == null || value.isEmpty) {
      return ('Please enter adaptive thermogenesis factor', 0.0);
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
  String? tefFactorValidator(String? value) => _tefFactorValidator(value).$1;
  String? atFactorValidator(String? value) => _atFactorValidator(value).$1;

  // Setters. Note the null checks for those properties that cannot be null

  Future<void> setLevel(Level? level) async {
    if (level != null) {
      await _updateState((s) => s.copyWith(level: level));
    }
  }

  Future<void> setSex(Sex? sex) async {
    if (sex != null) {
      await _updateState((s) => s.copyWith(sex: sex));
    }
  }

  Future<void> setAge(double? age) async {
    if (age != null) {
      await _updateState((s) => s.copyWith(age: age));
    }
  }

  Future<void> setHeight(double? length) async {
    if (length != null) {
      await _updateState((s) => s.copyWith(height: length));
    }
  }

  Future<void> setWeight(double? weight) async {
    if (weight != null) {
      await _updateState((s) => s.copyWith(weight: weight));
    }
  }

  Future<void> setBodyFat(double? bodyFat) async {
    await _updateState((s) => s.copyWith(bodyFat: bodyFat));
  }

  Future<void> setBMRMethod(BMRMethod method) async {
    await _updateState((s) => s.copyWith(bmrMethod: method));
  }

  Future<void> setActivityLevel(ActivityLevel level) async {
    await _updateState((s) => s.copyWith(activityLevel: level));
  }

  Future<void> setEnergyBalance(int? energyBalance) async {
    if (energyBalance != null) {
      await _updateState((s) => s.copyWith(energyBalance: energyBalance));
    }
  }

  Future<void> setRecoveryFactor(double? recoveryFactor) async {
    if (recoveryFactor != null) {
      await _updateState((s) => s.copyWith(recoveryFactor: recoveryFactor));
    }
  }

  Future<void> setWorkoutsPerWeek(int? freq) async {
    if (freq != null) {
      await _updateState((s) => s.copyWith(workoutsPerWeek: freq));
    }
  }

  Future<void> setWorkoutDuration(int duration) async {
    await _updateState((s) => s.copyWith(workoutDuration: duration));
  }

  Future<void> setTefFactor(double value) async {
    await _updateState((s) => s.copyWith(tefFactor: value));
  }

  Future<void> setAtFactor(double value) async {
    await _updateState((s) => s.copyWith(atFactor: value));
  }

// special setters. used internally. i factored this out and was probably not useful
  Future<void> setIntensities(List<int>? intensities) async {
    await _updateState((s) => s.copyWith(
          paramOverrides: s.paramOverrides.copyWith(intensities: intensities),
        ));
  }

// Conditional setters: set if passed value is valid
  Future<void> setWorkoutDurationMaybe(String value) async {
    final (msg, duration) = _workoutDurationValidator(value);
    if (msg == null) {
      await setWorkoutDuration(duration);
    }
  }

  Future<void> setAgeMaybe(String value) async {
    final (msg, age) = _ageValidator(value);
    if (msg == null) {
      await setAge(age);
    }
  }

  Future<void> setHeightMaybe(String value) async {
    final (msg, height) = _heightValidator(value);
    if (msg == null) {
      await setHeight(height);
    }
  }

  Future<void> setWeightMaybe(String value) async {
    final (msg, weight) = _weightValidator(value);
    if (msg == null) {
      await setWeight(weight);
    }
  }

  Future<void> setBodyFatMaybe(String value) async {
    final (msg, bf) = _bodyFatValidator(value);
    if (msg == null) {
      await setBodyFat(bf);
    }
  }

  Future<void> setEnergyBalanceMaybe(String value) async {
    final (msg, eb) = _energyBalanceValidator(value);
    if (msg == null) {
      await setEnergyBalance(eb);
    }
  }

  Future<void> setRecoveryFactorMaybe(String value) async {
    final (msg, rf) = _recoveryFactorValidator(value);
    if (msg == null) {
      await setRecoveryFactor(rf);
    }
  }

  Future<void> setWorkoutsPerWeekMaybe(String value) async {
    final (msg, freq) = _workoutsPerWeekValidator(value);
    if (msg == null) {
      await setWorkoutsPerWeek(freq);
    }
  }

  Future<void> setTefFactorMaybe(String value) async {
    final (msg, effect) = _tefFactorValidator(value);
    if (msg == null) {
      await setTefFactor(effect);
    }
  }

  Future<void> setAtFactorMaybe(String value) async {
    final (msg, effect) = _atFactorValidator(value);
    if (msg == null) {
      await setAtFactor(effect);
    }
  }

  Future<void> setIntensitiesMaybe(String value) async {
    final (msg, intensities) = _intensitiesValidator(value);
    if (msg == null) {
      await setIntensities(intensities);
    }
  }

  Future<void> setSetsPerWeekPerMuscleGroupMaybe(String value) async {
    final (msg, volume) = _setsPerWeekPerMuscleGroupValidator(value);
    if (msg == null) {
      await _updateState((s) => s.copyWith(
            paramOverrides: s.paramOverrides.copyWith(
              setsPerWeekPerMuscleGroup: volume,
            ),
          ));
    }
  }

  Future<void> addMuscleGroupOverride(ProgramGroup group) async {
    final settings = await future;
    final newOverrides = [
      ...?settings.paramOverrides.setsPerWeekPerMuscleGroupIndividual
    ];
    newOverrides.add(MuscleGroupOverride(group, 1));

    _updateState((s) => s.copyWith(
          paramOverrides: s.paramOverrides.copyWith(
            setsPerWeekPerMuscleGroupIndividual: newOverrides,
          ),
        ));
  }

  Future<void> removeMuscleGroupOverride(ProgramGroup group) async {
    final settings = await future;
    final newOverrides = [
      ...?settings.paramOverrides.setsPerWeekPerMuscleGroupIndividual
    ];
    newOverrides.removeWhere((override) => override.group == group);

    _updateState((s) => s.copyWith(
          paramOverrides: s.paramOverrides.copyWith(
            setsPerWeekPerMuscleGroupIndividual: newOverrides,
          ),
        ));
  }

  Future<void> updateMuscleGroupOverride(
      ProgramGroup group, String value) async {
    final (msg, sets) = _setsPerWeekPerMuscleGroupValidator(value);
    if (msg == null && sets != null) {
      final settings = await future;
      final newOverrides = [
        ...?settings.paramOverrides.setsPerWeekPerMuscleGroupIndividual
      ];
      final idx =
          newOverrides.indexWhere((override) => override.group == group);
      if (idx != -1) {
        newOverrides[idx] = MuscleGroupOverride(group, sets);
        _updateState((s) => s.copyWith(
              paramOverrides: s.paramOverrides.copyWith(
                setsPerWeekPerMuscleGroupIndividual: newOverrides,
              ),
            ));
      }
    }
  }

  /* EQUIPMENT MANAGEMENT */
  Future<void> addEquipment(Equipment equipment) async {
    _updateState(
        (s) => s.copyWith(availEquipment: {...s.availEquipment, equipment}));
  }

  Future<void> removeEquipment(Equipment equipment) async {
    _updateState((s) => s.copyWith(
        availEquipment: s.availEquipment.where((e) => e != equipment).toSet()));
  }

  Future<void> setEquipment(Set<Equipment> equipment) async {
    _updateState((s) => s.copyWith(availEquipment: equipment));
  }

  /* EXERCISE EXCLUSION */
  Future<void> addExcludedExercise(Ex exercise) async {
    _updateState((s) {
      final excl = Set<Ex>.from(s.paramOverrides.excludedExercises ?? {});
      if (excl.add(exercise)) {
        return s.copyWith(
          paramOverrides: s.paramOverrides.copyWith(
            excludedExercises: excl,
          ),
        );
      }
      return s;
    });
  }

  Future<void> removeExcludedExercise(Ex exercise) async {
    _updateState((s) {
      final excl = Set<Ex>.from(s.paramOverrides.excludedExercises ?? {});
      if (excl.remove(exercise)) {
        return s.copyWith(
          paramOverrides: s.paramOverrides.copyWith(
            excludedExercises: excl,
          ),
        );
      }
      return s;
    });
  }

  Future<void> addExcludedBase(EBase base) async {
    _updateState((s) {
      final excl = Set<EBase>.from(s.paramOverrides.excludedBases ?? {});
      excl.add(base);
      return s.copyWith(
        paramOverrides: s.paramOverrides.copyWith(
          excludedBases: excl,
        ),
      );
    });
  }

  Future<void> removeExcludedBase(EBase base) async {
    _updateState((s) {
      final excl = Set<EBase>.from(s.paramOverrides.excludedBases ?? {});
      excl.remove(base);
      return s.copyWith(
        paramOverrides: s.paramOverrides.copyWith(
          excludedBases: excl,
        ),
      );
    });
  }
}
