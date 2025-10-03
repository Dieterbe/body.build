// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_filter_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ExerciseFilter)
const exerciseFilterProvider = ExerciseFilterProvider._();

final class ExerciseFilterProvider extends $NotifierProvider<ExerciseFilter, ExerciseFilterState> {
  const ExerciseFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exerciseFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exerciseFilterHash();

  @$internal
  @override
  ExerciseFilter create() => ExerciseFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExerciseFilterState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExerciseFilterState>(value),
    );
  }
}

String _$exerciseFilterHash() => r'a18e362b1058074975444ca4facd6b631fb5050a';

abstract class _$ExerciseFilter extends $Notifier<ExerciseFilterState> {
  ExerciseFilterState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ExerciseFilterState, ExerciseFilterState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ExerciseFilterState, ExerciseFilterState>,
              ExerciseFilterState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(filteredExercises)
const filteredExercisesProvider = FilteredExercisesProvider._();

final class FilteredExercisesProvider extends $FunctionalProvider<List<Ex>, List<Ex>, List<Ex>>
    with $Provider<List<Ex>> {
  const FilteredExercisesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredExercisesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredExercisesHash();

  @$internal
  @override
  $ProviderElement<List<Ex>> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  List<Ex> create(Ref ref) {
    return filteredExercises(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Ex> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<List<Ex>>(value));
  }
}

String _$filteredExercisesHash() => r'fe9f99a94657a46c8c36b7b1b7c0db313a54be29';
