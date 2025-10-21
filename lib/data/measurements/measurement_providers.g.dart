// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(measurementPersistenceService)
const measurementPersistenceServiceProvider = MeasurementPersistenceServiceProvider._();

final class MeasurementPersistenceServiceProvider
    extends
        $FunctionalProvider<
          MeasurementPersistenceService,
          MeasurementPersistenceService,
          MeasurementPersistenceService
        >
    with $Provider<MeasurementPersistenceService> {
  const MeasurementPersistenceServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'measurementPersistenceServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$measurementPersistenceServiceHash();

  @$internal
  @override
  $ProviderElement<MeasurementPersistenceService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MeasurementPersistenceService create(Ref ref) {
    return measurementPersistenceService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MeasurementPersistenceService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MeasurementPersistenceService>(value),
    );
  }
}

String _$measurementPersistenceServiceHash() => r'b613974f5d2829eff1946ac1a0d50bfb492e1b2c';

/// Measurement manager - single source of truth for all measurement state
/// Uses Drift streams to automatically update when measurement data changes

@ProviderFor(MeasurementManager)
const measurementManagerProvider = MeasurementManagerProvider._();

/// Measurement manager - single source of truth for all measurement state
/// Uses Drift streams to automatically update when measurement data changes
final class MeasurementManagerProvider
    extends $StreamNotifierProvider<MeasurementManager, List<Measurement>> {
  /// Measurement manager - single source of truth for all measurement state
  /// Uses Drift streams to automatically update when measurement data changes
  const MeasurementManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'measurementManagerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$measurementManagerHash();

  @$internal
  @override
  MeasurementManager create() => MeasurementManager();
}

String _$measurementManagerHash() => r'7eddce2a7cf9a6d11ebceaf40544ccc61384d98d';

/// Measurement manager - single source of truth for all measurement state
/// Uses Drift streams to automatically update when measurement data changes

abstract class _$MeasurementManager extends $StreamNotifier<List<Measurement>> {
  Stream<List<Measurement>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Measurement>>, List<Measurement>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Measurement>>, List<Measurement>>,
              AsyncValue<List<Measurement>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider to get measurements filtered by type

@ProviderFor(measurementsByType)
const measurementsByTypeProvider = MeasurementsByTypeFamily._();

/// Provider to get measurements filtered by type

final class MeasurementsByTypeProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Measurement>>,
          List<Measurement>,
          Stream<List<Measurement>>
        >
    with $FutureModifier<List<Measurement>>, $StreamProvider<List<Measurement>> {
  /// Provider to get measurements filtered by type
  const MeasurementsByTypeProvider._({
    required MeasurementsByTypeFamily super.from,
    required MeasurementType super.argument,
  }) : super(
         retry: null,
         name: r'measurementsByTypeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$measurementsByTypeHash();

  @override
  String toString() {
    return r'measurementsByTypeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Measurement>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Measurement>> create(Ref ref) {
    final argument = this.argument as MeasurementType;
    return measurementsByType(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MeasurementsByTypeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$measurementsByTypeHash() => r'a9bdf61b49b219eb0df066d980e677cc1a1dabef';

/// Provider to get measurements filtered by type

final class MeasurementsByTypeFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Measurement>>, MeasurementType> {
  const MeasurementsByTypeFamily._()
    : super(
        retry: null,
        name: r'measurementsByTypeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider to get measurements filtered by type

  MeasurementsByTypeProvider call(MeasurementType type) =>
      MeasurementsByTypeProvider._(argument: type, from: this);

  @override
  String toString() => r'measurementsByTypeProvider';
}

/// Provider to get the latest measurement (for determining default unit)

@ProviderFor(latestMeasurement)
const latestMeasurementProvider = LatestMeasurementProvider._();

/// Provider to get the latest measurement (for determining default unit)

final class LatestMeasurementProvider
    extends $FunctionalProvider<AsyncValue<Measurement?>, Measurement?, FutureOr<Measurement?>>
    with $FutureModifier<Measurement?>, $FutureProvider<Measurement?> {
  /// Provider to get the latest measurement (for determining default unit)
  const LatestMeasurementProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'latestMeasurementProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$latestMeasurementHash();

  @$internal
  @override
  $FutureProviderElement<Measurement?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Measurement?> create(Ref ref) {
    return latestMeasurement(ref);
  }
}

String _$latestMeasurementHash() => r'2b230d29c6360c47ae4e638f2145283807cbf354';

/// Provider to get the latest measurement by type

@ProviderFor(latestMeasurementByType)
const latestMeasurementByTypeProvider = LatestMeasurementByTypeFamily._();

/// Provider to get the latest measurement by type

final class LatestMeasurementByTypeProvider
    extends $FunctionalProvider<AsyncValue<Measurement?>, Measurement?, FutureOr<Measurement?>>
    with $FutureModifier<Measurement?>, $FutureProvider<Measurement?> {
  /// Provider to get the latest measurement by type
  const LatestMeasurementByTypeProvider._({
    required LatestMeasurementByTypeFamily super.from,
    required MeasurementType super.argument,
  }) : super(
         retry: null,
         name: r'latestMeasurementByTypeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$latestMeasurementByTypeHash();

  @override
  String toString() {
    return r'latestMeasurementByTypeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Measurement?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Measurement?> create(Ref ref) {
    final argument = this.argument as MeasurementType;
    return latestMeasurementByType(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LatestMeasurementByTypeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$latestMeasurementByTypeHash() => r'6e903dfbb258d2b9dbe08664f4ba1be593c694a0';

/// Provider to get the latest measurement by type

final class LatestMeasurementByTypeFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Measurement?>, MeasurementType> {
  const LatestMeasurementByTypeFamily._()
    : super(
        retry: null,
        name: r'latestMeasurementByTypeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider to get the latest measurement by type

  LatestMeasurementByTypeProvider call(MeasurementType type) =>
      LatestMeasurementByTypeProvider._(argument: type, from: this);

  @override
  String toString() => r'latestMeasurementByTypeProvider';
}
