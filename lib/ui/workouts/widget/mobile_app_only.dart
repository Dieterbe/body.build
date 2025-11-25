import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class MobileAppOnly extends StatelessWidget {
  const MobileAppOnly(this.title, {super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 460),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Animated icon container
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primary.withValues(alpha: 0.15),
                    colorScheme.primary.withValues(alpha: 0.05),
                  ],
                ),
                border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2), width: 2),
              ),
              child: Icon(Icons.phone_android, size: 80, color: colorScheme.primary),
            ),
            const SizedBox(height: 32),

            // Headline
            Text(
              'Mobile only',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Subheading
            Text(
              'This feature is designed for mobile use',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Description
            Text(
              'Download the Body.build app to track your workouts, body measurements and analyze your progress at the gym.',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.75),
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Store buttons
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildStoreButton(
                  context: context,
                  icon: Icons.android,
                  label: 'Get on Play Store',
                  onPressed: () {
                    launchUrl(
                      Uri.parse(
                        'https://play.google.com/store/apps/details?id=build.body.bodybuild',
                      ),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildStoreButton(
                  context: context,
                  icon: Icons.apple,
                  label: 'Get on App Store',
                  onPressed: () {
                    launchUrl(
                      Uri.parse('https://apps.apple.com/us/app/body-build/id6754889919'),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Go back button
            TextButton.icon(
              onPressed: () {
                context.pop();
              },
              icon: Icon(Icons.arrow_back, color: colorScheme.onSurface.withValues(alpha: 0.6)),
              label: Text(
                'Go back',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600, letterSpacing: 0.5),
      ),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
