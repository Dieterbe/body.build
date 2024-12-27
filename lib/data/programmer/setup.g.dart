// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setup.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentProfileHash() => r'1c81d80fda6c060feee42ddeb871e1e25d8dec9c';

/// See also [currentProfile].
@ProviderFor(currentProfile)
final currentProfileProvider = AutoDisposeFutureProvider<Settings?>.internal(
  currentProfile,
  name: r'currentProfileProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentProfileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentProfileRef = AutoDisposeFutureProviderRef<Settings?>;
String _$setupHash() => r'a4961ebf11e387238cb411e82e729e86e67d4df3';

/// See also [Setup].
@ProviderFor(Setup)
final setupProvider = AsyncNotifierProvider<Setup, Settings>.internal(
  Setup.new,
  name: r'setupProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$setupHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Setup = AsyncNotifier<Settings>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
