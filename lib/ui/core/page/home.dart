import 'package:bodybuild/data/core/developer_mode_provider.dart';
import 'package:bodybuild/data/core/youtube_provider.dart';
import 'package:bodybuild/data/workouts/workout_providers.dart';
import 'package:bodybuild/ui/anatomy/page/muscles.dart';
import 'package:bodybuild/ui/core/page/about_screen.dart';
import 'package:bodybuild/ui/core/widget/youtube_video_card.dart';
import 'package:bodybuild/ui/exercises/page/exercises_screen.dart';
import 'package:bodybuild/ui/measurements/widget/measurement_summary_card.dart';
import 'package:bodybuild/ui/programmer/page/programmer.dart';
import 'package:bodybuild/ui/workouts/page/workout_screen.dart';
import 'package:bodybuild/ui/workouts/page/workouts_screen.dart';
import 'package:bodybuild/ui/workouts/widget/start_workout_dialog.dart';
import 'package:bodybuild/util/flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:bodybuild/ui/core/widget/app_navigation_drawer.dart';

class HomeScreen extends ConsumerWidget {
  static const String routeName = 'home';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devMode = ref.watch(developerModeProvider);

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
        child: Column(
          children: [
            // Hero Section
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [colorScheme.primary.withValues(alpha: 0.1), Colors.transparent],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: isTabletOrDesktop(context) ? 40.0 : 24.0,
                ),
                child: Column(
                  children: [
                    // Logo Section
                    Container(
                      padding: EdgeInsets.all(isTabletOrDesktop(context) ? 20 : 16),
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
                                color: colorScheme.primary.withValues(alpha: 0.6),
                                width: 2,
                              ),
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: colorScheme.primary.withValues(alpha: 0.7),
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
                    SizedBox(height: isTabletOrDesktop(context) ? 20 : 16),
                    Text(
                      'Advanced workout application\nfor coaches and lifters (preview)',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.8),
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: isTabletOrDesktop(context) ? 12 : 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),

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
                          final tabletOrDesktop = isTabletOrDesktop(context);
                          final crossAxisCount = tabletOrDesktop ? 4 : 2;

                          return ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: tabletOrDesktop ? 800 : double.infinity,
                            ),
                            child: GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: tabletOrDesktop ? 1.1 : 1.4,
                              children: [
                                if (tabletOrDesktop)
                                  _buildQuickAccessCard(
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
                                  ),
                                _buildWorkoutCard(context, ref),
                                _buildQuickAccessCard(
                                  context: context,
                                  title: 'Workout history',
                                  subtitle: 'Track a workout session',
                                  icon: Icons.history,
                                  color: Colors.green,
                                  showAppOnly: !isMobileApp(),
                                  onTap: () => _navigateQuickAccess(
                                    context,
                                    WorkoutsScreen.routeName,
                                    false,
                                  ),
                                ),
                                _buildQuickAccessCard(
                                  context: context,
                                  title: 'Browse Exercises',
                                  subtitle: 'Explore exercise library',
                                  icon: Icons.fitness_center,
                                  color: colorScheme.primary,
                                  onTap: () => _navigateQuickAccess(
                                    context,
                                    ExercisesScreen.routeName,
                                    false,
                                  ),
                                ),
                                _buildQuickAccessCard(
                                  context: context,
                                  title: 'Muscle Anatomy',
                                  subtitle: 'Muscle recruitments (advanced)',
                                  icon: Icons.fitness_center,
                                  color: Colors.purple,
                                  onTap: () =>
                                      _navigateQuickAccess(context, MusclesScreen.routeName, false),
                                ),
                                _buildQuickAccessCard(
                                  context: context,
                                  title: 'Analysis',
                                  subtitle: 'View progress & stats',
                                  icon: Icons.analytics,
                                  color: Colors.orange,
                                  onTap: () => _navigateQuickAccess(context, 'analysis', true),
                                  showComingSoon: true,
                                ),
                                _buildQuickAccessCard(
                                  context: context,
                                  title: 'About',
                                  subtitle: 'About Body.build (preview)',
                                  icon: Icons.info,
                                  color: Colors.green,
                                  onTap: () =>
                                      _navigateQuickAccess(context, AboutScreen.routeName, false),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 32),

                      // Measurement Summary Card (mobile only)
                      if (isMobileApp() || devMode) ...[
                        const MeasurementSummaryCard(),
                        const SizedBox(height: 32),
                      ],

                      // YouTube Video Section
                      Text(
                        'YouTube videos',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Mobile App playlist
                      _buildYouTubePlaylistSection(ref, playlistMobileApp, 'Mobile App'),

                      const SizedBox(height: 24),

                      // Web App playlist
                      _buildYouTubePlaylistSection(ref, playlistWebApp, 'Web App'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool showComingSoon = false, // either coming soon or 'app only', not both
    bool showAppOnly = false, // either coming soon or 'app only', not both
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
                    child: Icon(icon, color: color, size: 28),
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
          if (showComingSoon || showAppOnly)
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
                  showAppOnly ? 'Use Mobile App' : 'Coming Soon',
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

  Widget _buildYouTubePlaylistSection(WidgetRef ref, String playlistId, String title) {
    final playlistAsync = ref.watch(youtubePlaylistProvider(playlistId));

    return playlistAsync.when(
      data: (videos) {
        if (videos.isEmpty) {
          // Fallback to empty state if playlist fails to load
          return const SizedBox.shrink();
        }

        return Builder(
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 12),
                child: Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 320,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    final video = videos[index];
                    return Padding(
                      padding: EdgeInsets.only(right: index < videos.length - 1 ? 16 : 0),
                      child: YoutubeVideoCard(
                        videoId: video.videoId,
                        title: video.title,
                        description: video.description,
                        thumbnailUrl: video.thumbnailUrl,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox(height: 320, child: Center(child: CircularProgressIndicator())),
      error: (error, stack) {
        // Graceful degradation - show nothing on error
        return const SizedBox.shrink();
      },
    );
  }

  void _navigateQuickAccess(BuildContext context, String routeName, bool wip) async {
    await Posthog().capture(eventName: 'QuickAccessClicked', properties: {'route': routeName});

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

  Widget _buildWorkoutCard(BuildContext context, WidgetRef ref) {
    final workoutStateAsync = ref.watch(workoutManagerProvider);

    Widget standard() {
      return _buildQuickAccessCard(
        context: context,
        title: 'Start Workout',
        subtitle: 'Track a workout session',
        icon: Icons.play_arrow,
        color: Colors.green,
        showAppOnly: !isMobileApp(),
        onTap: () {
          showStartWorkoutDialog(context);
        },
      );
    }

    Widget errorCard() {
      return _buildQuickAccessCard(
        context: context,
        title: 'Workout unavailable',
        subtitle: 'Something went wrong. Please try again.',
        icon: Icons.error_outline,
        color: Colors.red,
        showAppOnly: !isMobileApp(),
        onTap: () {},
      );
    }

    return workoutStateAsync.when(
      data: (state) {
        if (state.activeWorkout != null) {
          return _buildQuickAccessCard(
            context: context,
            title: 'Resume Workout',
            subtitle: 'Continue your current workout',
            icon: Icons.play_arrow,
            color: Colors.green,
            showAppOnly: !isMobileApp(),
            onTap: () {
              _navigateQuickAccess(context, WorkoutScreen.routeNameActive, false);
            },
          );
        }
        return standard();
      },
      loading: () => const SizedBox.shrink(),
      error: (error, stack) {
        if (kIsWeb) {
          return standard();
        }
        return errorCard();
      },
    );
  }
}
