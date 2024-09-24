import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:ptc/ui/articulations_screen.dart';
import 'package:ptc/ui/muscles_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'home';
  const HomeScreen({super.key});

  static const String markdownSource = '''
# PTC Pro

Dieter wrote this app to conveniently look up:
* articulations, which muscles they involve, and to which extent
* common functions of muscles and other details (e.g. insufficiency)

essentially, it aims to be a practical summary of the respective course module,


DISCLAIMER:
* use any information here at your own risk
* the information here, and its representation, is a work in progress
* the app is in beta and might crash or not work at all
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PTC Pro: Home'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const MarkdownBody(data: markdownSource),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              context.goNamed(ArticulationsScreen.routeName);
            },
            child: Text('articulations',
                style: Theme.of(context).textTheme.titleLarge),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              context.goNamed(MusclesScreen.routeName);
            },
            child:
                Text('muscles', style: Theme.of(context).textTheme.titleLarge),
          )
        ],
      )),
    );
  }
}
