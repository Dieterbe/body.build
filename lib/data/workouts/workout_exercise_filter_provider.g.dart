// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_exercise_filter_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WorkoutExerciseFilter)
const workoutExerciseFilterProvider = WorkoutExerciseFilterProvider._();

final class WorkoutExerciseFilterProvider
    extends
        $NotifierProvider<WorkoutExerciseFilter, WorkoutExerciseFilterState> {
  const WorkoutExerciseFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutExerciseFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutExerciseFilterHash();

  @$internal
  @override
  WorkoutExerciseFilter create() => WorkoutExerciseFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorkoutExerciseFilterState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorkoutExerciseFilterState>(value),
    );
  }
}

String _$workoutExerciseFilterHash() =>
    r'8e667aca2e10524aef5f73109effb5c661f2f114';

abstract class _$WorkoutExerciseFilter
    extends $Notifier<WorkoutExerciseFilterState> {
  WorkoutExerciseFilterState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<WorkoutExerciseFilterState, WorkoutExerciseFilterState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                WorkoutExerciseFilterState,
                WorkoutExerciseFilterState
              >,
              WorkoutExerciseFilterState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(workoutFilteredExercises)
const workoutFilteredExercisesProvider = WorkoutFilteredExercisesProvider._();

final class WorkoutFilteredExercisesProvider
    extends $FunctionalProvider<List<Ex>, List<Ex>, List<Ex>>
    with $Provider<List<Ex>> {
  const WorkoutFilteredExercisesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutFilteredExercisesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutFilteredExercisesHash();

  @$internal
  @override
  $ProviderElement<List<Ex>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Ex> create(Ref ref) {
    return workoutFilteredExercises(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Ex> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Ex>>(value),
    );
  }
}

String _$workoutFilteredExercisesHash() =>
    r'86e63f0cccc6c736265316f6d31a15e94317e390';
