import 'package:bodybuild/ui/core/widget/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MobileAppOnly extends StatelessWidget {
  const MobileAppOnly({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Theme.of(context).colorScheme.surface),
      drawer: const AppNavigationDrawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.phone_android, size: 96, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 24),
              Text(
                'Mobile Only',
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'This feature is designed for mobile use. '
                'Please use the Body.build mobile app on your phone or tablet to use this functionality.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () => context.go('/'),
                icon: const Icon(Icons.home),
                label: const Text('Go to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
