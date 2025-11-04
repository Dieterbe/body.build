// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'youtube_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(youtubePlaylist)
const youtubePlaylistProvider = YoutubePlaylistProvider._();

final class YoutubePlaylistProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<YouTubeVideo>>,
          List<YouTubeVideo>,
          FutureOr<List<YouTubeVideo>>
        >
    with $FutureModifier<List<YouTubeVideo>>, $FutureProvider<List<YouTubeVideo>> {
  const YoutubePlaylistProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'youtubePlaylistProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$youtubePlaylistHash();

  @$internal
  @override
  $FutureProviderElement<List<YouTubeVideo>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<YouTubeVideo>> create(Ref ref) {
    return youtubePlaylist(ref);
  }
}

String _$youtubePlaylistHash() => r'e32855ed460c505b574ad1afbc208b6932852124';
