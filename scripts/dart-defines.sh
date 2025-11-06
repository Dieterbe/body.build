#!/bin/bash

# Note: in CI (codemagic) we don't include --dirty, because:
# 1) codemagic makes various changes to all kinds of ios/macos related files, "dirtying" the repo.
#    and not sure if the exact changes will remain consistent over time (probably not)
# 2) if we gitignore even just the files known to be modified by codemagic today, gitignore only ignores 'new' files,
#    and i suspect those files need to be in the repo in some shape (therefore, gitignore doesn't apply to them)
# 3) locally we want to mark the '-dirty' suffix as we can accidentally include dirty changes,
#    but codemagic always builds from what's in git anyway

version=$(./scripts/version.sh)
if [ "$1" == "ci" ]; then
  version=${version%-dirty}
fi

cat >.vscode/dart-defines.json <<EOF
{"APP_VERSION":"$version","APP_BUILD_TIME":"$(date)"}
EOF
