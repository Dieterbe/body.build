import 'dart:convert';
import 'package:bodybuild/model/youtube_video.dart';
import 'package:http/http.dart' as http;
import 'package:posthog_flutter/posthog_flutter.dart';

class YouTubeService {
  // Note this key can't be kept secret (it can be reverse engineered from the code, and shows in
  // network requests). Instead, the key is locked down by HTTP origin, mobile bundleId, etc.
  static const String _apiKey = String.fromEnvironment('YOUTUBE_API_KEY');
  static const String _baseUrl = 'https://www.googleapis.com/youtube/v3';

  /// Fallback list of hardcoded videos when API fails
  static List<YouTubeVideo> getFallbackVideos() {
    return [
      YouTubeVideo(
        videoId: '0NjaZz44NQ0',
        title: 'Features of Body.Build! Apps coming soon!',
        description: 'Features of Body.Build! Apps coming soon! Email us for early access!',
        thumbnailUrl: 'https://img.youtube.com/vi/0NjaZz44NQ0/maxresdefault.jpg',
      ),
    ];
  }

  /// Fetches videos from a YouTube playlist
  /// Returns a list of YouTubeVideo objects
  Future<List<YouTubeVideo>> fetchPlaylistVideos(String playlistId) async {
    if (_apiKey.isEmpty) {
      print('fetchPlaylistVideos: YouTube API key is not set - using fallback videos');
      return getFallbackVideos();
    }
    try {
      final url = Uri.parse(
        '$_baseUrl/playlistItems?part=snippet&maxResults=50&playlistId=$playlistId&key=$_apiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final items = data['items'] as List;

        return items.map((item) => YouTubeVideo.fromJson(item as Map<String, dynamic>)).toList();
      }
      throw Exception('Failed to load playlist: ${response.statusCode}');
    } catch (e) {
      // Return fallback videos on error
      print(
        'fetchPlaylistVideos: Error while fetching playlist $playlistId: $e - using fallback videos',
      );
      await Posthog().capture(
        eventName: 'youtube_playlist_load_failed',
        properties: {'playlist_id': playlistId, 'error': e.toString()},
      );
      return getFallbackVideos();
    }
  }
}
