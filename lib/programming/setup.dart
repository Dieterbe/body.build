import 'package:ptc/programming/exercises.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'setup.g.dart';

enum Level {
  beginner,
  intermediate,
  advanced,
  elite,
}

class Settings {
  Level level = Level.beginner;
  List<Equipment> selectedEquipment = [];
}

@riverpod
class Setup extends _$Setup {
  @override
  Settings build() => Settings();

  void setLevel(Level level) => state.level = level;

  void addEquipment(Equipment equipment) =>
      state.selectedEquipment.add(equipment);

  void removeEquipment(Equipment equipment) =>
      state.selectedEquipment.remove(equipment);
}
