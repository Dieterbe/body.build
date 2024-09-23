import 'package:flutter/material.dart';
import 'package:ptc/articulations.dart';
import 'package:ptc/movements.dart';
import 'package:ptc/util.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PTC Pro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'PTC Pro'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Articulation? articulation;
  String _filter = '';
  @override
  Widget build(BuildContext context) {
    String varTitle = 'select an articulation';
    if (articulation != null) {
      varTitle = articulation!.name;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              articulation = null;
            });
            // Navigator.pop(context);
          },
        ),
        title: Text('${widget.title} - $varTitle'),
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
          articulation == null
              ? Expanded(
                  child: ListView.builder(
                    itemCount: Articulation.values
                        .where((a) => a.name
                            .toLowerCase()
                            .contains(_filter.toLowerCase()))
                        .length,
                    itemBuilder: (context, index) {
                      final articulation = Articulation.values
                          .where((a) => a.name
                              .toLowerCase()
                              .contains(_filter.toLowerCase()))
                          .toList()[index];
                      return ListTile(
                        title: Text(articulation.name.camelToTitle()),
                        subtitle: Text(
                            '${movements.where((m) => m.articulation == articulation).length} known muscle/head movements'),
                        onTap: () {
                          setState(() {
                            this.articulation = articulation;
                          });
                        },
                      );
                    },
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: movements
                        .where((m) => m.articulation == articulation)
                        .toList()
                        .length,
                    itemBuilder: (context, index) {
                      final movement = movements
                          .where((m) => m.articulation == articulation)
                          .toList()[index];
                      return ListTile(
                        title: Text(movement.muscle.name.camelToTitle() +
                            (movement.head != null
                                ? ' (${movement.head!} head)'
                                : '')),
                        subtitle: Text(
                          '${movement.rangeBegin} - ${movement.rangeEnd}${movement.momentMax != null ? ' (max moment @ ${movement.momentMax})' : ''}',
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
