import 'package:bodybuild/ui/core/widget/app_navigation_drawer.dart';
import 'package:bodybuild/ui/workouts/widget/mobile_app_only.dart';
import 'package:flutter/material.dart';

class MobileAppOnlyScaffold extends StatelessWidget {
  const MobileAppOnlyScaffold({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Theme.of(context).colorScheme.surface),
      drawer: const AppNavigationDrawer(),
      body: Center(
        child: Padding(padding: const EdgeInsets.all(24.0), child: MobileAppOnly(title)),
      ),
    );
  }
}
