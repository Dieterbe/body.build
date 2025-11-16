import 'package:flutter/material.dart';

/// A collection of rating star icons with numbers 1-10
class RatingStars {
  static const double _defaultIconSize = 32.0;

  /// Returns a star icon with a number overlay (1-10)
  static Widget star(int number, BuildContext context, {double? size, Color? color}) {
    assert(number >= 1 && number <= 10, 'Rating number must be between 1 and 10');
    final colorBG = Theme.of(context).colorScheme.primary;
    final colorFG = Theme.of(context).colorScheme.onPrimary;
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(Icons.star, size: size ?? _defaultIconSize, color: colorBG),
        Text(
          number.toString(),
          style: TextStyle(
            color: colorFG,
            fontSize: (size ?? _defaultIconSize) * 0.4,
            fontWeight: number == 10 ? FontWeight.w900 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  /// Returns a star icon based on a rating score (0.0 to 1.0)
  static Widget starFromScore(double score, BuildContext context, {double? size}) {
    assert(score >= 0.0 && score <= 1.0, 'Score must be between 0.0 and 1.0');
    final number = (score * 10).round();
    if (number == 0) {
      return Icon(
        Icons.star_outline,
        size: size ?? _defaultIconSize,
        color: Theme.of(context).colorScheme.primary,
      );
    }
    return star(number, context, size: size);
  }
}
