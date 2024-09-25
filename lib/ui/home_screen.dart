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

Dieter wrote this app to summarize the information from the PTC anatomy module and make it more practical.
You can look up:
* muscle's common functions and other details (e.g. insufficiency)
* joint articulations & involved muscles.

What I would really like to do is make this more visual.  
Such that you can see the entire ROM (range of motion) of a movement and see how different muscles activate,  
become stronger at specific points (or have a better moment arm), when they are fully stretched, and deactivate

Have a look at the **shoulder flexion** articulation to get a preview

### DISCLAIMER:
* use any information here at your own risk
* the **information is incomplete**, i need to add more data.
* the app is a work in progress and might crash or not work at all
* some of the information included is based on interpretations, or from other sources beyond just the PTC module
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
          const SizedBox(height: 32),
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
