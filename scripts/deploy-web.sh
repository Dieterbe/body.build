#!/bin/bash

set -e  # Exit on error

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

[ -z "$1" ] || [ "$1" == "-f" ] || error "Usage: $0 [-f]"

check_git_repo
check_git_clean

app_version=$($SCRIPT_DIR/version.sh)
app_build_time=$(date)

info "build web"
flutter build web --base-href '/app/' -o build/web/app --dart-define=APP_VERSION="$app_version" --dart-define=APP_BUILD_TIME="$app_build_time"

info "injecting version $app_version ($app_build_time) into build/web/app/index.html"
sed -i "s/^buildVersion unknown/buildVersion $app_version/" build/web/app/index.html
sed -i "s/^buildTime unknown/buildTime $app_build_time/" build/web/app/index.html

info "copying landing page"
cp -ax landing-page/* build/web/
info "build docs"
(cd docs && npm run build)
rsync -a docs/build/ build/web/docs/

info "git add build/web, deploy and git push"
git add -f build/web && git commit -m 'build' && git push $1 origin HEAD