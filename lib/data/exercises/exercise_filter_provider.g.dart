// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_filter_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredExercisesHash() => r'8f2e4d1c3b5a6e9f0a1b2c3d4e5f6a7b8c9d0e1f';

/// See also [filteredExercises].
@ProviderFor(filteredExercises)
final filteredExercisesProvider = AutoDisposeProvider<List<Ex>>.internal(
  filteredExercises,
  name: r'filteredExercisesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$filteredExercisesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FilteredExercisesRef = AutoDisposeProviderRef<List<Ex>>;
String _$exerciseFilterHash() => r'1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b';

/// See also [ExerciseFilter].
@ProviderFor(ExerciseFilter)
final exerciseFilterProvider =
    AutoDisposeNotifierProvider<ExerciseFilter, ExerciseFilterState>.internal(
  ExerciseFilter.new,
  name: r'exerciseFilterProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$exerciseFilterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ExerciseFilter = AutoDisposeNotifier<ExerciseFilterState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
