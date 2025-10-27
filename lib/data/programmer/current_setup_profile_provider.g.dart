// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_setup_profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CurrentSetupProfile)
const currentSetupProfileProvider = CurrentSetupProfileProvider._();

final class CurrentSetupProfileProvider
    extends $AsyncNotifierProvider<CurrentSetupProfile, String> {
  const CurrentSetupProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentSetupProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentSetupProfileHash();

  @$internal
  @override
  CurrentSetupProfile create() => CurrentSetupProfile();
}

String _$currentSetupProfileHash() => r'700692e332b243c41a185b67d49c48195f8d4e4e';

abstract class _$CurrentSetupProfile extends $AsyncNotifier<String> {
  FutureOr<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<String>, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String>, String>,
              AsyncValue<String>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
