#!/bin/bash
# Get version string based on git tags
# if we match a tag -> v1.1.1
# if we don't match a tag -> v1.1.1-5-gabc1234
# if the working copy is dirty -> v1.1.1-5-gabc1234-dirty
version=$(git describe --tags --match "v*" --dirty 2>/dev/null)

if [ -z "$version" ]; then
    # Fallback if no tags exist yet (note: doesn't suport -dirty suffix)
    # results in something like v0.0.0-abc1234
    local hash=$(git rev-parse --short HEAD)
    version="v0.0.0-${hash}"
fi

echo "$version"