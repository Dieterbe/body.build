#!/bin/bash

# Common utilities for deployment scripts

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages with timestamps
error() {
    echo -e "${RED}$(date "+%F %T") ERROR: $1${NC}" >&2
    exit 1
}

success() {
    echo -e "${GREEN}$(date "+%F %T") ✓ $1${NC}"
}

warning() {
    echo -e "${YELLOW}$(date "+%F %T") ⚠ $1${NC}"
}

info() {
    echo "$(date "+%F %T") $1"
}

# Confirmation prompt (returns 0 if yes, 1 if no)
confirm() {
    local prompt="${1:-Proceed?}"
    read -p "$prompt (y/N) " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

# Git validation functions
check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        error "Not in a git repository"
    fi
}

check_git_clean() {
    local current_branch=$(git rev-parse --abbrev-ref HEAD)
    if [ "$current_branch" != "main" ]; then
        error "Must be on 'main' branch (currently on '$current_branch')"
    fi

    if [[ -n $(git status --porcelain) ]]; then
        error "Working directory has uncommitted changes or untracked files"
    fi
}

# Compare semantic versions (returns 0 if $1 > $2)
version_gt() {
    test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1"
}