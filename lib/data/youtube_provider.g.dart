// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'youtube_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(YoutubePlaylist)
const youtubePlaylistProvider = YoutubePlaylistProvider._();

final class YoutubePlaylistProvider
    extends $AsyncNotifierProvider<YoutubePlaylist, List<YouTubeVideo>> {
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
  YoutubePlaylist create() => YoutubePlaylist();
}

String _$youtubePlaylistHash() => r'0ac76a7fb9244185b183a16346fe8e5e6d1bd8af';

abstract class _$YoutubePlaylist extends $AsyncNotifier<List<YouTubeVideo>> {
  FutureOr<List<YouTubeVideo>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<YouTubeVideo>>, List<YouTubeVideo>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<YouTubeVideo>>, List<YouTubeVideo>>,
              AsyncValue<List<YouTubeVideo>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
