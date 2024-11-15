import 'package:ptc/model/programmer/set_group.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'program.g.dart';

class ProgramState {
  final List<SetGroup> setGroups;
  ProgramState({this.setGroups = const []});

  copyWith({List<SetGroup>? setGroups}) =>
      ProgramState(setGroups: setGroups ?? this.setGroups);
}

@riverpod
class Program extends _$Program {
  @override
  ProgramState build() => ProgramState();

  void add(SetGroup set) =>
      state = state.copyWith(setGroups: [...state.setGroups, set]);

  void updateSetGroup(SetGroup s, SetGroup Function(SetGroup) update) {
    state = state.copyWith(
        setGroups: state.setGroups.map((sg) {
      return (sg == s) ? update(sg) : sg;
    }).toList());
  }
}
