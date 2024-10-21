import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ptc/anatomy/articulations.dart';
import 'package:ptc/ui/articulation_screen.dart';
import 'package:ptc/util.dart';

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
              pathParameters: {"id": articulation.name},
            )
          : {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // const Iconify(IconParkOutline.muscle, size: 20),
          Text(articulation.name.camelToTitle(),
              style: TextStyle(fontSize: size)),
        ],
      ),
    );
  }
}
