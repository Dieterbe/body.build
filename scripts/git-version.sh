#!/bin/bash

# Get the short hash
hash=$(git rev-parse --short HEAD)

# Get the branch name
branch=$(git rev-parse --abbrev-ref HEAD)

# Check if working copy is dirty
if [[ -n $(git status --porcelain) ]]; then
  dirty="-dirty"
else
  dirty=""
fi

echo "${branch}-${hash}${dirty}"
