#!/bin/bash

# shows where we import code that is not part of the current feature, or core or dataset or util (which anyone may import freely)
features=(exercises settings programmer anatomy workouts backup measurements mealplan core dataset)
for f in "${features[@]}"; do
  echo "## feature $f"
  grep -R "import 'package:bodybuild" $(find . -type d -name "$f") \
   | grep -vE "import 'package:bodybuild/util/[^/]+\\.dart';" \
   | grep -vE "import.*($f|core|dataset)" \
   | sort
done
