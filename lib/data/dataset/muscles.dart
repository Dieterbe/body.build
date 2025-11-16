import 'package:bodybuild/data/dataset/articulations.dart';
import 'package:bodybuild/data/dataset/bones.dart';
import 'package:bodybuild/model/dataset/movements.dart';
import 'package:bodybuild/data/dataset/muscle_abs.dart';
import 'package:bodybuild/data/dataset/muscle_calves.dart';
import 'package:bodybuild/data/dataset/muscle_delts.dart';
import 'package:bodybuild/data/dataset/muscle_elbow_flexors.dart';
import 'package:bodybuild/data/dataset/muscle_forearm.dart';
import 'package:bodybuild/data/dataset/muscle_glutes.dart';
import 'package:bodybuild/data/dataset/muscle_hams.dart';
import 'package:bodybuild/data/dataset/muscle_lats.dart';
import 'package:bodybuild/data/dataset/muscle_neck.dart';
import 'package:bodybuild/data/dataset/muscle_pecs.dart';
import 'package:bodybuild/data/dataset/muscle_quads.dart';
import 'package:bodybuild/data/dataset/muscle_spinal_erectors.dart';
import 'package:bodybuild/data/dataset/muscle_traps.dart';
import 'package:bodybuild/data/dataset/muscle_triceps.dart';
import 'package:bodybuild/util/string_extension.dart';

// contains Id's for muscles, muscle heads, and areas within muscles or heads
// primary purpose here is anatomical correctness and using correct scientific terminology
enum MuscleId {
  wholeMuscle, // for single head muscles

  pectoralisMajor,
  pectoralisMajorClavicularHead,
  pectoralisMajorSternalHead,

  tricepsBrachii,
  tricepsBrachiiMedialHead,
  tricepsBrachiiLateralHead,
  tricepsBrachiiLongHead,

  latissimusDorsi,

  bicepsBrachii,
  bicepsBrachiiShortHead,
  bicepsBrachiiLongHead,
  brachialis,
  brachioradialis,

  forearmPronators,

  trapezius,
  trapeziusUpper,
  trapeziusMiddle,
  trapeziusLower,
  upperTrapsUpperFibers,
  upperTrapsLowerFibers,
  lowerTraps,
  middleTraps,

  deltoids,
  deltoidsAnteriorHead,
  deltoidsLateralHead,
  deltoidsPosteriorHead,

  gluteMaximus,
  gluteMedius,
  gluteMinimus,

  quadricepsFemoris,
  rectusFemoris,
  vastusMedialis,
  vastusLateralis,
  vastusIntermedius,

  hamstrings,
  bicepsFemorisLongHead,
  bicepsFemorisShortHead,
  semitendinosus,
  semimembranosus,

  gastrocnemius,
  gastrocnemiusLateralHead,
  gastrocnemiusMedialHead,
  soleus,

  wristExtensors,
  wristFlexors,

  neckFlexors,
  neckExtensors,

  // abs
  rectusAbdominis,
  externalObliques,
  internalObliques,
  transverseAbdominis,

  // spinal erectors
  longissimus,
  iliocostalis,
  spinalis,
}

// muscles are assigned a category (or maybe in the future, multiple) when instantiating
// used for grouping them in the UI
enum MuscleCategory {
  abs, // abdominals. X
  calves,
  delts, // deltoids
  elbowFlexors,
  forearm,
  glutes,
  hams, // hammies
  lats,
  neck,
  pecs,
  quads,
  spinalErectors,
  traps,
  triceps,
}

// the actual instantiated Muscle objects
List<Muscle> muscles = [
  rectusAbdominis,
  externalObliques,
  internalObliques,
  transverseAbdominis,
  gastrocnemius, //x
  soleus,
  deltoids,
  bicepsBrachii,
  brachialis,
  brachioradialis,
  forearmPronators,
  wristExtensors,
  wristFlexors,
  gluteMaximus,
  gluteMedius,
  gluteMinimus,
  hamstrings, // BF short head, biceps femoris long head+semis
  latissimusDorsi,
  neckFlexors,
  neckExtensors,
  pectoralisMajor,
  quadricepsFemoris,
  longissimus,
  iliocostalis,
  spinalis,
  trapezius,
  tricepsBrachii,
];

/* comment from Menno

Most are balanced.
Pecs and triceps a bit more fast-twitch.
Core muscles and traps a bit more slow-twitch.
The hams are a bit of an interesting case, because they’re quite balanced but have a very high proportion of type IIb fibers which makes them functionally fast-twitch dominant in most people.
Soleus super slow-twitch.

*/

