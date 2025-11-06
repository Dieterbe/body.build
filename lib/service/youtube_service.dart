import 'dart:convert';
import 'dart:io';
import 'package:bodybuild/model/youtube_video.dart';
import 'package:http/http.dart' as http;
import 'package:posthog_flutter/posthog_flutter.dart';

/// Result of fetching a YouTube playlist
class PlaylistResult {
  final List<YouTubeVideo> videos;
  final bool isFallback;

  const PlaylistResult({required this.videos, required this.isFallback});
}

class YouTubeService {
  // Note this key can't be kept secret (it can be reverse engineered from the code, and shows in
  // network requests). Instead, the key is locked down by HTTP origin, mobile bundleId, etc.
  static const String _apiKey = String.fromEnvironment('YOUTUBE_API_KEY');
  static const String _baseUrl = 'https://www.googleapis.com/youtube/v3';

  // Retry configuration
  static const int _maxRetries = 3;
  static const Duration _initialRetryDelay = Duration(milliseconds: 500);
  static const Duration _requestTimeout = Duration(seconds: 10);

  /// Fallback list of hardcoded videos when API fails
  static const List<YouTubeVideo> _fallbackVideos = [
    YouTubeVideo(
      videoId: '0NjaZz44NQ0',
      title: 'Features of Body.Build! Apps coming soon!',
      description: 'Features of Body.Build! Apps coming soon! Email us for early access!',
      thumbnailUrl: 'https://img.youtube.com/vi/0NjaZz44NQ0/maxresdefault.jpg',
    ),
  ];

  /// Fetches videos from a YouTube playlist with retry logic
  /// Returns a PlaylistResult object
  Future<PlaylistResult> fetchPlaylistVideos(String playlistId) async {
    if (_apiKey.isEmpty) {
      print('fetchPlaylistVideos: YouTube API key is not set - using fallback videos');
      return const PlaylistResult(videos: _fallbackVideos, isFallback: true);
    }

    final url = Uri.parse(
      '$_baseUrl/playlistItems?part=snippet&maxResults=50&playlistId=$playlistId&key=$_apiKey',
    );

    for (int attempt = 0; attempt < _maxRetries; attempt++) {
      try {
        final response = await http.get(url).timeout(_requestTimeout);

        if (response.statusCode == 200) {
          final data = json.decode(response.body) as Map<String, dynamic>;
          final items = data['items'] as List;

          final videos = items
              .map((item) => YouTubeVideo.fromJson(item as Map<String, dynamic>))
              .toList();

          if (attempt > 0) {
            print('fetchPlaylistVideos: attempt ${attempt + 1}/$_maxRetries: success');
          }

          return PlaylistResult(videos: videos, isFallback: false);
        }
        throw Exception('Failed to load playlist: ${response.statusCode}');
      } on SocketException catch (e) {
        // DNS or network connectivity issues - retry
        final isLastAttempt = attempt == _maxRetries - 1;
        print('fetchPlaylistVideos: attempt ${attempt + 1}/$_maxRetries: socket error $e');

        if (isLastAttempt) {
          print('fetchPlaylistVideos: All retries exhausted - using fallback videos');
          await Posthog().capture(
            eventName: 'youtube_playlist_load_failed',
            properties: {'playlist_id': playlistId, 'error': e.toString(), 'attempts': _maxRetries},
          );
          return const PlaylistResult(videos: _fallbackVideos, isFallback: true);
        }

        // Exponential backoff: 500ms, 1000ms, 2000ms
        final delay = _initialRetryDelay * (1 << attempt);
        print('fetchPlaylistVideos: Retrying in ${delay.inMilliseconds}ms...');
        await Future.delayed(delay);
      } catch (e) {
        // Other errors (parsing, timeout, etc.) - retry
        final isLastAttempt = attempt == _maxRetries - 1;
        print('fetchPlaylistVideos: attempt ${attempt + 1}/$_maxRetries: error $e');

        if (isLastAttempt) {
          print('fetchPlaylistVideos: All retries exhausted - using fallback videos');
          await Posthog().capture(
            eventName: 'youtube_playlist_load_failed',
            properties: {'playlist_id': playlistId, 'error': e.toString(), 'attempts': _maxRetries},
          );
          return const PlaylistResult(videos: _fallbackVideos, isFallback: true);
        }

        // Exponential backoff
        final delay = _initialRetryDelay * (1 << attempt);
        print('fetchPlaylistVideos: Retrying in ${delay.inMilliseconds}ms...');
        await Future.delayed(delay);
      }
    }

    // Should never reach here, but just in case
    return const PlaylistResult(videos: _fallbackVideos, isFallback: true);
  }
}
