// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'youtube_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(YoutubePlaylist)
const youtubePlaylistProvider = YoutubePlaylistFamily._();

final class YoutubePlaylistProvider
    extends $AsyncNotifierProvider<YoutubePlaylist, List<YouTubeVideo>> {
  const YoutubePlaylistProvider._({
    required YoutubePlaylistFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'youtubePlaylistProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$youtubePlaylistHash();

  @override
  String toString() {
    return r'youtubePlaylistProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  YoutubePlaylist create() => YoutubePlaylist();

  @override
  bool operator ==(Object other) {
    return other is YoutubePlaylistProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$youtubePlaylistHash() => r'53eb1a015b67bca5f169bb8538743a0d1e2211d7';

final class YoutubePlaylistFamily extends $Family
    with
        $ClassFamilyOverride<
          YoutubePlaylist,
          AsyncValue<List<YouTubeVideo>>,
          List<YouTubeVideo>,
          FutureOr<List<YouTubeVideo>>,
          String
        > {
  const YoutubePlaylistFamily._()
    : super(
        retry: null,
        name: r'youtubePlaylistProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  YoutubePlaylistProvider call(String playlistId) =>
      YoutubePlaylistProvider._(argument: playlistId, from: this);

  @override
  String toString() => r'youtubePlaylistProvider';
}

abstract class _$YoutubePlaylist extends $AsyncNotifier<List<YouTubeVideo>> {
  late final _$args = ref.$arg as String;
  String get playlistId => _$args;

  FutureOr<List<YouTubeVideo>> build(String playlistId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<List<YouTubeVideo>>, List<YouTubeVideo>>;
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
