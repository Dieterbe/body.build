import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bodybuild/data/anatomy/articulations.dart';
import 'package:bodybuild/ui/anatomy/page/articulation.dart';
import 'package:bodybuild/util.dart';

class ArticulationButton extends StatelessWidget {
  final Articulation articulation;
  final double size;
  final bool nav;
  const ArticulationButton(
    this.articulation, {
    this.size = 14,
    super.key,
    this.nav = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => nav
          ? context.pushNamed(
              ArticulationScreen.routeName,
              pathParameters: {"id": articulation.name.camelToSnake()},
            )
          : {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // const Iconify(IconParkOutline.muscle, size: 20),
          Text(articulation.name.camelToTitle(), style: TextStyle(fontSize: size)),
        ],
      ),
    );
  }
}
