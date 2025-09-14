import 'package:bodybuild/ui/core/text_style.dart';
import 'package:flutter/material.dart';

class TrainingEETable extends StatelessWidget {
  final double gross;
  final double displaced;
  final double epoc;
  final double net;
  const TrainingEETable(this.gross, this.displaced, this.epoc, this.net, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(12),
          1: FlexColumnWidth(12),
          2: FlexColumnWidth(60),
        },
        border: TableBorder(
          horizontalInside: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            ),
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                alignment: Alignment.center,
                child: Text('Type',
                    style: ts100(context).copyWith(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                alignment: Alignment.center,
                child: Text('kcal',
                    style: ts100(context).copyWith(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                alignment: Alignment.center,
                child: Text('Information',
                    style: ts100(context).copyWith(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
              ),
            ],
          ),
          TableRow(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text('Gross',
                    style: ts100(context).copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                    textAlign: TextAlign.left),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                alignment: Alignment.center,
                child: Text(
                  gross.round().toString(),
                  style: ts100(context),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(
                    'Calories expended during resistance training, including your normal BMR. Assumes sufficiently high intensiveness. Derived from body weight and session duration.',
                    style: ts100(context).copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                    textAlign: TextAlign.left),
              ),
            ],
          ),
          TableRow(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text('Displaced BMR',
                    style: ts100(context).copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                    textAlign: TextAlign.left),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                alignment: Alignment.center,
                child: Text(
                  '- ${displaced.round()}',
                  style: ts100(context),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(
                    'The Energy Expenditure that would normally have occured as part of your normal BMR and daily physical activity, which has now been replaced by weight lifting.',
                    style: ts100(context).copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                    textAlign: TextAlign.left),
              ),
            ],
          ),
          TableRow(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text('EPOC',
                    style: ts100(context).copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                    textAlign: TextAlign.left),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                alignment: Alignment.center,
                child: Text(
                  ' + ${epoc.round()}',
                  style: ts100(context),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(
                    'Temporary additional metabolic Energy Expenditure after the weight lifting session has ended.',
                    style: ts100(context).copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                    textAlign: TextAlign.left),
              ),
            ],
          ),
          TableRow(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text('Net',
                    style: ts100(context).copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                    textAlign: TextAlign.left),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                alignment: Alignment.center,
                child: Text(
                  '= ${net.round()}',
                  style: ts100(context),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(
                    'Net incremental Energy Expenditure due to the weight lifting, in comparison to a resting day which only has your typical physical activity.',
                    style: ts100(context).copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                    textAlign: TextAlign.left),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
