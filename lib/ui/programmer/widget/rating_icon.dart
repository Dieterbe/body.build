import 'package:flutter/material.dart';
import 'package:bodybuild/ui/programmer/widget/rating_star.dart';

class RatingIcon extends StatelessWidget {
  final double score;
  final double? size;
  final VoidCallback? onTap;

  const RatingIcon({super.key, required this.score, this.size, this.onTap});

  @override
  Widget build(BuildContext context) {
    final iconWidget = RatingStars.starFromScore(score, context, size: size);

    if (onTap == null) return iconWidget;

    return InkWell(onTap: onTap, child: iconWidget);
  }
}
