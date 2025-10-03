import 'package:bodybuild/ui/programmer/widget/rating_icon.dart';
import 'package:flutter/material.dart';
import 'package:bodybuild/data/programmer/rating.dart';

class RatingIconMulti extends StatelessWidget {
  final List<Rating> ratings;
  final double? size;
  final VoidCallback? onTap;

  const RatingIconMulti({super.key, required this.ratings, this.size, this.onTap});

  double _calculateAverageRating() {
    if (ratings.isEmpty) return 0;
    return ratings.map((r) => r.score).reduce((a, b) => a + b) / ratings.length;
  }

  @override
  Widget build(BuildContext context) {
    if (ratings.isEmpty) return const SizedBox.shrink();

    final avgRating = _calculateAverageRating();
    return RatingIcon(score: avgRating, size: size, onTap: onTap);
  }
}
