// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(databaseBackupService)
const databaseBackupServiceProvider = DatabaseBackupServiceProvider._();

final class DatabaseBackupServiceProvider
    extends $FunctionalProvider<DatabaseBackupService, DatabaseBackupService, DatabaseBackupService>
    with $Provider<DatabaseBackupService> {
  const DatabaseBackupServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'databaseBackupServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$databaseBackupServiceHash();

  @$internal
  @override
  $ProviderElement<DatabaseBackupService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DatabaseBackupService create(Ref ref) {
    return databaseBackupService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DatabaseBackupService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DatabaseBackupService>(value),
    );
  }
}

String _$databaseBackupServiceHash() => r'b5b6b71fad62ffc76a09a6370304487174669648';
