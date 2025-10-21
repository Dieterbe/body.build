import 'package:bodybuild/util/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bodybuild/ui/anatomy/page/articulation.dart';
import 'package:bodybuild/ui/anatomy/page/articulations.dart';
import 'package:bodybuild/ui/anatomy/colors.dart';
import 'package:bodybuild/ui/core/page/home.dart';
import 'package:bodybuild/ui/core/page/about_screen.dart';
import 'package:bodybuild/ui/core/page/privacy_policy_screen.dart';
import 'package:bodybuild/ui/anatomy/page/muscle.dart';
import 'package:bodybuild/ui/anatomy/page/muscles.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:bodybuild/ui/programmer/page/programmer.dart';
import 'package:bodybuild/ui/mealplanner/page/mealplanner.dart';
import 'package:bodybuild/ui/exercises/page/exercises_screen.dart';
import 'package:bodybuild/ui/workouts/page/workouts_screen.dart';
import 'package:bodybuild/ui/workouts/page/workout_screen.dart';
import 'package:bodybuild/ui/measurements/page/measurements_screen.dart';
import 'package:bodybuild/ui/settings/page/settings_screen.dart';
import 'package:bodybuild/util/url.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

void main() async {
  // disabled for now. not all that useful actually..
  // WidgetsFlutterBinding.ensureInitialized();
  //  loadKaos();

  // *without* this flag, behavior is like so:
  // go -> uses proper URL, but overrides 'back' stack, goes straight back to home
  // push -> uses stack, keeps back working, but not proper URL
  // with this flag, we get proper URL's and proper stack
  // this was noticebale e.g. on /muscles when trying to navigate to /muscles/biceps
  GoRouter.optionURLReflectsImperativeAPIs = true;

  WidgetsFlutterBinding.ensureInitialized();
  // Note: making this key public is not an issue. it's write-only
  final config = PostHogConfig('phc_WC0LK9tiHgH0rMWV8KKYTUOnWJt9PRMny3Vw8dGG8bJ');
  config.debug = true;
  config.captureApplicationLifecycleEvents = true;
  config.host = 'https://eu.i.posthog.com';
  await Posthog().setup(config);
  usePathUrlStrategy();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      title: 'Body.build: advanced workout application for coaches and lifters',
      //     darkTheme: ThemeData.dark(),
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: colorSeed), useMaterial3: true),
      routerConfig: GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
            routes: [
              GoRoute(
                name: ArticulationsScreen.routeName,
                path: ArticulationsScreen.routeName,
                builder: (context, state) => const ArticulationsScreen(),
                routes: [
                  GoRoute(
                    name: ArticulationScreen.routeName,
                    path: '/:id',
                    builder: (context, state) =>
                        ArticulationScreen(id: state.pathParameters['id']!.snakeToCamel()),
                  ),
                ],
              ),
              GoRoute(
                name: MusclesScreen.routeName,
                path: MusclesScreen.routeName,
                builder: (context, state) => const MusclesScreen(),
                routes: [
                  GoRoute(
                    name: MuscleScreen.routeName,
                    path: '/:id',
                    builder: (context, state) =>
                        MuscleScreen(id: state.pathParameters['id']!.snakeToCamel()),
                  ),
                ],
              ),
              GoRoute(
                name: ProgrammerScreen.routeName,
                path: ProgrammerScreen.routeName,
                builder: (context, state) =>
                    const DefaultTabController(length: 2, child: ProgrammerScreen()),
              ),
              GoRoute(
                name: MealPlanScreen.routeName,
                path: MealPlanScreen.routeName,
                builder: (context, state) => const MealPlanScreen(),
              ),
              GoRoute(
                name: ExercisesScreen.routeName,
                path: ExercisesScreen.routeName,
                builder: (context, state) => const ExercisesScreen(),
                routes: [
                  GoRoute(
                    path: '/:id',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;

                      // TODO validation of id and tweaks
                      return ExercisesScreen(
                        exerciseId: parseExerciseId(id),
                        tweakOptions: parseExerciseParams(state.uri.queryParameters),
                      );
                    },
                  ),
                ],
              ),
              GoRoute(
                name: WorkoutScreen.routeNameActive,
                path: WorkoutScreen.routeNameActive,
                builder: (context, state) => const WorkoutScreen(),
              ),
              GoRoute(
                name: WorkoutsScreen.routeName,
                path: WorkoutsScreen.routeName,
                builder: (context, state) => const WorkoutsScreen(),
                routes: [
                  GoRoute(
                    path: '/:id',
                    builder: (context, state) =>
                        WorkoutScreen(workoutId: state.pathParameters['id']!),
                  ),
                ],
              ),
              GoRoute(
                name: MeasurementsScreen.routeName,
                path: MeasurementsScreen.routeName,
                builder: (context, state) => const MeasurementsScreen(),
              ),
              GoRoute(
                name: SettingsScreen.routeName,
                path: SettingsScreen.routeName,
                builder: (context, state) => const SettingsScreen(),
              ),
              GoRoute(
                name: AboutScreen.routeName,
                path: AboutScreen.routeName,
                builder: (context, state) => const AboutScreen(),
              ),
              GoRoute(
                name: PrivacyPolicyScreen.routeName,
                path: PrivacyPolicyScreen.routeName,
                builder: (context, state) => const PrivacyPolicyScreen(),
              ),
            ],
          ),
        ],
        observers: [PosthogObserver()],
      ),
    );
  }
}
