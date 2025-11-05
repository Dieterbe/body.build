#!/bin/bash
# Get version string based on git tags
# if we match a tag -> v1.1.1
# if we don't match a tag -> v1.1.1-5-gabc1234
# if the working copy is dirty -> v1.1.1-5-gabc1234-dirty
# Note: in CI (codemagic) we don't include --dirty, because:
# 1) codemagic makes various changes to all kinds of ios/macos related files, "dirtying" the repo. and not sure if the exact changes will remain consistent over time (probably not)
# 2) if we gitignore even just the files known to be modified by codemagic today, gitignore only ignores 'new' files, and i suspect those files need to be in the repo in some shape
#    (therefore, gitignore doesn't apply to them)
# 3) locally we want --dirty as we can accidentally include dirty changes, but codemagic always builds from what's in git anyway
version=$(git describe --tags --match "v*" --dirty 2>/dev/null)

if [ -z "$version" ]; then
  # Fallback if no tags exist yet (note: doesn't suport -dirty suffix)
  # results in something like v0.0.0-abc1234
  local hash=$(git rev-parse --short HEAD)
  version="v0.0.0-${hash}"
fi

echo "$version"
