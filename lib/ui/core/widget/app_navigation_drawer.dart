import 'package:bodybuild/ui/measurements/page/measurements_screen.dart';
import 'package:bodybuild/ui/settings/page/settings_screen.dart';
import 'package:bodybuild/ui/workouts/page/workout_screen.dart';
import 'package:bodybuild/util/flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bodybuild/ui/anatomy/page/articulations.dart';
import 'package:bodybuild/ui/anatomy/page/muscles.dart';
import 'package:bodybuild/ui/programmer/page/programmer.dart';
import 'package:bodybuild/ui/exercises/page/exercises_screen.dart';
import 'package:bodybuild/ui/workouts/page/workouts_screen.dart';
import 'package:bodybuild/ui/core/page/home.dart';
import 'package:bodybuild/ui/core/page/about_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class AppNavigationDrawer extends StatelessWidget {
  const AppNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.path;

    return Drawer(
      child: Column(
        children: [
          // Header
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16), // match the listTiles below
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Body.build',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Advanced workout app (preview)',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Navigation Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildNavigationItem(
                  context: context,
                  icon: Icons.home,
                  title: 'Home',
                  routeName: HomeScreen.routeName,
                  currentRoute: currentRoute,
                  onTap: () => _navigateAndClose(context, HomeScreen.routeName),
                ),
                ListTile(
                  leading: Icon(Icons.help_outline, color: Theme.of(context).colorScheme.primary),
                  title: const Text('Help & Docs'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _openUrl('https://body.build/docs/');
                  },
                ),
                const Divider(height: 1),
                _buildSectionHeader(context, 'Training'),
                if (isMobileApp())
                  _buildNavigationItem(
                    context: context,
                    icon: Icons.play_arrow,
                    title: 'Start/Resume Workout',
                    routeName: WorkoutScreen.routeNameActive,
                    currentRoute: currentRoute,
                    onTap: () => _navigateAndClose(context, WorkoutScreen.routeNameActive),
                  ),
                if (isMobileApp())
                  _buildNavigationItem(
                    context: context,
                    icon: Icons.history,
                    title: 'Workout History',
                    routeName: WorkoutsScreen.routeName,
                    currentRoute: currentRoute,
                    onTap: () => _navigateAndClose(context, WorkoutsScreen.routeName),
                  ),
                if (isTabletOrDesktop(context))
                  _buildNavigationItem(
                    context: context,
                    icon: Icons.schedule,
                    title: 'Workout Programmer',
                    routeName: ProgrammerScreen.routeName,
                    currentRoute: currentRoute,
                    onTap: () => _navigateAndClose(context, ProgrammerScreen.routeName),
                  ),
                _buildNavigationItem(
                  context: context,
                  icon: Icons.fitness_center,
                  title: 'Exercise Browser',
                  routeName: ExercisesScreen.routeName,
                  currentRoute: currentRoute,
                  onTap: () => _navigateAndClose(context, ExercisesScreen.routeName),
                ),
                if (isMobileApp()) ...[
                  const Divider(height: 1),
                  _buildSectionHeader(context, 'Measurements'),
                  _buildNavigationItem(
                    context: context,
                    icon: Icons.monitor_weight,
                    title: 'Weight Tracking',
                    routeName: MeasurementsScreen.routeName,
                    currentRoute: currentRoute,
                    onTap: () => _navigateAndClose(context, MeasurementsScreen.routeName),
                  ),
                ],
                const Divider(height: 1),
                _buildSectionHeader(context, 'Anatomy'),
                _buildNavigationItem(
                  context: context,
                  icon: Icons.accessibility_sharp,
                  title: 'Muscles',
                  routeName: MusclesScreen.routeName,
                  currentRoute: currentRoute,
                  onTap: () => _navigateAndClose(context, MusclesScreen.routeName),
                ),
                _buildNavigationItem(
                  context: context,
                  icon: Icons.settings_accessibility,
                  title: 'Articulations',
                  routeName: ArticulationsScreen.routeName,
                  currentRoute: currentRoute,
                  onTap: () => _navigateAndClose(context, ArticulationsScreen.routeName),
                ),
                if (isMobileApp()) ...[
                  const Divider(height: 1),
                  _buildSectionHeader(context, 'Settings'),
                  _buildNavigationItem(
                    context: context,
                    icon: Icons.settings,
                    title: 'App Settings',
                    routeName: SettingsScreen.routeName,
                    currentRoute: currentRoute,
                    onTap: () => _navigateAndClose(context, SettingsScreen.routeName),
                  ),
                ],
                /*  const Divider(height: 1),
                _buildSectionHeader(context, 'Nutrition'),
                _buildNavigationItem(
                  context: context,
                  icon: Icons.restaurant_menu,
                  title: 'Meal Planner',
                  routeName: MealPlanScreen.routeName,
                  currentRoute: currentRoute,
                  onTap: () =>
                      _navigateAndClose(context, MealPlanScreen.routeName),
                ),
                */
              ],
            ),
          ),

          // Footer
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.3)),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Footer links
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => _navigateAndClose(context, AboutScreen.routeName),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 14,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'About',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '•',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => _navigateAndClose(context, 'privacy'),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.privacy_tip_outlined,
                              size: 14,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Privacy',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildNavigationItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String routeName,
    required String currentRoute,
    required VoidCallback onTap,
  }) {
    final isSelected =
        currentRoute.contains('/$routeName') ||
        (routeName == HomeScreen.routeName && currentRoute == '/');

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
      onTap: onTap,
    );
  }

  void _navigateAndClose(BuildContext context, String routeName) {
    Navigator.of(context).pop(); // Close drawer
    if (routeName == HomeScreen.routeName) {
      context.go('/');
    } else {
      context.goNamed(routeName);
    }
  }

  void _openUrl(String url) async {
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
