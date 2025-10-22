// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appSettingsPersistence)
const appSettingsPersistenceProvider = AppSettingsPersistenceProvider._();

final class AppSettingsPersistenceProvider
    extends
        $FunctionalProvider<
          AsyncValue<AppSettingsPersistenceService>,
          AppSettingsPersistenceService,
          FutureOr<AppSettingsPersistenceService>
        >
    with
        $FutureModifier<AppSettingsPersistenceService>,
        $FutureProvider<AppSettingsPersistenceService> {
  const AppSettingsPersistenceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appSettingsPersistenceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appSettingsPersistenceHash();

  @$internal
  @override
  $FutureProviderElement<AppSettingsPersistenceService> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<AppSettingsPersistenceService> create(Ref ref) {
    return appSettingsPersistence(ref);
  }
}

String _$appSettingsPersistenceHash() => r'43b3475eddd8ac3fc48d202941ffc397fff4861c';
