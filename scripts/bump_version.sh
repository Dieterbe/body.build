#!/bin/bash

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
error() {
    echo -e "${RED}ERROR: $1${NC}" >&2
    exit 1
}

success() {
    echo -e "${GREEN}✓ $1${NC}"
}

warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

info() {
    echo -e "$1"
}

# Check if version argument is provided
if [ -z "$1" ]; then
    error "Usage: $0 <version>\nExample: $0 1.0.3"
fi

NEW_VERSION="$1"

# Validate version format (semver: X.Y.Z)
if ! [[ "$NEW_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    error "Invalid version format. Expected format: X.Y.Z (e.g., 1.0.3)"
fi

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    error "Not in a git repository"
fi

# Check if we're on the main branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$CURRENT_BRANCH" != "main" ]; then
    error "Must be on 'main' branch (currently on '$CURRENT_BRANCH')"
fi

# Check if working directory is clean
if [[ -n $(git status --porcelain) ]]; then
    error "Working directory has uncommitted changes or untracked files"
fi

PUBSPEC_FILE="pubspec.yaml"

# Check if pubspec.yaml exists
if [ ! -f "$PUBSPEC_FILE" ]; then
    error "pubspec.yaml not found in current directory"
fi

# Get current version from pubspec.yaml
CURRENT_VERSION=$(grep '^version:' "$PUBSPEC_FILE" | sed 's/version: *\([0-9.]*\)+.*/\1/')
CURRENT_BUILD=$(grep '^version:' "$PUBSPEC_FILE" | sed 's/version: *[0-9.]*+\([0-9]*\)/\1/')

if [ -z "$CURRENT_VERSION" ]; then
    error "Could not parse current version from pubspec.yaml"
fi

info "Current version: $CURRENT_VERSION+$CURRENT_BUILD"
info "New version: $NEW_VERSION"

# Function to compare semantic versions
version_gt() {
    test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1"
}

# Check if new version is greater than current version
if ! version_gt "$NEW_VERSION" "$CURRENT_VERSION"; then
    error "New version ($NEW_VERSION) must be greater than current version ($CURRENT_VERSION)"
fi

# Check if tag already exists locally
TAG_NAME="v$NEW_VERSION"
if git rev-parse "$TAG_NAME" >/dev/null 2>&1; then
    error "Tag $TAG_NAME already exists locally"
fi

# Check if tag exists on remote
if git ls-remote --tags origin | grep -q "refs/tags/$TAG_NAME$"; then
    error "Tag $TAG_NAME already exists on remote"
fi

# Get all existing tags and check against them
EXISTING_TAGS=$(git tag -l 'v*' | sed 's/^v//' | sort -V)
for existing_tag in $EXISTING_TAGS; do
    if [ "$existing_tag" = "$NEW_VERSION" ]; then
        error "Version $NEW_VERSION already exists as a tag"
    fi
    if ! version_gt "$NEW_VERSION" "$existing_tag"; then
        error "New version ($NEW_VERSION) must be greater than existing tag v$existing_tag"
    fi
done

# Increment build number
NEW_BUILD=$((CURRENT_BUILD + 1))

info ""
info "Changes to be made:"
info "  - Update version in pubspec.yaml: $CURRENT_VERSION+$CURRENT_BUILD → $NEW_VERSION+$NEW_BUILD"
info "  - Create git tag: $TAG_NAME"
info "  - Push tag to origin"
info ""

read -p "Proceed? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    info "Aborted"
    exit 0
fi

# Update pubspec.yaml
info ""
info "Updating pubspec.yaml..."
sed -i "s/^version: .*$/version: $NEW_VERSION+$NEW_BUILD/" "$PUBSPEC_FILE"
success "Updated pubspec.yaml to version $NEW_VERSION+$NEW_BUILD"

# Verify the change
NEW_VERSION_CHECK=$(grep '^version:' "$PUBSPEC_FILE" | sed 's/version: *//')
if [ "$NEW_VERSION_CHECK" != "$NEW_VERSION+$NEW_BUILD" ]; then
    error "Failed to update pubspec.yaml correctly. Expected: $NEW_VERSION+$NEW_BUILD, Got: $NEW_VERSION_CHECK"
fi

# Commit the version change
info ""
info "Committing version change..."
git add "$PUBSPEC_FILE"
git commit -m "Bump version to $NEW_VERSION"
success "Committed version change"

# Create git tag
info ""
info "Creating git tag $TAG_NAME..."
git tag -a "$TAG_NAME" -m "Release version $NEW_VERSION"
success "Created tag $TAG_NAME"

# Push commit and tag to origin
info ""
info "Pushing to origin..."
git push origin HEAD
success "Pushed commit to origin"

info "Pushing tag to origin..."
git push origin "$TAG_NAME"
success "Pushed tag $TAG_NAME to origin"

info ""
success "Version bump complete! 🎉"
info "  Version: $NEW_VERSION+$NEW_BUILD"
info "  Tag: $TAG_NAME"
