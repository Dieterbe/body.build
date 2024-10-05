import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ptc/backend/muscles.dart';
import 'package:ptc/ui/muscle_screen.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/icon_park_outline.dart';

class MusclesScreen extends StatefulWidget {
  static const routeName = 'muscles';

  const MusclesScreen({super.key});

  @override
  State<MusclesScreen> createState() => _MusclesScreenState();
}

class _MusclesScreenState extends State<MusclesScreen> {
  String _filter = '';
  @override
  Widget build(BuildContext context) {
    String varTitle = 'select a muscle';

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
              itemCount: Muscle.values
                  .where((a) =>
                      a.name.toLowerCase().contains(_filter.toLowerCase()))
                  .length,
              itemBuilder: (context, index) {
                final muscle = Muscle.values
                    .where((a) =>
                        a.name.toLowerCase().contains(_filter.toLowerCase()))
                    .toList()[index];
                return ListTile(
                  title: Row(
                    children: [
                      const Iconify(IconParkOutline.muscle, size: 20),
                      Text(muscle.name.camelToTitle()),
                    ],
                  ),
                  subtitle: Text(
                      '${muscle.movements.length + muscle.heads.values.fold<int>(
                            0,
                            (prev, h) => prev + h.movements.length,
                          )} known movements.'),
                  onTap: () => context.pushNamed(
                    MuscleScreen.routeName,
                    pathParameters: {"id": muscle.name},
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
