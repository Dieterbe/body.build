import 'package:flutter/material.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

// note: posthog events asume this is only used on home screen
class YoutubeVideoCard extends StatelessWidget {
  const YoutubeVideoCard({
    super.key,
    required this.videoId,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
  });
  final String videoId;
  final String title;
  final String description;
  final String thumbnailUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Use a fixed reasonable width that works well for both portrait and landscape videos
    // YouTube thumbnails are always landscape (even for Shorts), so we can't reliably
    // determine actual video orientation from thumbnail aspect ratio alone
    const thumbnailHeight = 200.0;
    const cardWidth = 280.0; // Balanced width that looks good for all video types

    return SizedBox(
      width: cardWidth,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap: () => _openYouTubeVideo(videoId),
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Video thumbnail with actual YouTube thumbnail
              Container(
                height: thumbnailHeight,
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // YouTube thumbnail image // TODO: cache it
                      Image.network(
                        semanticLabel: 'video thumbnail image',
                        thumbnailUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  colorScheme.primary.withValues(alpha: 0.8),
                                  colorScheme.primary.withValues(alpha: 0.6),
                                ],
                              ),
                            ),
                            child: const Center(child: CircularProgressIndicator()),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback to gradient background if thumbnail fails to load
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  colorScheme.primary.withValues(alpha: 0.8),
                                  colorScheme.primary.withValues(alpha: 0.6),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      // Dark overlay for better contrast
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.3)],
                          ),
                        ),
                      ),
                      // Play button overlay
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.play_arrow, color: Colors.white, size: 40),
                        ),
                      ),
                      // YouTube logo in corner
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'YouTube',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Text(
                          description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _openYouTubeVideo(String videoId) async {
  final youtubeUrl = 'https://www.youtube.com/watch?v=$videoId';

  await Posthog().capture(
    eventName: 'YouTubeVideoClicked',
    properties: {'source': 'home_screen', 'video_url': youtubeUrl, 'video_id': videoId},
  );

  final uri = Uri.parse(youtubeUrl);
  try {
    // Try to launch with external application mode first
    // this seems to work well on web, but not android, which shows
    // component name for https://www.youtube.com/watch?v=wOVZdZ9_jdE is null"
    await launchUrl(uri, mode: LaunchMode.externalApplication, webOnlyWindowName: '_blank');
  } catch (e) {
    // Fallback: try with platform default mode
    try {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    } catch (e) {
      // Final fallback: try with in-app web view
      await launchUrl(uri, mode: LaunchMode.inAppWebView);
    }
  }
}
