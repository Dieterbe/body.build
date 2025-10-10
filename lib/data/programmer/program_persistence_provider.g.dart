// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_persistence_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(programPersistence)
const programPersistenceProvider = ProgramPersistenceProvider._();

final class ProgramPersistenceProvider
    extends
        $FunctionalProvider<
          AsyncValue<ProgramPersistenceService>,
          ProgramPersistenceService,
          FutureOr<ProgramPersistenceService>
        >
    with
        $FutureModifier<ProgramPersistenceService>,
        $FutureProvider<ProgramPersistenceService> {
  const ProgramPersistenceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'programPersistenceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$programPersistenceHash();

  @$internal
  @override
  $FutureProviderElement<ProgramPersistenceService> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ProgramPersistenceService> create(Ref ref) {
    return programPersistence(ref);
  }
}

String _$programPersistenceHash() =>
    r'0e358827644a447e69cb9192894d86838031a4bf';
