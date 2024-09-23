/*
import 'package:ptc/articulations.dart';
import 'package:ptc/movements.dart';
import 'package:ptc/muscles.dart';
class Exercise {
  final String name;
  final List<String> nick;
  final List<Articulation> performedArticulations;

  Exercise({required this.name, required this.nick, required this.performedArticulations});

  (List<Muscle>, List<Head>) getMusclesUsed() {
    // ugh this needs to support heads *and* muscles, and would miss so much nuance.
    // abandoning this. see readme
    return performedArticulations.map((p) => movements.where((m) => m.articulation == p).map((m) => m.muscle)).toList();
    
  }
}

List<Exercise> exercises = [
  Exercise(
    name: 'supinated pull-down',
    nick: ['Chin up pull-down'],
    performedArticulations: [
      Articulation.elbowFlexion,
      Articulation.shoulderExtension,
    ],
  ),
*/