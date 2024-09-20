import 'package:ptc/articulations.dart';
import 'package:ptc/bones.dart';

enum Muscle {
  pectoralisMajor(
      pseudo: false,
      nick: ['chest', 'pecs'],
      insertion: Bone.humerus,
      heads: {
        'clavicular': Head(
          name: 'clavicular',
          nick: ['upper'],
          origin: Bone.clavicle,
          articular: 1,
        ),
        'sternal': Head(
          name: 'sternal',
          nick: ['lower'],
          origin: Bone.sternum,
          articular: 1,
        )
      }),
  tricepsBrachii(
    pseudo: false,
    nick: ['tris'],
    insertion: Bone.ulna,
    heads: {
      'long': Head(
        name: 'long',
        nick: [],
        origin: Bone.scapula,
        articular: 2,
      ),
      'lateral': Head(
        name: 'lateral',
        nick: [],
        origin: Bone.humerus, // top of
        articular: 1,
      ),
      'medial': Head(
          name: 'medial',
          nick: [],
          origin: Bone.humerus, // middle of
          articular: 1,
          activeInsuffiency: [
            // arm extended behind body
            Insufficiency(Articulation.elbowExtension, 0),
            Insufficiency(Articulation.shoulderFlexion, 20)
          ],
          passiveInsufficiency: [
            // arm bent overhead
            Insufficiency(Articulation.shoulderFlexion, 160),
            Insufficiency(Articulation.elbowFlexion, 150)
          ]),
    },
  );

  const Muscle({
    required this.nick,
    required this.pseudo,
    required this.insertion,
    required this.heads,
  });

  final List<String> nick;
  final bool pseudo;
  final Bone insertion;
  final Map<String, Head> heads;
}

class Head {
  const Head({
    required this.name,
    required this.nick,
    required this.origin,
    required this.articular,
    this.activeInsuffiency,
    this.passiveInsufficiency,
  });

  final String name;
  final List<String> nick;
  final Bone origin;
  final int articular;
  final List<Insufficiency>? activeInsuffiency;
  final List<Insufficiency>? passiveInsufficiency;
}

class Insufficiency {
  const Insufficiency(this.articulation, this.degrees);

  final Articulation articulation;
  final int degrees;
  // max stretch the tricep at shoulder during shoulder flexion and elbow flexion - arm bent overhead -> passive insufficiency
}
