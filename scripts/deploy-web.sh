#!/bin/bash

set -e  # Exit on error

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

[ -z "$1" ] || [ "$1" == "-f" ] || error "Usage: $0 [-f]"

check_git_repo
check_git_clean

version=$(get_git_version)

timestamp=$(git log -1 --format=%cd)

info "injecting version $version ($timestamp) into sources..."
sed -i "s/^const buildVersion = 'unknown';/const buildVersion = '$version';/" lib/ui/const.dart
sed -i "s/^const buildTime = 'unknown';/const buildTime = '$timestamp';/" lib/ui/const.dart
sed -i "s/^buildVersion unknown/buildVersion $version/" web/index.html
sed -i "s/^buildTime unknown/buildTime $timestamp/" web/index.html

info "build web"
flutter build web --base-href '/app/' -o build/web/app
info "copying landing page"
cp -ax landing-page/* build/web/
info "build docs"
(cd docs && npm run build)
rsync -a docs/build/ build/web/docs/

info "git add build/web, deploy and git push"
git add -f build/web && git commit -m 'build' && git push $1 origin HEAD

info "removing the $version ($timestamp) strings again..."
sed -i "s/^const buildVersion = '$version';/const buildVersion = 'unknown';/" lib/ui/const.dart
sed -i "s/^const buildTime = '$timestamp';/const buildTime = 'unknown';/" lib/ui/const.dart
sed -i "s/^buildVersion $version/buildVersion unknown/" web/index.html
sed -i "s/^buildTime $timestamp/buildTime unknown/" web/index.html
