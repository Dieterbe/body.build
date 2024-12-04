import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_program_provider.g.dart';

@Riverpod()
class CurrentProgram extends _$CurrentProgram {
  static const defaultId = 'current';

  @override
  String build() {
    ref.onDispose(() {
      print('current program provider disposed');
    });
    return defaultId;
  }

  void select(String id) {
    state = id;
  }
}
