import 'package:bodybuild/ui/const.dart';
import 'package:bodybuild/ui/programmer/page/programmer_small_screen.dart';
import 'package:flutter/material.dart';
import 'package:bodybuild/ui/programmer/page/programmer_builder.dart';
import 'package:bodybuild/ui/programmer/page/programmer_setup.dart';
import 'package:bodybuild/ui/core/text_style.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:bodybuild/ui/core/logo.dart';

const String helpProgrammer = '''
The Body.build web application helps creating optimized, science-backed diet and training plans.

There are 2 main steps: filling in the **set-up**, and **making the training program**.

## Complete the **set up tab**.
* Enter personal details, training & nutritional information.
* Then, facts and parameters will be generated for you.  Choose which BMR formula you prefer.
* Optionally, override parameters such as intensity, or muscle set volume.
* Fill in the equipment you have. there are shortcut buttons which help to select many pieces of equipment. (this is **important** as it affects which exercises will be available in the programmer)
* Optionally, exclude exercises and exercises types. These will be hidden in the UI. (this is not very important. you can also just skip this)

You can create multiple profiles, and give them different names.

## Then proceed to the **workout programmer tab**.

Here you define a program by defining one or more workouts. Each workout has one or more sets, and sets may be combined into combo sets.
You can add sets with the "add set" button, or any of the muscle-specific "⊕" buttons, these let you add exercises that recruit that muscle well.
You can also drag and drop sets to re-order them. Dragging a set onto another creates a combo set.

Not all muscles are included here (e.g. rhomboids, psoas, etc) for two reasons:
- some muscles are trained automatically along with others: e.g. the teres major 
contributos to shoulder extension, adduction and internal rotation along with the lats, so training lats also trains the teres major
- some muscles are a bit less relevant for body building, such as hip adductors.  Most body builders grow them sufficiently from hip extension already.

### Need more help?
Look for the info buttons (ⓘ) next to parameters for detailed explanations
''';

class ProgrammerScreen extends StatefulWidget {
  const ProgrammerScreen({super.key});

  static const routeName = 'programmer';

  @override
  State<ProgrammerScreen> createState() => _ProgrammerScreenState();
}

class _ProgrammerScreenState extends State<ProgrammerScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    if (screenWidth < minScreenWidth) {
      if (screenHeight >= minScreenWidth) {
        // in this case, ask user to rotate their screen. it'll be enough
        return const SmallScreen(
          icon: Icons.screen_rotation,
          title: 'Rotate screen',
          description:
              'This application requires a large screen in landscape mode (e.g. a desktop, desktop or tablet)',
          instructions:
              'Please rotate the screen or use another screen of at least 1000 pixels wide.',
        );
      }
      return const SmallScreen(
        icon: Icons.fit_screen,
        title: 'Screen Too Small',
        description:
            'This is an advanced application that requires a bigger screen (e.g. a laptop, desktop or tablet). It does not work on small screens such as smart phones',
        instructions:
            'Please use a device with a screen width of at least 1000 pixels.',
      );
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 72,
        title: const Padding(
          padding: EdgeInsets.symmetric(vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Logo(height: 60),
              Text('beta'),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Body.Build Help Guide', style: ts50(context)),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Flexible(
                          child: SingleChildScrollView(
                            child: MarkdownBody(data: helpProgrammer),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          dividerColor: Colors.transparent,
          indicator: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              width: 2,
            ),
          ),
          labelStyle: ts100(context).copyWith(fontWeight: FontWeight.w500),
          unselectedLabelStyle: ts100(context),
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor:
              Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.hovered)) {
                return Theme.of(context)
                    .colorScheme
                    .surface
                    .withValues(alpha: 0.1);
              }
              return null;
            },
          ),
          tabs: [
            Tab(
              height: 44,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.settings,
                        size: MediaQuery.of(context).size.width / 70),
                    const SizedBox(width: 8),
                    const Text("Set up"),
                  ],
                ),
              ),
            ),
            Tab(
              height: 44,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.fitness_center,
                        size: MediaQuery.of(context).size.width / 70),
                    const SizedBox(width: 8),
                    const Text("Workout programmer"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: const TabBarView(
        children: [
          SingleChildScrollView(
            child: ProgrammerSetup(),
          ),
          SingleChildScrollView(
            child: Padding(
              padding:
                  EdgeInsets.only(left: 8, right: 28), // to fix header overflow
              child: ProgrammerBuilder(),
            ),
          ),
          //  SingleChildScrollView(
          //   child: MealPlanScreen(),
          // ),
        ],
      ),
    );
  }
}

/*
volume distribution?
menno says: equal for all muscles
Jeff nippard says back quads glutes can handle more volume. https://youtu.be/ekQxEEjYLDI?si=KtMthjzxUAl4Md50 5:13
*/
