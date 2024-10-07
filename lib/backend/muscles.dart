import 'package:ptc/backend/articulations.dart';
import 'package:ptc/backend/bones.dart';
import 'package:ptc/backend/movements.dart';
import 'package:ptc/backend/muscle_abs.dart';
import 'package:ptc/backend/muscle_calves.dart';
import 'package:ptc/backend/muscle_delts.dart';
import 'package:ptc/backend/muscle_elbow_flexors.dart';
import 'package:ptc/backend/muscle_forearm.dart';
import 'package:ptc/backend/muscle_glutes.dart';
import 'package:ptc/backend/muscle_hams.dart';
import 'package:ptc/backend/muscle_lats.dart';
import 'package:ptc/backend/muscle_neck.dart';
import 'package:ptc/backend/muscle_pecs.dart';
import 'package:ptc/backend/muscle_quads.dart';
import 'package:ptc/backend/muscle_spinal_erectors.dart';
import 'package:ptc/backend/muscle_traps.dart';
import 'package:ptc/backend/muscle_triceps.dart';
import 'package:ptc/util.dart';

enum MuscleId {
  pectoralisMajor,
  tricepsBrachii,
  latissimusDorsi,
  bicepsBrachii,
  brachialis,
  brachioradialis,
  forearmPronators,
  trapeziusUpper,
  trapeziusMiddle,
  trapeziusLower,
  deltoids,
  gluteMaximus,
  gluteMedius,
  gluteMinimus,
  quadricepsFemoris,
  hamstrings,
  gastrocnemius,
  soleus,
  errectorSpinae,
  abdominals,
  wristExtensors,
  wristFlexors,
  neckFlexors,
  neckExtensors,
  rectusAbdominis,
  externalObliques,
  transverseAbdominis,
  longissimus,
  iliocostalis,
  trapezius,
  spinalis,
}

enum MuscleCategory {
  abs, // abdominals
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

List<Muscle> muscles = [
  rectusAbdominis,
  externalObliques,
  internalObliques,
  transverseAbdominis,
  gastrocnemius,
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
  hamstrings,
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

  String nameWithHead(String? head) =>
      name + (head != null ? ' ($head head)' : '');
}

class MultiHeadMuscle extends Muscle {
  final List<Movement> movements; // movements that all heads have in common
  final Map<String, Head> headsMap;

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
  List<MovementStruct> getMovements(Articulation a) => movements
      .where((mo) => mo.articulation == a)
      .map((mo) => MovementStruct(this, null, mo))
      .toList()
    ..addAll(headsMap.entries.expand((entry) => entry.value.movements
        .where((mo) => mo.articulation == a)
        .map((mo) => MovementStruct(this, entry.key, mo))));

  @override
  List<Articulation> getArticulations() => <Articulation>{
        ...movements.map((m) => m.articulation),
        ...headsMap.values.expand((h) => h.movements.map((m) => m.articulation))
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
  List<Articulation> getArticulations() =>
      wholeHead.movements.map((m) => m.articulation).toList();
}

class Head {
  const Head({
    required this.name, // for display purposes
    this.nick = const [],
    required this.origin,
    this.insertion,
    this.articular = 1,
    required this.movements,
    this.activeInsufficiency,
    this.passiveInsufficiency,
  });

  final String name;
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

  @override
  String toString() {
    return '${articulation.name.camelToTitle()} @ $degrees';
  }
}

class MovementStruct {
  final Muscle muscle;
  final String? head;
  final Movement mo;

  MovementStruct(this.muscle, this.head, this.mo);
}
