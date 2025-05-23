import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bodybuild/ui/anatomy/page/articulation.dart';
import 'package:bodybuild/ui/anatomy/page/articulations.dart';
import 'package:bodybuild/ui/anatomy/colors.dart';
import 'package:bodybuild/ui/core/page/home.dart';
import 'package:bodybuild/ui/anatomy/page/muscle.dart';
import 'package:bodybuild/ui/anatomy/page/muscles.dart';
import 'package:go_router/go_router.dart';
import 'package:bodybuild/ui/programmer/page/programmer.dart';
import 'package:bodybuild/ui/mealplanner/page/mealplanner.dart';
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
  final config =
      PostHogConfig('phc_WC0LK9tiHgH0rMWV8KKYTUOnWJt9PRMny3Vw8dGG8bJ');
  config.debug = true;
  config.captureApplicationLifecycleEvents = true;
  config.host = 'https://eu.i.posthog.com';
  if (kIsWeb) {
    await Posthog().setup(config);
  }
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      themeMode: ThemeMode.dark,
      title: 'Body.build: advanced workout planner for coaches and lifters',
      //     darkTheme: ThemeData.dark(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: colorSeed),
        useMaterial3: true,
      ),
      routerConfig: GoRouter(
        initialLocation: '/${ProgrammerScreen.routeName}',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeScreen(),
            routes: [
              GoRoute(
                name: ArticulationsScreen.routeName,
                path: ArticulationsScreen.routeName,
                builder: (context, state) => const ArticulationsScreen(),
              ),
              GoRoute(
                name: ArticulationScreen.routeName,
                path: '${ArticulationScreen.routeName}/:id',
                builder: (context, state) => ArticulationScreen(
                  id: state.pathParameters['id']!,
                ),
              ),
              GoRoute(
                name: MusclesScreen.routeName,
                path: MusclesScreen.routeName,
                builder: (context, state) => const MusclesScreen(),
              ),
              GoRoute(
                name: MuscleScreen.routeName,
                path: '${MuscleScreen.routeName}/:id',
                builder: (context, state) => MuscleScreen(
                  id: state.pathParameters['id']!,
                ),
              ),
              GoRoute(
                name: ProgrammerScreen.routeName,
                path: ProgrammerScreen.routeName,
                builder: (context, state) => const DefaultTabController(
                    length: 2, child: ProgrammerScreen()),
              ),
              GoRoute(
                name: MealPlanScreen.routeName,
                path: MealPlanScreen.routeName,
                builder: (context, state) => const MealPlanScreen(),
              )
            ],
          ),
        ],
      ),
    );
  }
}
