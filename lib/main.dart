import 'package:bodybuild/util/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bodybuild/ui/anatomy/page/articulation.dart';
import 'package:bodybuild/ui/anatomy/page/articulations.dart';
import 'package:bodybuild/ui/anatomy/colors.dart';
import 'package:bodybuild/ui/core/page/home.dart';
import 'package:bodybuild/ui/anatomy/page/muscle.dart';
import 'package:bodybuild/ui/anatomy/page/muscles.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:bodybuild/ui/programmer/page/programmer.dart';
import 'package:bodybuild/ui/mealplanner/page/mealplanner.dart';
import 'package:bodybuild/ui/exercises/page/exercises_screen.dart';
import 'package:bodybuild/ui/workouts/page/workouts_screen.dart';
import 'package:bodybuild/ui/workouts/page/workout_screen.dart';
import 'package:bodybuild/util/url.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bodybuild/service/setup_persistence_service.dart';
import 'package:bodybuild/service/program_persistence_service.dart';

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

  // Check for exercise migration before starting the app
  String? migrationError;
  try {
    await _checkExerciseMigration();
  } catch (e) {
    migrationError = e.toString();
  }

  // Note: making this key public is not an issue. it's write-only
  final config = PostHogConfig('phc_WC0LK9tiHgH0rMWV8KKYTUOnWJt9PRMny3Vw8dGG8bJ');
  config.debug = true;
  config.captureApplicationLifecycleEvents = true;
  config.host = 'https://eu.i.posthog.com';
  await Posthog().setup(config);
  usePathUrlStrategy();
  runApp(ProviderScope(child: MyApp(migrationError: migrationError)));
}

Future<void> _checkExerciseMigration() async {
  // This will throw if migration is needed, preventing the app from starting
  final prefs = await SharedPreferences.getInstance();
  final setupService = SetupPersistenceService(prefs);
  final setupError = await setupService.checkExerciseMigration();
  if (setupError != null) {
    throw Exception(setupError);
  }

  final programService = ProgramPersistenceService(prefs);
  final programError = await programService.checkExerciseMigration();
  if (programError != null) {
    throw Exception(programError);
  }
}

class MyApp extends StatelessWidget {
  final String? migrationError;

  const MyApp({super.key, this.migrationError});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // If there's a migration error, show error screen instead of normal app
    if (migrationError != null) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 24),
                  const Text(
                    'Migration Required',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      migrationError!,
                      style: const TextStyle(fontFamily: 'monospace'),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      title: 'Body.build: advanced workout planner for coaches and lifters',
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
            ],
          ),
        ],
        observers: [PosthogObserver()],
      ),
    );
  }
}
