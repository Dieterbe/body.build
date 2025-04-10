import 'package:flutter/material.dart';
import 'package:bodybuild/data/programmer/rating.dart';
import 'package:bodybuild/ui/programmer/widget/rating_star.dart';

class RatingIcon extends StatelessWidget {
  final List<Rating> ratings;
  final double? size;
  final VoidCallback? onTap;

  const RatingIcon({
    super.key,
    required this.ratings,
    this.size,
    this.onTap,
  });

  double _calculateAverageRating() {
    if (ratings.isEmpty) return 0;
    return ratings.map((r) => r.score).reduce((a, b) => a + b) / ratings.length;
  }

  @override
  Widget build(BuildContext context) {
    if (ratings.isEmpty) return const SizedBox.shrink();

    final avgRating = _calculateAverageRating();
    final iconWidget = RatingStars.starFromScore(
      avgRating,
      context,
      size: size,
    );

    if (onTap == null) return iconWidget;

    return InkWell(
      onTap: onTap,
      child: iconWidget,
    );
  }
}
