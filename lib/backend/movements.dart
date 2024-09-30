import 'dart:math';

import 'package:ptc/backend/articulations.dart';
import 'package:ptc/backend/muscles.dart';

// types of strength:
// "absolute" due to muscle length
// relative due to moment arm
// comparison to other muscles for a movement (so you know which muscles get trained)
// comparison to other movements for the same muscle (so you know how to train a muscle)
class Movement {
  const Movement({
    required this.articulation,
    this.rangeStart,
    this.rangeEnd,
    this.momentMax,
    required this.strength,
  });
  final Articulation articulation;
  final int? rangeStart;
  final int? rangeEnd;
  final int? momentMax; // degrees of the movement for max moment
  // strength. this is not an "absolute scale". it's wrt to the max strength you can achieve for
  // the given movement (so the primary knee extensor and the primary wrist extensor would get the same score)
  // 1: trivial, 2: very weak, 3: weak, 4: moderate or unknown (!), 5: strong, 6: strongest
  // best practice: put a comment in words any time you set this parameter, to easy future refactors
  // primary function -> 5/6 (depends on other muscles if they're stronger)
  // secondary function -> 4/5 (depends on other muscles if they're stronger)
  final int strength;
}
// NOTE: degrees of supination and pronation come from:
// https://musculoskeletalkey.com/structure-and-function-of-the-elbow-and-forearm-complex/

// the result of compiling all movement information for any given articulation
class ArticulationMovements {
  final Articulation articulation;
  late List<MovementStruct> moves;

  late int rangeStart;
  late int rangeEnd;

  ArticulationMovements(this.articulation) {
    moves = _getMovements(articulation).toList();
    assert(moves.isNotEmpty);
    final rangeStarts =
        moves.map((m) => m.mo.rangeStart).whereType<int>().toList();
    final rangeEnds = moves.map((m) => m.mo.rangeEnd).whereType<int>().toList();
    assert(rangeStarts.isNotEmpty);
    assert(rangeEnds.isNotEmpty);

    rangeStart = rangeStarts.fold(1000, min);
    rangeEnd = rangeEnds.fold(-1000, max);
    assert(rangeEnd > rangeStart);
  }

  int get range => rangeEnd - rangeStart;

  List<MovementStruct> _getMovements(Articulation a) =>
      Muscle.values.expand((mu) => mu.getMovements(a)).toList();
}
