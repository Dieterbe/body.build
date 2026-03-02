// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(templatePersistenceService)
const templatePersistenceServiceProvider = TemplatePersistenceServiceProvider._();

final class TemplatePersistenceServiceProvider
    extends
        $FunctionalProvider<
          TemplatePersistenceService,
          TemplatePersistenceService,
          TemplatePersistenceService
        >
    with $Provider<TemplatePersistenceService> {
  const TemplatePersistenceServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'templatePersistenceServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$templatePersistenceServiceHash();

  @$internal
  @override
  $ProviderElement<TemplatePersistenceService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TemplatePersistenceService create(Ref ref) {
    return templatePersistenceService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TemplatePersistenceService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TemplatePersistenceService>(value),
    );
  }
}

String _$templatePersistenceServiceHash() => r'1f113c89e0aeceb6af4a26b378cdc0e90743f340';

@ProviderFor(TemplateManager)
const templateManagerProvider = TemplateManagerProvider._();

final class TemplateManagerProvider
    extends $StreamNotifierProvider<TemplateManager, List<WorkoutTemplate>> {
  const TemplateManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'templateManagerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$templateManagerHash();

  @$internal
  @override
  TemplateManager create() => TemplateManager();
}

String _$templateManagerHash() => r'687b206abf09f6d699bc454511838deb85c192a6';

abstract class _$TemplateManager extends $StreamNotifier<List<WorkoutTemplate>> {
  Stream<List<WorkoutTemplate>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<WorkoutTemplate>>, List<WorkoutTemplate>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<WorkoutTemplate>>, List<WorkoutTemplate>>,
              AsyncValue<List<WorkoutTemplate>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
