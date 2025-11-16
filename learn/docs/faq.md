---
sidebar_position: 3
---

# Frequently asked questions

## What does it mean that is open source?

All code for both the body.build application and exercise dataset are published [on GitHub](https://github.com/Dieterbe/body.build) as "open source" using the [AGPL-3 legal license](https://github.com/Dieterbe/body.build?tab=AGPL-3.0-1-ov-file#readme). This means that:

1) Anyone is permitted to use the code (or parts thereof) to make their own app and release it under a different name.  There are no constraints on this other then that you also need to publish your derived source code under the same license.
2) Anyone is welcome to make contributions to the app.  Making good code changes requires some expertise, and may not be merged (integrated) however, if it isn't deemed good enough.

Get in touch if you are interested in any of these.

## Can I add my own exercises (for my own use)?

Exercises in body.build have additional data about muscle activations (for precise volume counting and analysis), skeletal movements (for working around injuries and discomfort, WIP) and tweaks which affect all of these. Integrating an exercise in the overall system (e.g. to generate workout programs accurately) cannot easily be done by an end user and requires therefore a certain level of expertise.
We prefer to "do it right": integrate an exercise well (via the code), and do it for all users.
Feel free to let us know which exercises you want us to add either on [GitHub](https://github.com/Dieterbe/body.build) or any of the other communication channels.

## Why do the volume calculations not match those of other programs?

There could be a few reasons for this:

* Many apps and programs only consider "direct" volume - exercises with a given muscle as its main target (e.g. biceps during bicep curls), and ignore indirect volume (e.g. biceps during chin-ups)
  In line with research demonstrating that both types of volume "count", body.build considers both (though care must be taken to have a well balanced program), and therefore both the target volumes and achieved volumes are higher.
* The calculations for optimal volume consider many factors, such as sex (females can handle more volume), sleep quality, energy balance (cutting vs bulking), etc.  They have been demonstrated successfully on hundreds of (highly motivated) under the guidance of good coaches, but consider them as a starting point.  People who don't want to push themselves too hard can certainly reduce the volume and still get great outcomes.
