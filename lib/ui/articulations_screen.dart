import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ptc/backend/articulations.dart';
import 'package:ptc/backend/movements.dart';
import 'package:ptc/ui/articulation_screen.dart';
import 'package:ptc/util.dart';

class ArticulationsScreen extends StatefulWidget {
  static const routeName = 'articulations';

  const ArticulationsScreen({super.key});

  @override
  _ArticulationsScreenState createState() => _ArticulationsScreenState();
}

class _ArticulationsScreenState extends State<ArticulationsScreen> {
  String _filter = '';
  @override
  Widget build(BuildContext context) {
    String varTitle = 'select an articulation';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('PTC Pro - $varTitle'),
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
                      '${movements.where((m) => m.articulation == articulation).length} known muscle/head movements'),
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
