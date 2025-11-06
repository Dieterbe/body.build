import 'dart:async';
import 'package:bodybuild/model/youtube_video.dart';
import 'package:bodybuild/service/youtube_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'youtube_provider.g.dart';

const String playlistMobileApp = 'PLYH6XD4vblGAfZRrZs8hIDUAMYx80LeYO';

@riverpod
class YoutubePlaylist extends _$YoutubePlaylist {
  Timer? _retryTimer;

  @override
  Future<List<YouTubeVideo>> build() async {
    // Cancel any existing timer when provider is rebuilt
    _retryTimer?.cancel();

    final service = YouTubeService();
    final result = await service.fetchPlaylistVideos(playlistMobileApp);

    // If we got fallback videos, schedule a retry in 30 seconds
    if (result.isFallback) {
      print('youtubePlaylist: Using fallback videos, will retry in 30 seconds');
      _scheduleRetry();
    }

    return result.videos;
  }

  void _scheduleRetry() {
    _retryTimer?.cancel();
    _retryTimer = Timer(const Duration(seconds: 30), () {
      print('youtubePlaylist: Retrying playlist fetch after fallback');
      ref.invalidateSelf();
    });
  }

  /// Manually trigger a refresh (useful for pull-to-refresh)
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}
