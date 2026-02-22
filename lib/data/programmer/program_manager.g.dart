// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_manager.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProgramManager)
const programManagerProvider = ProgramManagerProvider._();

final class ProgramManagerProvider
    extends $AsyncNotifierProvider<ProgramManager, ProgramManagerState> {
  const ProgramManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'programManagerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$programManagerHash();

  @$internal
  @override
  ProgramManager create() => ProgramManager();
}

String _$programManagerHash() => r'fa4b3d381ab13bfe49b2b7a46073e4f3347c322c';

abstract class _$ProgramManager extends $AsyncNotifier<ProgramManagerState> {
  FutureOr<ProgramManagerState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<ProgramManagerState>, ProgramManagerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ProgramManagerState>, ProgramManagerState>,
              AsyncValue<ProgramManagerState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
