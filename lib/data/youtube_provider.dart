import 'package:bodybuild/model/youtube_video.dart';
import 'package:bodybuild/service/youtube_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'youtube_provider.g.dart';

const String playlistMobileApp = 'PLYH6XD4vblGAfZRrZs8hIDUAMYx80LeYO';
@riverpod
Future<List<YouTubeVideo>> youtubePlaylist(Ref _) async {
  final service = YouTubeService();
  return await service.fetchPlaylistVideos(playlistMobileApp);
}
