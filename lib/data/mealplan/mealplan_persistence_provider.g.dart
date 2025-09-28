// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mealplan_persistence_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mealplanPersistence)
const mealplanPersistenceProvider = MealplanPersistenceProvider._();

final class MealplanPersistenceProvider
    extends
        $FunctionalProvider<
          AsyncValue<MealplanPersistenceService>,
          MealplanPersistenceService,
          FutureOr<MealplanPersistenceService>
        >
    with $FutureModifier<MealplanPersistenceService>, $FutureProvider<MealplanPersistenceService> {
  const MealplanPersistenceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mealplanPersistenceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mealplanPersistenceHash();

  @$internal
  @override
  $FutureProviderElement<MealplanPersistenceService> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<MealplanPersistenceService> create(Ref ref) {
    return mealplanPersistence(ref);
  }
}

String _$mealplanPersistenceHash() => r'852bf09a98954f680a4c4fb8ef02639f6f9c90e3';
