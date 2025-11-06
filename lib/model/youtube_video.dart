/// Model for a YouTube video in a playlist
class YouTubeVideo {
  final String videoId;
  final String title;
  final String description;
  final String thumbnailUrl;

  const YouTubeVideo({
    required this.videoId,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
  });

  factory YouTubeVideo.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet'] as Map<String, dynamic>;
    final resourceId = snippet['resourceId'] as Map<String, dynamic>;
    final thumbnails = snippet['thumbnails'] as Map<String, dynamic>;

    // Try to get the best quality thumbnail available
    String thumbnailUrl;
    if (thumbnails.containsKey('maxres')) {
      thumbnailUrl = thumbnails['maxres']['url'];
    } else if (thumbnails.containsKey('standard')) {
      thumbnailUrl = thumbnails['standard']['url'];
    } else if (thumbnails.containsKey('high')) {
      thumbnailUrl = thumbnails['high']['url'];
    } else if (thumbnails.containsKey('medium')) {
      thumbnailUrl = thumbnails['medium']['url'];
    } else {
      thumbnailUrl = thumbnails['default']['url'];
    }

    return YouTubeVideo(
      videoId: resourceId['videoId'] as String,
      title: snippet['title'] as String,
      description: snippet['description'] as String,
      thumbnailUrl: thumbnailUrl,
    );
  }
}
