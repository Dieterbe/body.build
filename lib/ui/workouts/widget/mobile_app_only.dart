import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class MobileAppOnly extends StatelessWidget {
  const MobileAppOnly(this.title, {super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
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
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    launchUrl(
                      Uri.parse(
                        'https://play.google.com/store/apps/details?id=build.body.bodybuild',
                      ),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  icon: const Icon(Icons.android),
                  label: const Text('Get on Play Store'),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    launchUrl(
                      Uri.parse('https://apps.apple.com/us/app/body-build/id6754889919'),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  icon: const Icon(Icons.phone_iphone),
                  label: const Text('Get on App Store'),
                ),
              ],
            ),
            OutlinedButton.icon(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go back'),
            ),
          ],
        ),
      ),
    );
  }
}