sealed class Muscle {
  Muscle({
    required this.id,
    this.nick = const [],
    this.pseudo = false,
    this.insertion,
    required this.categories,
  }) {
    // add the instantiated muscle to a global list of muscles
    //muscles.add(this);
  }

  final MuscleId id;
  final List<String> nick;
  final bool pseudo;
  final Bone? insertion; // rarely, set at the Head level instead
  final List<MuscleCategory> categories;

  get name => id.name.camelToTitle();

  List<Head> get heads;

  List<MovementStruct> getMovements(Articulation a);
  List<Articulation> getArticulations();

  String nameWithHead(MuscleId? head) {
    // e.g.
    // name: Deltoids, head: MuscleId.deltoidsAnteriorHead -> print Deltoids (Anterior Head)
    // name: Pectoralis major, head:MuscleId.pectoralisMajorClavicularHead -> print Pectoralis major (Clavicular Head)
    return name +
        (head != null ? ' (${head.name.camelToTitle().replaceFirst(name + ' ', '')})' : '');
  }
}

class MultiHeadMuscle extends Muscle {
  final List<Movement> movements; // movements that all heads have in common
  final Map<MuscleId, Head> headsMap;

  MultiHeadMuscle({
    // required super.name,
    super.nick,
    super.pseudo,
    super.insertion, // rarely, set at the Head level instead
    required this.movements,
    required this.headsMap,
    required super.categories,
    required super.id,
  });

  @override
  List<Head> get heads => headsMap.values.toList();

  @override
  List<MovementStruct> getMovements(Articulation a) =>
      movements
          .where((mo) => mo.articulation == a)
          .map((mo) => MovementStruct(this, null, mo))
          .toList()
        ..addAll(
          headsMap.entries.expand(
            (entry) => entry.value.movements
                .where((mo) => mo.articulation == a)
                .map((mo) => MovementStruct(this, entry.key, mo)),
          ),
        );

  @override
  List<Articulation> getArticulations() => <Articulation>{
    ...movements.map((m) => m.articulation),
    ...headsMap.values.expand((h) => h.movements.map((m) => m.articulation)),
  }.toList();
}

class SingleHeadMuscle extends Muscle {
  late Head wholeHead;

  SingleHeadMuscle({
    //required super.name,
    super.nick,
    super.pseudo,
    required super.insertion,
    // head properties
    required List<Bone> origin,
    int articular = 1,
    required List<Movement> movements,
    required super.categories,
    Insufficiency? activeInsufficiency,
    Insufficiency? passiveInsufficiency,
    required super.id,
  }) {
    wholeHead = Head(
      id: MuscleId.wholeMuscle,
      name: 'whole muscle',
      origin: origin,
      articular: articular,
      movements: movements,
      activeInsufficiency: activeInsufficiency,
      passiveInsufficiency: passiveInsufficiency,
    );
  }

  @override
  List<Head> get heads => [wholeHead];

  @override
  List<MovementStruct> getMovements(Articulation a) => wholeHead.movements
      .where((mo) => mo.articulation == a)
      .map((mo) => MovementStruct(this, null, mo))
      .toList();

  @override
  List<Articulation> getArticulations() => wholeHead.movements.map((m) => m.articulation).toList();
}

class Head {
  const Head({
    required this.name, // for display purposes
    required this.id,
    this.nick = const [],
    required this.origin,
    this.insertion,
    this.articular = 1,
    required this.movements,
    this.activeInsufficiency,
    this.passiveInsufficiency,
  });

  final String name;
  final MuscleId id;
  final List<String> nick;
  final List<Bone> origin;
  final Bone? insertion; // rarely, heads insert to a different place
  final int articular;
  final List<Movement> movements;
  final Insufficiency? activeInsufficiency;
  final Insufficiency? passiveInsufficiency;
}

class Insufficiency {
  final List<InsufficiencyFactor> factors;
  final String? comment;

  const Insufficiency({this.comment, required this.factors});
}

class InsufficiencyFactor {
  const InsufficiencyFactor(this.articulation, this.degrees);

  final Articulation articulation;
  final int degrees;
}

class MovementStruct {
  final Muscle muscle;
  final MuscleId? head;
  final Movement mo;

  MovementStruct(this.muscle, this.head, this.mo);
}
