// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setup_profile_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(setupProfileList)
const setupProfileListProvider = SetupProfileListProvider._();

final class SetupProfileListProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, Settings>>,
          Map<String, Settings>,
          FutureOr<Map<String, Settings>>
        >
    with $FutureModifier<Map<String, Settings>>, $FutureProvider<Map<String, Settings>> {
  const SetupProfileListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'setupProfileListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$setupProfileListHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, Settings>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, Settings>> create(Ref ref) {
    return setupProfileList(ref);
  }
}

String _$setupProfileListHash() => r'dfd5c91af354b116f8e2f17031dba0f76c731374';
