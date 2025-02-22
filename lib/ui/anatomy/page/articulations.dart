import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bodybuild/data/anatomy/articulations.dart';
import 'package:bodybuild/model/anatomy/movements.dart';
import 'package:bodybuild/ui/anatomy/page/articulation.dart';
import 'package:bodybuild/util.dart';

class ArticulationsScreen extends StatefulWidget {
  static const routeName = 'articulations';

  const ArticulationsScreen({super.key});

  @override
  State<ArticulationsScreen> createState() => _ArticulationsScreenState();
}

class _ArticulationsScreenState extends State<ArticulationsScreen> {
  String _filter = '';
  @override
  Widget build(BuildContext context) {
    String varTitle = 'select an articulation';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Body.build - $varTitle'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'filter',
              ),
              onChanged: (value) {
                setState(() {
                  _filter = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: Articulation.values
                  .where((a) =>
                      a.name.toLowerCase().contains(_filter.toLowerCase()))
                  .length,
              itemBuilder: (context, index) {
                final articulation = Articulation.values
                    .where((a) =>
                        a.name.toLowerCase().contains(_filter.toLowerCase()))
                    .toList()[index];
                return ListTile(
                  title: Text(articulation.name.camelToTitle()),
                  subtitle: Text(
                      '${ArticulationMovements(articulation).moves.length} known muscle/head movements'),
                  onTap: () => context.pushNamed(
                    ArticulationScreen.routeName,
                    pathParameters: {"id": articulation.name},
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
