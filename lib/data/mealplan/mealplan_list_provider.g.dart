// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mealplan_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mealplanList)
const mealplanListProvider = MealplanListProvider._();

final class MealplanListProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, MealPlan>>,
          Map<String, MealPlan>,
          FutureOr<Map<String, MealPlan>>
        >
    with
        $FutureModifier<Map<String, MealPlan>>,
        $FutureProvider<Map<String, MealPlan>> {
  const MealplanListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mealplanListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mealplanListHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, MealPlan>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, MealPlan>> create(Ref ref) {
    return mealplanList(ref);
  }
}

String _$mealplanListHash() => r'78007c101b6ee9b97c4b460cac5845d05716cbfa';
