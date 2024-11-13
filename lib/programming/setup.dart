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

  Settings copyWith({Level? level, List<Equipment>? selectedEquipment}) {
    return Settings()
      ..level = level ?? this.level
      ..selectedEquipment = selectedEquipment ?? this.selectedEquipment;
  }
}

@riverpod
class Setup extends _$Setup {
  @override
  Settings build() {
    ref.onDispose(() {
      print('disposed');
    });
    return Settings();
  }

  void setLevel(Level level) => state = state.copyWith(level: level);

  void addEquipment(Equipment equipment) => state = state.copyWith(
        selectedEquipment: [...state.selectedEquipment, equipment],
      );

  void removeEquipment(Equipment equipment) => state = state.copyWith(
        selectedEquipment:
            state.selectedEquipment.where((e) => e != equipment).toList(),
      );
}
