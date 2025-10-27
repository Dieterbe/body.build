// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mealplan.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Mealplan)
const mealplanProvider = MealplanProvider._();

final class MealplanProvider extends $AsyncNotifierProvider<Mealplan, MealPlan> {
  const MealplanProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mealplanProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mealplanHash();

  @$internal
  @override
  Mealplan create() => Mealplan();
}

String _$mealplanHash() => r'1683b35b593be5862424ee00b0203a6fdcdbb54b';

abstract class _$Mealplan extends $AsyncNotifier<MealPlan> {
  FutureOr<MealPlan> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<MealPlan>, MealPlan>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<MealPlan>, MealPlan>,
              AsyncValue<MealPlan>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
