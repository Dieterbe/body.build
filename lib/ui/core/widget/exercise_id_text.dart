import 'package:bodybuild/data/dataset/ex.dart';
import 'package:flutter/material.dart';

/// Displays an exercise ID with optional search aliases shown in a muted style.
/// The aliases are shown inline after the ID when there is enough space.
class ExerciseIdText extends StatelessWidget {
  final Ex exercise;
  final TextStyle? idStyle;
  final TextStyle? aliasStyle;
  final bool showAliases;

  const ExerciseIdText({
    super.key,
    required this.exercise,
    this.idStyle,
    this.aliasStyle,
    this.showAliases = true,
  });

  @override
  Widget build(BuildContext context) {
    final aliases = exercise.searchAliasesDisplay;
    if (!showAliases || aliases == null) {
      return Text(exercise.id, style: idStyle);
    }

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: exercise.id, style: idStyle),
          TextSpan(
            text: '  $aliases',
            style:
                aliasStyle ??
                TextStyle(
                  fontSize: (idStyle?.fontSize ?? 14) * 0.75,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}
