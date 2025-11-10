#!/bin/bash
# Generate favicons from app_icon_source.svg
# This script creates various favicon sizes for web use

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
SOURCE_SVG="$PROJECT_ROOT/app_icon_source.svg"
BUILD_DIR="$PROJECT_ROOT/build/favicons"

echo "Generating favicons from $SOURCE_SVG..."

# Create build directory
mkdir -p "$BUILD_DIR"

# Generate PNG favicons at various sizes
convert "$SOURCE_SVG" -resize 16x16 "$BUILD_DIR/favicon-16x16.png"
convert "$SOURCE_SVG" -resize 32x32 "$BUILD_DIR/favicon-32x32.png"
convert "$SOURCE_SVG" -resize 48x48 "$BUILD_DIR/favicon-48x48.png"
convert "$SOURCE_SVG" -resize 180x180 "$BUILD_DIR/apple-touch-icon.png"
convert "$SOURCE_SVG" -resize 192x192 "$BUILD_DIR/android-chrome-192x192.png"
convert "$SOURCE_SVG" -resize 512x512 "$BUILD_DIR/android-chrome-512x512.png"

# Generate multi-size .ico file for browsers
convert "$SOURCE_SVG" -resize 16x16 \
  "$SOURCE_SVG" -resize 32x32 \
  "$SOURCE_SVG" -resize 48x48 \
  "$BUILD_DIR/favicon.ico"

# Copy SVG to build directory
cp "$SOURCE_SVG" "$BUILD_DIR/favicon.svg"

echo "✓ Generated favicons in $BUILD_DIR:"
echo "  - favicon.ico (16x16, 32x32, 48x48)"
echo "  - favicon-16x16.png"
echo "  - favicon-32x32.png"
echo "  - favicon-48x48.png"
echo "  - apple-touch-icon.png (180x180)"
echo "  - android-chrome-192x192.png"
echo "  - android-chrome-512x512.png"
echo "  - favicon.svg"
echo ""

# Copy to landing page img directory
echo "Copying to landing-page/img/..."
cp "$BUILD_DIR/favicon.ico" "$PROJECT_ROOT/landing-page/img/"
cp "$BUILD_DIR/favicon-32x32.png" "$PROJECT_ROOT/landing-page/img/"
cp "$BUILD_DIR/apple-touch-icon.png" "$PROJECT_ROOT/landing-page/img/"
cp "$BUILD_DIR/favicon.svg" "$PROJECT_ROOT/landing-page/img/"

# Copy to learn static img directory
echo "Copying to learn/static/img/..."
cp "$BUILD_DIR/favicon.ico" "$PROJECT_ROOT/learn/static/img/"
cp "$BUILD_DIR/favicon-32x32.png" "$PROJECT_ROOT/learn/static/img/"
cp "$BUILD_DIR/apple-touch-icon.png" "$PROJECT_ROOT/learn/static/img/"
cp "$BUILD_DIR/android-chrome-192x192.png" "$PROJECT_ROOT/learn/static/img/"
cp "$BUILD_DIR/android-chrome-512x512.png" "$PROJECT_ROOT/learn/static/img/"
cp "$BUILD_DIR/favicon.svg" "$PROJECT_ROOT/learn/static/img/"

echo ""
echo "✓ Done! Favicons generated and copied to deployment directories."
