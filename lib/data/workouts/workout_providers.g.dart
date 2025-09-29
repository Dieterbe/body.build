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

String _$workoutDatabaseHash() => r'66604033a8e04e047a1a5a60ee7fc6ef269a9482';

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

@ProviderFor(ActiveWorkout)
const activeWorkoutProvider = ActiveWorkoutProvider._();

final class ActiveWorkoutProvider extends $AsyncNotifierProvider<ActiveWorkout, model.Workout?> {
  const ActiveWorkoutProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeWorkoutProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeWorkoutHash();

  @$internal
  @override
  ActiveWorkout create() => ActiveWorkout();
}

String _$activeWorkoutHash() => r'd4e23c1093203768cf640b43325af3dd94e98148';

abstract class _$ActiveWorkout extends $AsyncNotifier<model.Workout?> {
  FutureOr<model.Workout?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<model.Workout?>, model.Workout?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<model.Workout?>, model.Workout?>,
              AsyncValue<model.Workout?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(WorkoutHistory)
const workoutHistoryProvider = WorkoutHistoryProvider._();

final class WorkoutHistoryProvider
    extends $AsyncNotifierProvider<WorkoutHistory, List<model.Workout>> {
  const WorkoutHistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutHistoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutHistoryHash();

  @$internal
  @override
  WorkoutHistory create() => WorkoutHistory();
}

String _$workoutHistoryHash() => r'35aa0385ee4b19b25d0cf309a3e3b031df5f41f7';

abstract class _$WorkoutHistory extends $AsyncNotifier<List<model.Workout>> {
  FutureOr<List<model.Workout>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<model.Workout>>, List<model.Workout>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<model.Workout>>, List<model.Workout>>,
              AsyncValue<List<model.Workout>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(WorkoutsAll)
const workoutsAllProvider = WorkoutsAllProvider._();

final class WorkoutsAllProvider extends $AsyncNotifierProvider<WorkoutsAll, List<model.Workout>> {
  const WorkoutsAllProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutsAllProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutsAllHash();

  @$internal
  @override
  WorkoutsAll create() => WorkoutsAll();
}

String _$workoutsAllHash() => r'969c4be95d014983ad0067757d782509477426cd';

abstract class _$WorkoutsAll extends $AsyncNotifier<List<model.Workout>> {
  FutureOr<List<model.Workout>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<model.Workout>>, List<model.Workout>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<model.Workout>>, List<model.Workout>>,
              AsyncValue<List<model.Workout>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(workoutById)
const workoutByIdProvider = WorkoutByIdFamily._();

final class WorkoutByIdProvider
    extends
        $FunctionalProvider<AsyncValue<model.Workout?>, model.Workout?, FutureOr<model.Workout?>>
    with $FutureModifier<model.Workout?>, $FutureProvider<model.Workout?> {
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

String _$workoutByIdHash() => r'46c154e78454fd90e8a4325ba5cc95cfa0390853';

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

  WorkoutByIdProvider call(String workoutId) =>
      WorkoutByIdProvider._(argument: workoutId, from: this);

  @override
  String toString() => r'workoutByIdProvider';
}

@ProviderFor(WorkoutOperations)
const workoutOperationsProvider = WorkoutOperationsProvider._();

final class WorkoutOperationsProvider extends $NotifierProvider<WorkoutOperations, void> {
  const WorkoutOperationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutOperationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutOperationsHash();

  @$internal
  @override
  WorkoutOperations create() => WorkoutOperations();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<void>(value));
  }
}

String _$workoutOperationsHash() => r'd8157f233291338c6865ed740074df1fcbcc6c68';

abstract class _$WorkoutOperations extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element as $ClassProviderElement<AnyNotifier<void, void>, void, Object?, Object?>;
    element.handleValue(ref, null);
  }
}
