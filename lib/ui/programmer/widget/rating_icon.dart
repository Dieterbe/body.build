import 'package:flutter/material.dart';
import 'package:bodybuild/data/programmer/rating.dart';

class RatingIcon extends StatelessWidget {
  final List<Rating> ratings;
  final double? size;
  final Color? color;
  final VoidCallback? onTap;

  const RatingIcon({
    super.key,
    required this.ratings,
    this.size,
    this.color,
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
    final icon = avgRating >= 0.9
        ? Icons.star
        : avgRating >= 0.5
            ? Icons.star_half
            : Icons.star_outline;

    final iconWidget = Icon(
      icon,
      size: size ?? MediaQuery.of(context).size.width / 120,
      color: color ?? Theme.of(context).colorScheme.primary,
    );

    if (onTap == null) return iconWidget;

    return InkWell(
      onTap: onTap,
      child: iconWidget,
    );
  }
}
