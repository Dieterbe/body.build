import 'package:flutter/material.dart';
import 'package:ptc/ui/articulation_screen.dart';
import 'package:ptc/ui/articulations_screen.dart';
import 'package:ptc/ui/home_screen.dart';
import 'package:ptc/ui/muscle_screen.dart';
import 'package:ptc/ui/muscles_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'PTC Pro',
        darkTheme: ThemeData.dark(),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromARGB(255, 15, 209, 157)),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
        routes: {
          ArticulationsScreen.routeName: (ctx) => const ArticulationsScreen(),
          ArticulationScreen.routeName: (ctx) => const ArticulationScreen(),
          MusclesScreen.routeName: (ctx) => const MusclesScreen(),
          MuscleScreen.routeName: (ctx) => const MuscleScreen()
        });
  }
}
