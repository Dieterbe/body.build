import 'package:bodybuild/ui/const.dart';
import 'package:flutter/material.dart';

class VersionWidget extends StatelessWidget {
  const VersionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text("version $version");
  }
}
