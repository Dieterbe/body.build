import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ptc/data/anatomy/muscles.dart';
import 'package:ptc/ui/anatomy/page/muscle.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/icon_park_outline.dart';
import 'package:ptc/util.dart';

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
    String varTitle = 'select a muscle category';

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
              itemCount: MuscleCategory.values
                  .where((a) =>
                      a.name.toLowerCase().contains(_filter.toLowerCase()))
                  .length,
              itemBuilder: (context, index) {
                final category = MuscleCategory.values
                    .where((a) =>
                        a.name.toLowerCase().contains(_filter.toLowerCase()))
                    .toList()[index];
                return ListTile(
                  title: Row(
                    children: [
                      const Iconify(IconParkOutline.muscle, size: 20),
                      Text(category.name.camelToTitle()),
                    ],
                  ),
                  onTap: () => context.pushNamed(
                    MuscleScreen.routeName,
                    pathParameters: {"id": category.name},
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
