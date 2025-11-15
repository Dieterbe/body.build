---
sidebar_position: 2
---

# Workout Programmer

Get started with the body.build workout programmer in just a few minutes. This guide will walk you through the essential steps to create your first training program.  The feature has been updated a bit since this was written, but it should look mostly the same.

## Workout Programmer video


<div style={{textAlign: 'center', margin: '2rem 0'}}>
  <iframe
    width="100%"
    height="400"
    style={{maxWidth: '700px'}}
    src="https://www.youtube.com/embed/wOVZdZ9_jdE"
    title="Body.build Introduction Video"
    frameBorder="0"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
    allowFullScreen
  ></iframe>
</div>

## Step 1: Access the App

1. Visit [body.build/app](https://body.build/app)
2. Note: The workout programmer is currently desktop-only for the best experience

## Step 2: Programs

Use the left hand navigation menu to go to the **Workout Programmer** tab:

It should look something like this:

![Workout programmer](/img/workout-programmer.png)

### Program selector

In the program selector, you can either create a new program, or explore the built-in demo.
(you can also use it to change the name, delete or duplicate programs)

### Workout editor

* A workout view appears for each workout defined in the program.  It contains sets and combo sets (supersets) of exercises.  Note the grid with green markers which highlight how much a given exercise recruits the listed muscle groups. You can drag and drop sets to re-order them. Drop a set onto another to create a combo set.
* The intensity selector (% of 1RM) is a bit crude.  This mechanism will be refined in the future.  For now you could ignore it.
* Use the pencil icon and star rating icon (if available) to see the different tweaks for all exercises and their effect on ratings.  Often there are tweaks related to grip width, lean angle, posture etc, which change the recruitment values of exercises and which may be rated differently.  The ratings are compiled from social media content from creators such as Jeff Nippard, Menno Henselmans and Dr. Mike Israetel.
* the workout analysis at the bottom shows:
   - the amount of sets that target X different muscle groups.  Typically, you want many sets targetting many muscles at the same time (compound) exercises, to save time.  Isolation exercises often don't target muscles "better" but sometimes they are necessary complements (see program analysis below). Note that recruitments of less than 0.5 are not counted. This means biceps are counted as 0.5 volume for rows (and 1 for pull-ups and bicep curls) whereas hamstrings are not counted in squats, because they are only marginally involved.
   - the amount of volume (sets) for each muscle group

![Workout programmer program analysis](/img/workout-programmer-program-analysis.png)

### Program analysis

After all the workouts within the program, there is a program analysis which shows the same analysis, but this time for all workouts in the program, per week.  Note how changing the "x per y weeks" values for a workout affect your weekly volume.

There is also a "program breakdown" section which looks at how well each muscle is stimulated (across different muscle lengths and movement patterns), but this is a work in progress.

### Adding sets

![Adding sets](/img/workout-programmer-add-set.png)

To add a set, either add the generic 'Add Exercise' button, or use the muscle specific button if you need to add volume for a specific muscle.
The amount of muscle recruitment is shown for each exercise, as well as its star-rating, which is compiled from social media content from creators such as Jeff Nippard, Menno Henselmans and Dr. Mike Israetel.
Different forms of exercises are shown if those forms are known to result in different recruitment or different ratings.

## Step 3: Personalisation (optional)

Navigate to the **Set up** tab. It should look like this:

![Set up tab](/img/workout-programmer-setup.png)

### Profile selector
The profile selector is similar to the program selector from the programmer tab. Use it to create, edit, delete, duplicate profiles.
  **Tip**: regularly duplicate your last profile and update it to reflect your current status (e.g. monthly and at important milestones)*

### Personal information and derived goals

1. Enter your personal information.  Make sure to consult the '(i)' buttons to get clarity on the meaning of every item.  Be honest with yourself.  Don't exagerate your trainee level, physical activity level or your normalized workout duration.
2. You'll see your calculated BMI and calorie targets on the right.
3. Calculated parameters will appear on the right.
  * recommended intensities are mainly based on your trainee level (this is a bit crude and will be refined in the future). These will be the intensities that you can select in the workout programmer.  You can override them (e.g. put '60,70,80' in the text field to make those options available)
  * recommended volume takes into account your gender, your sleep/recovery, energy balance (deficit vs surplus) and more. You can also override this volume for all your muscle groups; or on the right, you can add exceptions for specific muscle groups.  These will serve as guidelines in the workout programmer.

### Equipment filters
 On the bottom you can declare which equipment you have available.  This will be used to filter exercises in the workout programmer.  Note the presets which will help with quickly toggling and untoggling many options at once.
