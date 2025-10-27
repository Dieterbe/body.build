// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_mealplan_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CurrentMealplan)
const currentMealplanProvider = CurrentMealplanProvider._();

final class CurrentMealplanProvider extends $AsyncNotifierProvider<CurrentMealplan, String> {
  const CurrentMealplanProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentMealplanProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentMealplanHash();

  @$internal
  @override
  CurrentMealplan create() => CurrentMealplan();
}

String _$currentMealplanHash() => r'aafc4a08610d24749d4491544a10666c0f51a9ff';

abstract class _$CurrentMealplan extends $AsyncNotifier<String> {
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
