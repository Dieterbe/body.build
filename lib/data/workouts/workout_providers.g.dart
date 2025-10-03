// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(workoutDatabase)
const workoutDatabaseProvider = WorkoutDatabaseProvider._();

final class WorkoutDatabaseProvider
    extends $FunctionalProvider<WorkoutDatabase, WorkoutDatabase, WorkoutDatabase>
    with $Provider<WorkoutDatabase> {
  const WorkoutDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutDatabaseHash();

  @$internal
  @override
  $ProviderElement<WorkoutDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WorkoutDatabase create(Ref ref) {
    return workoutDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorkoutDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorkoutDatabase>(value),
    );
  }
}

String _$workoutDatabaseHash() => r'9f0d334cc49e7b9ae3fefd687f78c16cccf32143';

@ProviderFor(workoutPersistenceService)
const workoutPersistenceServiceProvider = WorkoutPersistenceServiceProvider._();

final class WorkoutPersistenceServiceProvider
    extends
        $FunctionalProvider<
          WorkoutPersistenceService,
          WorkoutPersistenceService,
          WorkoutPersistenceService
        >
    with $Provider<WorkoutPersistenceService> {
  const WorkoutPersistenceServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutPersistenceServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutPersistenceServiceHash();

  @$internal
  @override
  $ProviderElement<WorkoutPersistenceService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WorkoutPersistenceService create(Ref ref) {
    return workoutPersistenceService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorkoutPersistenceService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorkoutPersistenceService>(value),
    );
  }
}

String _$workoutPersistenceServiceHash() => r'0ef3cc59820baa9c3221f2bfe30c9b63ff3399bf';

/// Unified workout manager - single source of truth for all workout state
/// Uses Drift streams to automatically update when workout data changes
/// Need to stay alive because we check for active workout and navigate to different screen
/// Otherwise we get errors when the screen unmounts, provider disposes while the stream is loading
/// (e.g. when navigating from the articulations screen to 'start new workout')

@ProviderFor(WorkoutManager)
const workoutManagerProvider = WorkoutManagerProvider._();

/// Unified workout manager - single source of truth for all workout state
/// Uses Drift streams to automatically update when workout data changes
/// Need to stay alive because we check for active workout and navigate to different screen
/// Otherwise we get errors when the screen unmounts, provider disposes while the stream is loading
/// (e.g. when navigating from the articulations screen to 'start new workout')
final class WorkoutManagerProvider
    extends $StreamNotifierProvider<WorkoutManager, model.WorkoutState> {
  /// Unified workout manager - single source of truth for all workout state
  /// Uses Drift streams to automatically update when workout data changes
  /// Need to stay alive because we check for active workout and navigate to different screen
  /// Otherwise we get errors when the screen unmounts, provider disposes while the stream is loading
  /// (e.g. when navigating from the articulations screen to 'start new workout')
  const WorkoutManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutManagerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutManagerHash();

  @$internal
  @override
  WorkoutManager create() => WorkoutManager();
}

String _$workoutManagerHash() => r'3827f1edc95f0f534d44d67d4368e19774a6364f';

/// Unified workout manager - single source of truth for all workout state
/// Uses Drift streams to automatically update when workout data changes
/// Need to stay alive because we check for active workout and navigate to different screen
/// Otherwise we get errors when the screen unmounts, provider disposes while the stream is loading
/// (e.g. when navigating from the articulations screen to 'start new workout')

abstract class _$WorkoutManager extends $StreamNotifier<model.WorkoutState> {
  Stream<model.WorkoutState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<model.WorkoutState>, model.WorkoutState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<model.WorkoutState>, model.WorkoutState>,
              AsyncValue<model.WorkoutState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Derived provider - gets specific workout by ID from the unified state

@ProviderFor(workoutById)
const workoutByIdProvider = WorkoutByIdFamily._();

/// Derived provider - gets specific workout by ID from the unified state

final class WorkoutByIdProvider
    extends
        $FunctionalProvider<AsyncValue<model.Workout?>, model.Workout?, FutureOr<model.Workout?>>
    with $FutureModifier<model.Workout?>, $FutureProvider<model.Workout?> {
  /// Derived provider - gets specific workout by ID from the unified state
  const WorkoutByIdProvider._({
    required WorkoutByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'workoutByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$workoutByIdHash();

  @override
  String toString() {
    return r'workoutByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<model.Workout?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<model.Workout?> create(Ref ref) {
    final argument = this.argument as String;
    return workoutById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkoutByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$workoutByIdHash() => r'f4b5cfd66c39ca15b6d2892701602c8c81e330e1';

/// Derived provider - gets specific workout by ID from the unified state

final class WorkoutByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<model.Workout?>, String> {
  const WorkoutByIdFamily._()
    : super(
        retry: null,
        name: r'workoutByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Derived provider - gets specific workout by ID from the unified state

  WorkoutByIdProvider call(String workoutId) =>
      WorkoutByIdProvider._(argument: workoutId, from: this);

  @override
  String toString() => r'workoutByIdProvider';
}
