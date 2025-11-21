import 'package:bodybuild/data/dataset/ex.dart';
import 'package:bodybuild/model/programmer/program_state.dart';
import 'package:bodybuild/model/programmer/set_group.dart';
import 'package:bodybuild/model/programmer/workout.dart';

// TODO: need good tracking, ex not found -> posthog error. tweak not found -> error, right now it's ignored
/*
* should we rewrite this as json (or yaml)?
* + loading of any program (saved by user, built-in-demos) would go through the same path, which is
    probably good (?). at least we'd have shared validation (but only at runtime)
* json would be a bit more compact, but also more cryptic
* future: potentially lower barrier to contribute.  for now, even with json/yaml you still need
  git, and we don't support any type of loading arbitrary programs yet.
* - now we have tab completion and dart analysis to assert correctness (to some degree),
    could be expanded in the future when we introduce e.g. enums for exercise ID's
*/
/*
IMPORTANT: WHEN CHANGING THIS PROGRAM CONSIDER: 
- templates in database won't be updated
- templates in shared preferences won't be updated
*/
const demo1ID = 'demo1';
Ex _ex(String id) => exes.firstWhere((e) => e.id == id);
final demo1 = ProgramState(
  name: 'Demo Program 1 - Full body',
  builtin: true,
  workouts: [
    Workout(
      name: 'day A',
      setGroups: [
        SetGroup([
          Sets(2, n: 2, ex: _ex('romanian deadlift')),
          Sets(2, n: 2, ex: _ex('seated leg extension machine'), tweakOptions: {'lean': 'back'}),
          Sets(2, n: 2, ex: _ex('chest supported machine row')),
          Sets(2, n: 2, ex: _ex('chest press machine')),
        ]),
        SetGroup([
          Sets(2, n: 2, ex: _ex('dumbbell overhead press')),
          Sets(
            2,
            n: 2,
            ex: _ex('dumbbell standing calf raise'),
            tweakOptions: {'ROM': 'full with lengthened partials beyond failure'},
          ),
          Sets(1, ex: _ex('dumbbell overhead tricep extension')),
          Sets(1, ex: _ex('lying dumbbell bicep curl')),
        ]),
      ],
      timesPerPeriod: 3,
      periodWeeks: 2,
    ),
    Workout(
      name: 'day B',
      setGroups: [
        SetGroup([
          Sets(
            2,
            n: 2,
            ex: _ex('barbell squat'),
            tweakOptions: {'bar': 'front', 'lower leg movement': 'back and forth'},
          ),
          Sets(2, n: 2, ex: _ex('seated cable row'), tweakOptions: {'spine': 'dynamic'}),
          Sets(2, n: 2, ex: _ex('barbell bench press'), tweakOptions: {'bench angle': '15'}),
        ]),
        SetGroup([
          Sets(
            2,
            n: 2,
            ex: _ex('seated leg curl machine'),
            tweakOptions: {'ankle dorsiflexed': 'yes'},
          ),
          Sets(2, n: 2, ex: _ex('standing cable lateral raise')),
          Sets(2, n: 2, ex: _ex('standing cable bicep curl'), tweakOptions: {'style': 'bayesian'}),
          Sets(2, n: 2, ex: _ex('cable overhead tricep extension')),
          Sets(1, ex: _ex('dumbbell wrist flexion')),
          Sets(1, ex: _ex('dumbbell wrist extension')),
        ]),
      ],
      timesPerPeriod: 3,
      periodWeeks: 2,
    ),
  ],
);
