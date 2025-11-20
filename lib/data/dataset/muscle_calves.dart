// tricepsSurae and calves comprise of 2 separate muscles
import 'package:bodybuild/data/dataset/articulation.dart';
import 'package:bodybuild/data/dataset/bone.dart';
import 'package:bodybuild/model/dataset/movement.dart';
import 'package:bodybuild/data/dataset/muscle.dart';

final gastrocnemius = MultiHeadMuscle(
  id: MuscleId.gastrocnemius,
  categories: [MuscleCategory.calves],
  movements: [
    const Movement(
      articulation: Articulation.anklePlantarFlexion,
      strength: 6,
      rangeStart: 0,
      rangeEnd: 50,
    ),
    const Movement(
      // active insufficiency when flexed to a certain level at both joints
      // leg curl with plantar flexed -> take out gastroc contribution
      // with foot dorsiflexed -> gastroc contributes
      // calf raises with knee flexed shortens gastroc,
      // they can produce less tension or even enter active insufficiency
      // good way to takee out gastroc contribution.
      // https://www.ncbi.nlm.nih.gov/pubmed/22190157/
      // also: some studies show pointing feet out is more growth of medial, and feet in more lateral
      // yes:// Nunes et. al. 2020 - https://www.researchgate.net/publication/340730817_Different_foot_positioning_during_calf_training_to_induce_portion-specific_gastrocnemius_muscle_hypertrophy/stats
      // EMG https://content.iospress.com/articles/isokinetics-and-exercise-science/ies654
      // but not this study: https://doi.org/10.17784/mtprehabjournal.2017.15.529
      articulation: Articulation.kneeFlexion,
      strength: 4,
      rangeStart: 0,
      rangeEnd: 150,
    ),
  ],
  insertion: Bone.heel,
  headsMap: {
    MuscleId.gastrocnemiusMedialHead: const Head(
      id: MuscleId.gastrocnemiusMedialHead,
      movements: [],
      articular: 2,
      name: 'medial head',
      origin: [Bone.femur],
    ),
    MuscleId.gastrocnemiusLateralHead: const Head(
      id: MuscleId.gastrocnemiusLateralHead,
      movements: [],
      name: 'lateral head',
      articular: 2,
      origin: [Bone.femur],
    ),
  },
);
final soleus = SingleHeadMuscle(
  id: MuscleId.soleus,
  categories: [MuscleCategory.calves],
  insertion: Bone.heel,
  origin: [Bone.tibiaFibula],
  movements: [
    const Movement(
      articulation: Articulation.anklePlantarFlexion,
      strength: 6,
      rangeStart: 0,
      rangeEnd: 50,
    ),
  ],
);
