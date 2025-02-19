#!/bin/bash

function die_error() {
  echo "$@"
  exit 2
}

[ -z "$1" ] || [ "$1" == "-f" ] || die_error "$0 [-f]"

version=$(./scripts/git-version.sh)

echo "## injecting version $version into sources..."
sed -i "s/^const version = 'git';/const version = '$version';/" lib/ui/const.dart
sed -i "s#</body>#</body><!-- version $version -->#" web/index.html

echo "## build web..."
flutter build web

echo "## git add build/web, deploy and git push..."
git add -f build/web && git commit -m 'build' && git push $1 origin HEAD

echo "## removing the $version strings again..."
sed -i "s#</body><!-- version $version -->#</body>#" web/index.html
sed -i "s/^const version = '$version';/const version = 'git';/" lib/ui/const.dart
