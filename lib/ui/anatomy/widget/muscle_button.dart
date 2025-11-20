import 'package:bodybuild/util/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/icon_park_outline.dart';
import 'package:bodybuild/data/dataset/muscle.dart';
import 'package:bodybuild/ui/anatomy/page/muscle.dart';

class MuscleButton extends StatelessWidget {
  final Muscle muscle;
  final MuscleId? head;
  const MuscleButton({super.key, required this.muscle, this.head});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => context.pushNamed(
        MuscleScreen.routeName,
        pathParameters: {"id": muscle.categories.first.name.camelToSnake()},
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Iconify(IconParkOutline.muscle, size: 20),
          Text(muscle.nameWithHead(head)),
        ],
      ),
    );
  }
}
