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
    final logicalHeight = MediaQuery.sizeOf(context).height;
    // my pixel 6 has logical height 914 and the menu would need to scroll if not for compact mode
    // note that mobile apps show a lot more content
    final bool isCompact = logicalHeight < 1000 && isMobileApp();

    return Drawer(
      child: Column(
        children: [
          // Header
          Container(
            height: isCompact ? 130 : 140,
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
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  isCompact ? 10 : 12,
                ), // 16 to match ListTiles below
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Advanced workout app (preview)',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.9),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
                  isCompact: isCompact,
                ),
                _buildNavigationItem(
                  context: context,
                  icon: Icons.help_outline,
                  title: 'Help & Docs',
                  currentRoute: currentRoute,
                  onTap: () {
                    Navigator.of(context).pop();
                    _openUrl('https://body.build/docs/');
                  },
                  isCompact: isCompact,
                ),
                _buildNavigationItem(
                  context: context,
                  icon: Icons.mail_outline,
                  title: 'Feedback',
                  currentRoute: currentRoute,
                  onTap: () {
                    Navigator.of(context).pop();
                    _openUrl('mailto:info@body.build?subject=Feedback%20on%20Body.build');
                  },
                  isCompact: isCompact,
                ),
                const Divider(height: 1),
                _buildSectionHeader(context, 'Training', isCompact: isCompact),
                if (isMobileApp())
                  _buildNavigationItem(
                    context: context,
                    icon: Icons.play_arrow,
                    title: 'Start/Resume Workout',
                    routeName: WorkoutScreen.routeNameActive,
                    currentRoute: currentRoute,
                    onTap: () => _navigateAndClose(context, WorkoutScreen.routeNameActive),
                    isCompact: isCompact,
                  ),
                if (isMobileApp())
                  _buildNavigationItem(
                    context: context,
                    icon: Icons.history,
                    title: 'Workout History',
                    routeName: WorkoutsScreen.routeName,
                    currentRoute: currentRoute,
                    onTap: () => _navigateAndClose(context, WorkoutsScreen.routeName),
                    isCompact: isCompact,
                  ),
                if (isTabletOrDesktop(context))
                  _buildNavigationItem(
                    context: context,
                    icon: Icons.schedule,
                    title: 'Workout Programmer',
                    routeName: ProgrammerScreen.routeName,
                    currentRoute: currentRoute,
                    onTap: () => _navigateAndClose(context, ProgrammerScreen.routeName),
                    isCompact: isCompact,
                  ),
                _buildNavigationItem(
                  context: context,
                  icon: Icons.fitness_center,
                  title: 'Exercise Browser',
                  routeName: ExercisesScreen.routeName,
                  currentRoute: currentRoute,
                  onTap: () => _navigateAndClose(context, ExercisesScreen.routeName),
                  isCompact: isCompact,
                ),
                if (isMobileApp()) ...[
                  const Divider(height: 1),
                  _buildSectionHeader(context, 'Measurements', isCompact: isCompact),
                  _buildNavigationItem(
                    context: context,
                    icon: Icons.monitor_weight,
                    title: 'Weight Tracking',
                    routeName: MeasurementsScreen.routeName,
                    currentRoute: currentRoute,
                    onTap: () => _navigateAndClose(context, MeasurementsScreen.routeName),
                    isCompact: isCompact,
                  ),
                ],
                const Divider(height: 1),
                _buildSectionHeader(context, 'Anatomy', isCompact: isCompact),
                _buildNavigationItem(
                  context: context,
                  icon: Icons.accessibility_sharp,
                  title: 'Muscles',
                  routeName: MusclesScreen.routeName,
                  currentRoute: currentRoute,
                  onTap: () => _navigateAndClose(context, MusclesScreen.routeName),
                  isCompact: isCompact,
                ),
                _buildNavigationItem(
                  context: context,
                  icon: Icons.settings_accessibility,
                  title: 'Articulations',
                  routeName: ArticulationsScreen.routeName,
                  currentRoute: currentRoute,
                  onTap: () => _navigateAndClose(context, ArticulationsScreen.routeName),
                  isCompact: isCompact,
                ),
                if (isMobileApp()) ...[
                  const Divider(height: 1),
                  _buildSectionHeader(context, 'Settings', isCompact: isCompact),
                  _buildNavigationItem(
                    context: context,
                    icon: Icons.settings,
                    title: 'App Settings',
                    routeName: SettingsScreen.routeName,
                    currentRoute: currentRoute,
                    onTap: () => _navigateAndClose(context, SettingsScreen.routeName),
                    isCompact: isCompact,
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
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: isCompact ? 12 : 24),
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

  Widget _buildSectionHeader(BuildContext context, String title, {bool isCompact = false}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, isCompact ? 14 : 16, 16, isCompact ? 6 : 8),
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
    String? routeName,
    required String currentRoute,
    required VoidCallback onTap,
    bool isCompact = false,
  }) {
    final isSelected =
        routeName != null &&
        (currentRoute == '/$routeName' ||
            (routeName == HomeScreen.routeName && currentRoute == '/'));

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
      visualDensity: isCompact ? const VisualDensity(vertical: -1) : VisualDensity.standard,
      minTileHeight: isCompact ? 44 : null,
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
