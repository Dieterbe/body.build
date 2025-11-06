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

    Map<String, dynamic>? selectedThumbnail;
    if (thumbnails.containsKey('maxres')) {
      selectedThumbnail = thumbnails['maxres'];
    } else if (thumbnails.containsKey('standard')) {
      selectedThumbnail = thumbnails['standard'];
    } else if (thumbnails.containsKey('high')) {
      selectedThumbnail = thumbnails['high'];
    } else if (thumbnails.containsKey('medium')) {
      selectedThumbnail = thumbnails['medium'];
    } else {
      selectedThumbnail = thumbnails['default'];
    }

    thumbnailUrl = selectedThumbnail!['url'];

    return YouTubeVideo(
      videoId: resourceId['videoId'] as String,
      title: snippet['title'] as String,
      description: snippet['description'] as String,
      thumbnailUrl: thumbnailUrl,
    );
  }
}
