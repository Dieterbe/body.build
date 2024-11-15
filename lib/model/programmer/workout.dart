import 'package:ptc/model/programmer/set_group.dart';

class Workout {
  final String name;
  final List<SetGroup> setGroups;

  Workout({this.name = 'unnamed workout', this.setGroups = const []});

  Workout copyWith({String? name, List<SetGroup>? setGroups}) {
    return Workout(
      name: name ?? this.name,
      setGroups: setGroups ?? this.setGroups,
    );
  }
}
