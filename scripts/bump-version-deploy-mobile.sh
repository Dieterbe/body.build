#!/bin/bash

set -e  # Exit on error

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Check if version argument is provided
if [ -z "$1" ]; then
    error "Usage: $0 <version>\nExample: $0 1.0.3"
fi

NEW_VERSION="$1"

# Validate version format (semver: X.Y.Z)
if ! [[ "$NEW_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    error "Invalid version format. Expected format: X.Y.Z (e.g., 1.0.3)"
fi

check_git_repo
check_git_clean

PUBSPEC_FILE="pubspec.yaml"
RELEASE_NOTES_FILE="release_notes.txt"

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

# Check if new version is greater than current version
if ! version_gt "$NEW_VERSION" "$CURRENT_VERSION"; then
    error "New version ($NEW_VERSION) must be greater than current version ($CURRENT_VERSION)"
fi

# Check if tag already exists and validate against all existing tags
TAG_NAME="v$NEW_VERSION"
if git rev-parse "$TAG_NAME" >/dev/null 2>&1; then
    error "Tag $TAG_NAME already exists locally"
fi

if git ls-remote --tags origin | grep -q "refs/tags/$TAG_NAME$"; then
    error "Tag $TAG_NAME already exists on remote"
fi

# Validate against all existing version tags
EXISTING_TAGS=$(git tag -l 'v*' | sed 's/^v//' | sort -V)
for existing_tag in $EXISTING_TAGS; do
    if ! version_gt "$NEW_VERSION" "$existing_tag"; then
        error "New version ($NEW_VERSION) must be greater than existing tag v$existing_tag"
    fi
done

# Increment build number
NEW_BUILD=$((CURRENT_BUILD + 1))

echo
info "Changes to be made:"
info "  - Update version in pubspec.yaml: $CURRENT_VERSION+$CURRENT_BUILD → $NEW_VERSION+$NEW_BUILD"
info "  - Create git tag: $TAG_NAME"
info "  - Push tag to origin"
echo

if ! confirm "Proceed?"; then
    info "Aborted"
    exit 0
fi

# Prompt for release notes
echo
info "Opening editor for release notes..."
info "Please write the release notes for version $NEW_VERSION"
echo

# Create a template if file doesn't exist or is empty
if [ ! -f "$RELEASE_NOTES_FILE" ] || [ ! -s "$RELEASE_NOTES_FILE" ]; then
    cat > "$RELEASE_NOTES_FILE" << EOF
# Release notes for version $NEW_VERSION
# 
# These notes will be published to Google Play Store.
# Write user-facing changes below (these comment lines will be auto-removed).
# Keep it concise and focused on what users will notice.
#
# Example:
# - Added new workout tracking feature
# - Fixed crash when selecting exercises
# - Improved performance on older devices

EOF
fi

# Detect editor (prefer VISUAL, then EDITOR, fallback to common editors)
if [ -n "$VISUAL" ]; then
    EDITOR_CMD="$VISUAL"
elif [ -n "$EDITOR" ]; then
    EDITOR_CMD="$EDITOR"
elif command -v nano >/dev/null 2>&1; then
    EDITOR_CMD="nano"
elif command -v vim >/dev/null 2>&1; then
    EDITOR_CMD="vim"
elif command -v vi >/dev/null 2>&1; then
    EDITOR_CMD="vi"
else
    error "No editor found. Please set VISUAL or EDITOR environment variable."
fi

# Open editor
$EDITOR_CMD "$RELEASE_NOTES_FILE"

# Remove comment lines and check if there's actual content
NOTES_CONTENT=$(grep -v '^#' "$RELEASE_NOTES_FILE" | grep -v '^[[:space:]]*$' || true)
if [ -z "$NOTES_CONTENT" ]; then
    error "Release notes are empty. Please provide release notes for this version."
fi

success "Release notes saved"

# Update pubspec.yaml
echo
info "Updating pubspec.yaml..."
sed -i "s/^version: .*$/version: $NEW_VERSION+$NEW_BUILD/" "$PUBSPEC_FILE"
success "Updated pubspec.yaml to version $NEW_VERSION+$NEW_BUILD"

# Verify the change
NEW_VERSION_CHECK=$(grep '^version:' "$PUBSPEC_FILE" | sed 's/version: *//')
if [ "$NEW_VERSION_CHECK" != "$NEW_VERSION+$NEW_BUILD" ]; then
    error "Failed to update pubspec.yaml correctly. Expected: $NEW_VERSION+$NEW_BUILD, Got: $NEW_VERSION_CHECK"
fi

# Commit the version change and release notes
echo
info "Committing version change and release notes..."
git add "$PUBSPEC_FILE" "$RELEASE_NOTES_FILE"
git commit -m "Bump version to $NEW_VERSION"
success "Committed version change and release notes"

# Create git tag
echo
info "Creating git tag $TAG_NAME..."
git tag -a "$TAG_NAME" -m "Release version $NEW_VERSION"
success "Created tag $TAG_NAME"

# Push commit and tag to origin
echo
info "Pushing to origin..."
git push origin HEAD
success "Pushed commit to origin"

info "Pushing tag to origin..." # this will trigger mobile app build
git push origin "$TAG_NAME"
success "Pushed tag $TAG_NAME to origin"

echo
success "Version bump complete! 🎉"
info "  Version: $NEW_VERSION+$NEW_BUILD"
info "  Tag: $TAG_NAME"
