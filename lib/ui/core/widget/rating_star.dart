import 'package:flutter/material.dart';

/// Rating star widget that can be instantiated directly or from a score (0-1).
class RatingStar extends StatelessWidget {
  static const double _defaultIconSize = 32.0;

  const RatingStar({super.key, required this.rating, this.size, this.color})
    : assert(rating >= 1 && rating <= 10, 'Rating number must be between 1 and 10');

  RatingStar.fromScore({super.key, required double score, this.size, this.color})
    : assert(score >= 0.0 && score <= 1.0, 'Score must be between 0.0 and 1.0'),
      rating = (score * 10).round();

  final int rating;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final iconSize = size ?? _defaultIconSize;
    final ThemeData theme = Theme.of(context);

    if (rating == 0) {
      return Icon(Icons.star_outline, size: iconSize, color: theme.colorScheme.primary);
    }

    final colorBG = color ?? theme.colorScheme.primary;
    final colorFG = theme.colorScheme.onPrimary;
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(Icons.star, size: iconSize, color: colorBG),
        Text(
          rating.toString(),
          style: TextStyle(
            color: colorFG,
            fontSize: iconSize * 0.4,
            fontWeight: rating == 10 ? FontWeight.w900 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
