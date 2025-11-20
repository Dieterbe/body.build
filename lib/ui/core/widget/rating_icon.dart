import 'package:bodybuild/ui/core/widget/rating_star.dart';
import 'package:flutter/material.dart';

class RatingIcon extends StatelessWidget {
  final double score;
  final double? size;
  final VoidCallback? onTap;

  const RatingIcon({super.key, required this.score, this.size, this.onTap});

  @override
  Widget build(BuildContext context) {
    final iconWidget = RatingStar.fromScore(score: score, size: size);

    if (onTap == null) return iconWidget;

    return InkWell(onTap: onTap, child: iconWidget);
  }
}
