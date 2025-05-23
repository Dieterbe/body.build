import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bodybuild/ui/anatomy/page/articulations.dart';
import 'package:bodybuild/ui/anatomy/page/muscles.dart';
import 'package:bodybuild/ui/programmer/page/programmer.dart';
import 'package:bodybuild/ui/core/markdown.dart';

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
Such that you can see the entire ROM (range of motion) of a movement and see how different muscles/heads/fibers activate,  
become stronger at specific points (or have a better moment arm), when they are fully stretched, and deactivate

The best example of my current progress would be the **shoulder flexion**.  
To see it, hit the "articulations" button, and then click on "shoulder flexion".

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
        title: const Text('Body.build: Home'),
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            markdown(markdownSource, context),
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
              child: Text('muscles',
                  style: Theme.of(context).textTheme.titleLarge),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                context.goNamed(ProgrammerScreen.routeName);
              },
              child: Text('programmer',
                  style: Theme.of(context).textTheme.titleLarge),
            ),
          ],
        )),
      ),
    );
  }
}
