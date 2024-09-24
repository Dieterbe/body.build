import 'package:flutter/material.dart';
import 'package:ptc/backend/articulations.dart';
import 'package:ptc/backend/movements.dart';
import 'package:ptc/ui/range_widget.dart';
import 'package:ptc/util.dart';

const double chartHeight = 100;

class ArticulationScreen extends StatelessWidget {
  static const routeName = 'articulation';
  final String id;
  const ArticulationScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final articulation = Articulation.values.firstWhere((a) => a.name == id);

    final moves =
        movements.where((m) => m.articulation == articulation).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Articulation: ${articulation.name.camelToTitle()}'),
      ),
      body: Column(
        children: [
          /*
          ...moves.map((m) => ListTile(
                title: Text(m.muscle.nameWithHead(m.head)),
                subtitle: Text(
                  '${m.rangeBegin} - ${m.rangeEnd}${m.momentMax != null ? ' (max moment @ ${m.momentMax})' : ''}',
                ),
              )),
              */
          RangeWidget(movements: moves)
        ],
      ),
    );
  }
}
