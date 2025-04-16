import 'package:bodybuild/ui/const.dart';
import 'package:bodybuild/ui/core/markdown.dart';
import 'package:bodybuild/ui/programmer/page/programmer_small_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:bodybuild/ui/programmer/page/programmer_builder.dart';
import 'package:bodybuild/ui/programmer/page/programmer_setup.dart';
import 'package:bodybuild/ui/core/text_style.dart';
import 'package:bodybuild/ui/core/logo.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

const String helpProgrammer = '''
# What is this?

body.build is a web application for:
* building optimal weight lifting and body building plans.
* setting personalised kcal and workout volume targets.

Body.build is different from others in the sense that:
* it visualizes fractional volume counting (the most accurate way to count volume)
* it integrates social media content, instructional videos, ratings, and scientific studies etc from respected authors
* we do not have an app to actually track progress in the gym, but working on it!

The application is:
* completely free to use by anyone without any type of signup or data collection.
* a work-in-progress. things may change and break, while i keep working on it!

It is based on the latest scientific principles, as tought in the [Menno Henselmans Personal Training Course](https://mennohenselmans.com/online-pt-course/) - probably the most comprehensive evidence based personal training course program on the planet - from which I graduated magna cum laude in 2025.
I'm looking for your feedback.  Please reach out on the following email: info@body.build 

# How to use?

There are 2 main tabs: **workout programmer** and **set-up**

## On the first **workout programmer tab**.

Explore/modify the built-in demo program on create a new one.

A program defines one or more workouts. Each workout has one or more sets, and sets may be combined into combo sets.
You can add sets with the "add set" button, or any of the muscle-specific "⊕" buttons, these let you add exercises that recruit that muscle well.
You can also drag and drop sets to re-order them. Dragging a set onto another creates a combo set.

Not all muscles are included here (e.g. rhomboids, psoas, etc) for two reasons:
- some muscles are trained automatically along with others: e.g. the teres major 
contributes to shoulder extension, adduction and internal rotation along with the lats, so training lats also trains the teres major
- some muscles are a bit less relevant for body building, such as hip adductors.  Most body builders grow them sufficiently from hip extension already.


## Optional: personalisation on the **set up tab**.

Here you can personalise.

* Enter personal details, training & nutritional information.
* Then, facts and parameters will be generated for you.  Choose which BMR formula you prefer.
* Optionally, override parameters such as intensity, or muscle set volume.
* Fill in the equipment you have. there are shortcut buttons which help to select many pieces of equipment. (this is **important** as it affects which exercises will be available in the programmer)

You can create multiple profiles, and give them different names.

# Need more help?
* Tap the info buttons (ⓘ) next to parameters for detailed explanations
* Use the [documentation website](https://body.build/docs) for more information
* The [home page](https://body.build) has a quick overview of the most important features
* Reach out on info@body.build or [twitter/X @bodydotbuild](https://x.com/bodydotbuild)
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
              Text('alpha (preview) version',
                  style: TextStyle(fontWeight: FontWeight.w300)),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          FilledButton.icon(
            icon: const Icon(Icons.help_outline),
            label: const Text('Help'),
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
                        Flexible(
                          child: SingleChildScrollView(
                            child: markdown(helpProgrammer, context),
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
                    Icon(Icons.fitness_center,
                        size: MediaQuery.of(context).size.width / 70),
                    const SizedBox(width: 8),
                    const Text("Workout programmer"),
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
                    Icon(Icons.settings,
                        size: MediaQuery.of(context).size.width / 70),
                    const SizedBox(width: 8),
                    const Text("Set up"),
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
            child: Padding(
              padding:
                  EdgeInsets.only(left: 8, right: 28), // to fix header overflow
              child: ProgrammerBuilder(),
            ),
          ),
          SingleChildScrollView(
            child: ProgrammerSetup(),
          ),
          //  SingleChildScrollView(
          //   child: MealPlanScreen(),
          // ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    trackScreen('Example Screen dietertest');
  }
}

void trackScreen(String screenName) async {
  if (kIsWeb) {
    await Posthog().screen(
      screenName: screenName,
    );
  }
}

/*
volume distribution?
menno says: equal for all muscles
Jeff nippard says back quads glutes can handle more volume. https://youtu.be/ekQxEEjYLDI?si=KtMthjzxUAl4Md50 5:13
*/
