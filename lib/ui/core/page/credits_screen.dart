import 'package:bodybuild/ui/const.dart';
import 'package:flutter/material.dart';
import 'package:bodybuild/ui/core/widget/app_navigation_drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

class CreditsScreen extends StatelessWidget {
  static const String routeName = 'credits';
  const CreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Credits & Licenses'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      drawer: const AppNavigationDrawer(),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Logo Attribution
                  Text(
                    'App Logo',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 0,
                    color: colorScheme.surfaceContainerHighest,
                    child: InkWell(
                      onTap: () => _openUrl(
                        'https://www.freepik.com/free-vector/dumbbell-circle-illustration_418322977.htm',
                      ),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(Icons.image, color: colorScheme.primary, size: 28),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Dumbbell Icon',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Designed by Freepik',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.open_in_new,
                              color: colorScheme.onSurface.withValues(alpha: 0.5),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Open Source Licenses
                  Text(
                    'Open Source Licenses',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'This application uses the following open source packages:',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.8),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 0,
                    color: colorScheme.surfaceContainerHighest,
                    child: InkWell(
                      onTap: () => _showLicensePage(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(Icons.description, color: colorScheme.primary, size: 28),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'View All Licenses',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Complete list of dependencies and their licenses',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: colorScheme.onSurface.withValues(alpha: 0.5),
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Key Dependencies
                  Text(
                    'Key Dependencies',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDependencyItem(context, 'Flutter', 'UI framework'),
                  _buildDependencyItem(context, 'Riverpod', 'State management'),
                  _buildDependencyItem(context, 'Drift', 'Database'),
                  _buildDependencyItem(context, 'FL Chart', 'Charts and graphs'),
                  _buildDependencyItem(context, 'Go Router', 'Navigation'),
                  _buildDependencyItem(context, 'Freezed', 'Immutable models'),
                  _buildDependencyItem(context, 'Flutter Markdown', 'Markdown rendering'),
                  _buildDependencyItem(context, 'Flutter SVG', 'SVG support'),
                  _buildDependencyItem(context, 'URL Launcher', 'External links'),
                  _buildDependencyItem(context, 'PostHog', 'Analytics'),
                  _buildDependencyItem(context, 'Shared Preferences', 'Local storage'),
                  _buildDependencyItem(context, 'ML Linalg', 'Linear algebra'),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDependencyItem(BuildContext context, String name, String description) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 16,
            color: colorScheme.primary.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.8),
                ),
                children: [
                  TextSpan(
                    text: name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: ' - $description',
                    style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLicensePage(BuildContext context) async {
    await Posthog().capture(eventName: 'CreditsLicensePageViewed');
    if (context.mounted) {
      showLicensePage(
        context: context,
        applicationName: 'Body.build',
        applicationVersion: appVersion,
        applicationLegalese: '© ${DateTime.now().year} Body.build',
      );
    }
  }

  void _openUrl(String url) async {
    await Posthog().capture(eventName: 'CreditsLinkClicked', properties: {'url': url});

    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication, webOnlyWindowName: '_blank');
    } catch (e) {
      try {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      } catch (e) {
        await launchUrl(uri, mode: LaunchMode.inAppWebView);
      }
    }
  }
}
