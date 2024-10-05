import 'package:ptc/backend/articulations.dart';
import 'package:ptc/backend/bones.dart';
import 'package:ptc/backend/movements.dart';
import 'package:ptc/util.dart';

enum MuscleName {
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
  deltoidAnterior,
  deltoidLateral,
  deltoidPosterior,
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
}

sealed class Muscle {
  Muscle({
    this.nick = const [],
    this.pseudo = false,
    required this.insertion,
  });

  final List<String> nick;
  final bool pseudo;
  final Bone insertion;

  String nameWithHead(String? head) =>
      name.camelToTitle() + (head != null ? ' ($head head)' : '');

  List<MovementStruct> getMovements(Articulation a) => movements
      .where((mo) => mo.articulation == a)
      .map((mo) => MovementStruct(this, null, mo))
      .toList()
    ..addAll(heads.values.expand((head) => head.movements
        .where((mo) => mo.articulation == a)
        .map((mo) => MovementStruct(this, head.name, mo))));

  List<Articulation> getArticulations() => <Articulation>{
        ...movements.map((m) => m.articulation),
        ...heads.values.expand((h) => h.movements.map((m) => m.articulation))
      }.toList();
}

class MultiHeadMuscle extends Muscle {
  final List<Movement> movements;
  final Map<String, Head> heads;

  MultiHeadMuscle({
    // required super.name,
    super.nick,
    super.pseudo,
    required super.insertion,
    required this.movements,
    required this.heads,
  });
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
    Insufficiency? activeInsufficiency,
    Insufficiency? passiveInsufficiency,
  }) {
    wholeHead = Head(
      origin: origin,
      articular: articular,
      movements: movements,
      activeInsufficiency: activeInsufficiency,
      passiveInsufficiency: passiveInsufficiency,
    );
  }
}

class Head {
  const Head({
    this.name,
    this.nick = const [],
    required this.origin,
    this.articular = 1,
    required this.movements,
    this.activeInsufficiency,
    this.passiveInsufficiency,
  });

  final String? name;
  final List<String> nick;
  final List<Bone> origin;
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
