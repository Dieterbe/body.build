#!/bin/bash
version=$(./scripts/git-version.sh)

echo "## injecting version $version into sources..."
sed -i "s#Text('beta', // managed via script#Text('beta $version', // managed via script#" lib/ui/programmer/page/programmer.dart
sed -i "s#</body>#</body><!-- $version -->#" web/index.html

echo "## build web..."
flutter build web

echo "## git add build/web, deploy and git push..."
git add -f build/web && git commit -m 'build' && git push origin HEAD

echo "## removing the $version strings again..."
sed -i "s#</body><!-- $version -->#</body>#" web/index.html
sed -i "s#Text('beta.*// managed via script#Text('beta', // managed via script#" lib/ui/programmer/page/programmer.dart
