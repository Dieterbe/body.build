import 'package:bodybuild/ui/anatomy/page/muscles.dart';
import 'package:bodybuild/ui/exercises/page/exercises_screen.dart';
import 'package:bodybuild/ui/programmer/page/programmer.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bodybuild/ui/core/widget/navigation_drawer.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'home';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Body.build'),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        drawer: const AppNavigationDrawer(),
        body: SingleChildScrollView(
          child: Column(children: [
            // Hero Section
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colorScheme.primary.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    // Logo Section
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.shadow.withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'BODY',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.primary,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    colorScheme.primary.withValues(alpha: 0.6),
                                width: 2,
                              ),
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: colorScheme.primary
                                      .withValues(alpha: 0.7),
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'BUILD',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w300,
                              color: colorScheme.onSurface,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Advanced workout planner\nfor coaches and lifters',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.8),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Free • No ads • No signup',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Getting Started',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Use the top-left hamburger menu to navigate to all sections of the app",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                          height: 1.4,
                        ),
                      ),
                      Text(
                        'Quick Access',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Quick Access Cards Grid
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final screenWidth = MediaQuery.of(context).size.width;
                          final isTabletOrDesktop = screenWidth > 768;
                          final crossAxisCount = isTabletOrDesktop ? 4 : 2;

                          return ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth:
                                  isTabletOrDesktop ? 800 : double.infinity,
                            ),
                            child: GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: isTabletOrDesktop ? 1.1 : 1.4,
                              children: [
                                _buildQuickAccessCard(
                                  context: context,
                                  title: 'Browse Exercises',
                                  subtitle: 'Explore exercise library',
                                  icon: Icons.fitness_center,
                                  color: colorScheme.primary,
                                  onTap: () => _navigateQuickAccess(context,
                                      ExercisesScreen.routeName, false),
                                ),
                                _buildQuickAccessCard(
                                  context: context,
                                  title: 'Muscle Anatomy',
                                  subtitle: 'Muscle recruitments (advanced)',
                                  icon: Icons.fitness_center,
                                  color: Colors.purple,
                                  onTap: () => _navigateQuickAccess(
                                      context, MusclesScreen.routeName, false),
                                ),
                                isTabletOrDesktop
                                    ? _buildQuickAccessCard(
                                        context: context,
                                        title: 'Workout Programmer',
                                        subtitle: 'Build training programs',
                                        icon: Icons.build,
                                        color: Colors.green,
                                        onTap: () => _navigateQuickAccess(
                                          context,
                                          ProgrammerScreen.routeName,
                                          false,
                                        ),
                                      )
                                    : _buildQuickAccessCard(
                                        context: context,
                                        title: 'Start Workout',
                                        subtitle: 'Begin training session',
                                        icon: Icons.play_arrow,
                                        color: Colors.green,
                                        onTap: () => _navigateQuickAccess(
                                          context,
                                          'start_workout',
                                          true,
                                        ),
                                        showComingSoon: true,
                                      ),
                                _buildQuickAccessCard(
                                  context: context,
                                  title: 'Analysis',
                                  subtitle: 'View progress & stats',
                                  icon: Icons.analytics,
                                  color: Colors.orange,
                                  onTap: () => _navigateQuickAccess(
                                      context, 'analysis', true),
                                  showComingSoon: true,
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 32),

                      // YouTube Video Section

                      Text(
                        'Help',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Constrain YouTube video width on larger screens
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: _buildYouTubeVideoCard(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ));
  }

  Widget _buildQuickAccessCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool showComingSoon = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Stack(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 2),
                  Expanded(
                    child: Center(
                      child: Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Coming Soon Banner
          if (showComingSoon)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'Coming Soon',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildYouTubeVideoCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    const videoId = 'wOVZdZ9_jdE'; // Extract video ID from URL
    const thumbnailUrl =
        'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _openYouTubeVideo(),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video thumbnail with actual YouTube thumbnail
            Container(
              height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // YouTube thumbnail image
                    Image.network(
                      thumbnailUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                colorScheme.primary.withValues(alpha: 0.8),
                                colorScheme.primary.withValues(alpha: 0.6),
                              ],
                            ),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback to gradient background if thumbnail fails to load
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                colorScheme.primary.withValues(alpha: 0.8),
                                colorScheme.primary.withValues(alpha: 0.6),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    // Dark overlay for better contrast
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.3),
                          ],
                        ),
                      ),
                    ),
                    // Play button overlay
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                    // YouTube logo in corner
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'YouTube',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Workout Programmer Introduction Video',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Learn how to use the Body.build web application to create effective workout programs.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.play_circle_outline,
                        color: colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Watch Introduction',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateQuickAccess(
      BuildContext context, String routeName, bool wip) async {
    if (kIsWeb) {
      await Posthog().capture(
        eventName: 'QuickAccessClicked',
        properties: {
          'route': routeName,
        },
      );
    }
    if (context.mounted) {
      if (wip) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$routeName feature coming soon!'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        context.goNamed(routeName);
      }
    }
  }

  void _openYouTubeVideo() async {
    const youtubeUrl = 'https://www.youtube.com/watch?v=wOVZdZ9_jdE';

    if (kIsWeb) {
      await Posthog().capture(
        eventName: 'YouTubeVideoClicked',
        properties: {
          'source': 'home_screen',
          'video_url': youtubeUrl,
        },
      );
    }

    final uri = Uri.parse(youtubeUrl);
    try {
      // Try to launch with external application mode first
      // this seems to work well on web, but not android, which shows
      // component name for https://www.youtube.com/watch?v=wOVZdZ9_jdE is null"
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: '_blank',
      );
    } catch (e) {
      // Fallback: try with platform default mode
      try {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      } catch (e) {
        // Final fallback: try with in-app web view
        await launchUrl(uri, mode: LaunchMode.inAppWebView);
      }
    }
  }
}
