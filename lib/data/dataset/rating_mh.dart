import 'package:bodybuild/data/dataset/groups.dart';
import 'package:bodybuild/data/dataset/rating.dart';

const ratingMhCableCurl = Rating(
  source: Source.mennoHenselmans,
  score: 1,
  pg: [ProgramGroup.biceps],
  comment:
      '''According to Menno, who named the exercise the "Bayesian bicep curl", it is the "perfect bicep exercise, because it allows to keep maximum tension on the bicep at all times.". [Menno's scientific arguments here](https://mennohenselmans.com/bayesian-curls/)''',
  tweaks: {'style': 'bayesian'},
);
