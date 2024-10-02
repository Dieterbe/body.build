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
    final am = ArticulationMovements(articulation);
    return Scaffold(
      appBar: AppBar(
        title: Text('Articulation: ${articulation.name.camelToTitle()}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: am.moves.isNotEmpty
                    ? RangeWidget(am)
                    : const Text(
                        'no moves for this articulation. // TODO: display insufficiencies'))
          ],
        ),
      ),
    );
  }
}
