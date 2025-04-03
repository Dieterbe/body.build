import 'package:bodybuild/ui/core/markdown.dart';
import 'package:flutter/material.dart';
import 'package:bodybuild/data/programmer/rating.dart';
import 'package:bodybuild/ui/programmer/util_groups.dart';
import 'package:bodybuild/util.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        markdown(comment),
      ],
    );
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
                          'Source: ${rating.source.name.camelToSpace().capitalizeFirst()}',
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
