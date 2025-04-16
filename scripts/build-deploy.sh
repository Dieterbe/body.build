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
timestamp=$(git log -1 --format=%cd)

log "injecting version $version ($timestamp) into sources..."
sed -i "s/^const buildVersion = 'unknown';/const buildVersion = '$version';/" lib/ui/const.dart
sed -i "s/^const buildTime = 'unknown';/const buildTime = '$timestamp';/" lib/ui/const.dart
sed -i "s/^buildVersion unknown/buildVersion $version/" web/index.html
sed -i "s/^buildTime unknown/buildTime $timestamp/" web/index.html

log "build web"
flutter build web --base-href '/app/' -o build/web/app
log "copying landing page"
cp -ax landing-page/* build/web/
log "build docs"
cd docs
npm run build
cd -
rsync -a docs/build/ build/web/docs/

log "git add build/web, deploy and git push"
git add -f build/web && git commit -m 'build' && git push $1 origin HEAD

log "removing the $version ($timestamp) strings again..."
sed -i "s/^const buildVersion = '$version';/const buildVersion = 'unknown';/" lib/ui/const.dart
sed -i "s/^const buildTime = '$timestamp';/const buildTime = 'unknown';/" lib/ui/const.dart
sed -i "s/^buildVersion $version/buildVersion unknown/" web/index.html
sed -i "s/^buildTime $timestamp/buildTime unknown/" web/index.html
