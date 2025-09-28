// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setup_persistence_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(setupPersistence)
const setupPersistenceProvider = SetupPersistenceProvider._();

final class SetupPersistenceProvider
    extends
        $FunctionalProvider<
          AsyncValue<SetupPersistenceService>,
          SetupPersistenceService,
          FutureOr<SetupPersistenceService>
        >
    with $FutureModifier<SetupPersistenceService>, $FutureProvider<SetupPersistenceService> {
  const SetupPersistenceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'setupPersistenceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$setupPersistenceHash();

  @$internal
  @override
  $FutureProviderElement<SetupPersistenceService> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<SetupPersistenceService> create(Ref ref) {
    return setupPersistence(ref);
  }
}

String _$setupPersistenceHash() => r'4ce12784964cf69d3f1f74e2d5df86a54f8e3ca9';
