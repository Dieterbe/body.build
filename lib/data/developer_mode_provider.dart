import 'package:flutter_riverpod/flutter_riverpod.dart';

// This value is set at app startup and cannot be changed during runtime
final developerModeProvider =
    Provider<bool>((ref) => const bool.fromEnvironment('DEV_MODE', defaultValue: false));
