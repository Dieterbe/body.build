import 'package:bodybuild/data/dataset/program_group.dart';
import 'package:bodybuild/ui/dataset/util_groups.dart';
import 'package:flutter/material.dart';

class RecruitmentBarChart extends StatelessWidget {
  const RecruitmentBarChart(this.recruitments, this.height, {super.key});
  final Map<ProgramGroup, double> recruitments;
  final double height;

  @override
  Widget build(BuildContext context) {
    // Find max volume for scaling
    final maxVolume = recruitments.values.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: ProgramGroup.values.asMap().entries.map((entry) {
          final index = entry.key;
          final pg = entry.value;
          final volume = recruitments[pg] ?? 0;
          final heightFraction = maxVolume > 0 ? volume / maxVolume : 0;

          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index < ProgramGroup.values.length - 1 ? 1 : 0),
              height: heightFraction * 40,
              decoration: BoxDecoration(
                color: volume > 0
                    ? bgColorForProgramGroup(pg).withValues(alpha: 0.7)
                    : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
              child: volume > 0
                  ? Tooltip(
                      message: '${pg.displayNameShort}: ${volume.toStringAsFixed(1)}',
                      child: const SizedBox.expand(),
                    )
                  : const SizedBox.expand(),
            ),
          );
        }).toList(),
      ),
    );
  }
}
