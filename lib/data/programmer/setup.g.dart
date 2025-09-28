// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setup.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Setup)
const setupProvider = SetupProvider._();

final class SetupProvider extends $AsyncNotifierProvider<Setup, Settings> {
  const SetupProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'setupProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$setupHash();

  @$internal
  @override
  Setup create() => Setup();
}

String _$setupHash() => r'c645bfbaa32e6fb016deffdf9708a77c0f561a6c';

abstract class _$Setup extends $AsyncNotifier<Settings> {
  FutureOr<Settings> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<Settings>, Settings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Settings>, Settings>,
              AsyncValue<Settings>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
