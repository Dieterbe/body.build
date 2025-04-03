import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:bodybuild/data/programmer/rating.dart';
import 'package:bodybuild/ui/programmer/util_groups.dart';
import 'package:url_launcher/url_launcher.dart';

class ExerciseRatingsDialog extends StatelessWidget {
  final String exerciseId;
  final List<Rating> ratings;

  const ExerciseRatingsDialog({
    super.key,
    required this.exerciseId,
    required this.ratings,
  });

  double _calculateAverageRating() {
    return ratings.fold<double>(0, (sum, rating) => sum + rating.score) /
        ratings.length;
  }

  Widget _buildCommentWithVideo(BuildContext context, String comment) {
    final RegExp urlRegex = RegExp(
      r'https?://(?:www\.)?(?:youtube\.com/watch\?v=|youtu\.be/)([^\s&]+)',
      caseSensitive: false,
    );
    final youtubeMatch = urlRegex.firstMatch(comment);
    String? videoUrl;
    if (youtubeMatch != null) {
      // Extract the full URL including any parameters
      // Find the end of the URL (next whitespace)
      int endIndex = comment.indexOf(' ', youtubeMatch.start);
      if (endIndex == -1) endIndex = comment.length;
      videoUrl = comment.substring(youtubeMatch.start, endIndex);
      print('videoUrl: $videoUrl');
    }

    // Split text into regular text and URL parts
    final List<TextSpan> textSpans = [];
    int lastEnd = 0;
    
    // Find all YouTube URLs in the comment
    for (var match in urlRegex.allMatches(comment)) {
      // Add text before URL
      if (match.start > lastEnd) {
        textSpans.add(TextSpan(text: comment.substring(lastEnd, match.start)));
      }
      
      // Find full URL up to next whitespace
      int endIndex = comment.indexOf(' ', match.start);
      if (endIndex == -1) endIndex = comment.length;
      final url = comment.substring(match.start, endIndex);
      
      // Add clickable URL
      textSpans.add(
        TextSpan(
          text: url,
          style: const TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              final uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              }
            },
        ),
      );
      
      lastEnd = endIndex;
    }
    
    // Add remaining text after last URL
    if (lastEnd < comment.length) {
      textSpans.add(TextSpan(text: comment.substring(lastEnd)));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: textSpans,
          ),
        ),
        if (videoUrl != null) ...[  
          const SizedBox(height: 8),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () async {
                if (videoUrl != null) {
                  final uri = Uri.parse(videoUrl);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  }
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    const Icon(Icons.play_arrow),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Watch video',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  List<InlineSpan> _buildTextSpans(BuildContext context, String text) {
    final List<InlineSpan> spans = [];
    final RegExp urlRegex = RegExp(
      r'https?://(?:www\.)?(?:youtube\.com/watch\?v=|youtu\.be/)([^\s&]+)',
      caseSensitive: false,
    );

    int lastMatchEnd = 0;
    for (final match in urlRegex.allMatches(text)) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
        ));
      }

      final url = text.substring(match.start, match.end);
      spans.add(
        TextSpan(
          text: url,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            decoration: TextDecoration.underline,
          ),
          recognizer: null, // Removed TapGestureRecognizer
        ),
      );

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd),
      ));
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    final avgRating = _calculateAverageRating();

    return AlertDialog(
      title: Text('Ratings for $exerciseId'),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.4,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Average Rating: ${(avgRating * 100).toStringAsFixed(1)}%',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...ratings.map((rating) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Source: ${rating.source.name}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                            'Score: ${(rating.score * 100).toStringAsFixed(1)}%'),
                        if (rating.comment.isNotEmpty)
                          _buildCommentWithVideo(context, rating.comment),
                        if (rating.pg.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 4,
                            children: rating.pg
                                .map((group) => Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: bgColorForProgramGroup(group),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        group.name,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ],
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
