typedef Cues = Map<String, (bool, String)>;

const defaultCues = {
  "full ROM": (true, 'full range of motion for all reps'),
  "lengthened partials": (false, 'only the long muscle length half of the ROM'),
};

const standingCalfRaiseCues = {
  ...defaultCues,
  ...{
    'after failure -> lengthened partial reps': (
      false,
      "go until you can't move the weight. should stimulate more gastroc growth. [jeff nippard video](https://www.youtube.com/shorts/baEXLy09Ncc)"
    ),
    // he also says point toes out -> more inner growth, and vice versa, that's more of a potential future recruitment finetuning
    'alternate toes in and toes out between sets': (
      false,
      "might stimulate more growth [jeff nippard video](https://www.youtube.com/shorts/baEXLy09Ncc)"
    ),
  }
};

const legExtensionCues = {
  ...defaultCues,
  ...{
    'pull on handles': (
      false,
      'pull on the handles to maybe get more tension on the quads'
    ),
  }
};
