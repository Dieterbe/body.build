import 'package:bodybuild/model/programmer/set_group.dart';
import 'package:bodybuild/ui/core/widget/exercise_ratings_dialog.dart';
import 'package:bodybuild/ui/core/widget/rating_icon_multi.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

Widget buildRatingIcon(Sets sets, String tweakName, String tweakValue, BuildContext context) {
  if (sets.ex == null) return const SizedBox.shrink();

  // Get ratings for current configuration
  final currentRatings = sets.getApplicableRatingsForConfig(sets.tweakOptions).toList();

  // Get ratings for this tweak configuration
  final ratings = sets.getApplicableRatingsForConfig({
    ...sets.tweakOptions,
    tweakName: tweakValue,
  }).toList();

  // Only show rating icon if this option changes the ratings
  final ratingScores = ratings.map((r) => r.score).toList();
  final currentRatingScores = currentRatings.map((r) => r.score).toList();
  if (const ListEquality().equals(ratingScores, currentRatingScores)) {
    return const SizedBox.shrink();
  }

  return RatingIconMulti(
    ratings: ratings,
    onTap: ratings.isEmpty ? null : () => {showRatingsDialog(sets.ex!.id, ratings, context)},
  );
}
