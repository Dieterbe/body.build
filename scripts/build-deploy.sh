#!/bin/bash

function log() {
  echo "## $(date "+%F %T") $@"
}

function die_error() {
  log "$@"
  exit 2
}

[ -z "$1" ] || [ "$1" == "-f" ] || die_error "$0 [-f]"

version=$(./scripts/git-version.sh)

log "injecting version $version into sources..."
sed -i "s/^const version = 'git';/const version = '$version';/" lib/ui/const.dart
sed -i "s#</body>#</body><!-- version $version -->#" web/index.html

log "build web"
flutter build web

log "git add build/web, deploy and git push"
git add -f build/web && git commit -m 'build' && git push $1 origin HEAD

log "removing the $version strings again..."
sed -i "s#</body><!-- version $version -->#</body>#" web/index.html
sed -i "s/^const version = '$version';/const version = 'git';/" lib/ui/const.dart
