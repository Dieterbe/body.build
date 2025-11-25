#!/bin/bash
# Generate favicons from app_icon_source.svg
# This script creates various favicon sizes for web use

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
SOURCE_SVG="$PROJECT_ROOT/app_icon_source.svg"
BUILD_DIR="$PROJECT_ROOT/build/favicons"
WEB_ICONS_DIR="$PROJECT_ROOT/web/icons"

echo "Generating favicons from $SOURCE_SVG..."

# Create build directory
mkdir -p "$BUILD_DIR"

# Generate PNG favicons at various sizes
convert "$SOURCE_SVG" -resize 16x16 "$BUILD_DIR/favicon-16x16.png"
convert "$SOURCE_SVG" -resize 32x32 "$BUILD_DIR/favicon-32x32.png"
convert "$SOURCE_SVG" -resize 48x48 "$BUILD_DIR/favicon-48x48.png"
convert "$SOURCE_SVG" -resize 180x180 "$BUILD_DIR/apple-touch-icon.png"
convert "$SOURCE_SVG" -resize 192x192 "$BUILD_DIR/Icon-192.png"
convert "$SOURCE_SVG" -resize 512x512 "$BUILD_DIR/Icon-512.png"
convert "$SOURCE_SVG" -resize 192x192 "$BUILD_DIR/Icon-maskable-192.png"
convert "$SOURCE_SVG" -resize 512x512 "$BUILD_DIR/Icon-maskable-512.png"

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
echo "  - Icon-192.png (PWA)"
echo "  - Icon-512.png (PWA)"
echo "  - Icon-maskable-192.png (Android adaptive)"
echo "  - Icon-maskable-512.png (Android adaptive)"
echo "  - favicon.svg"
echo ""

# Copy to web directory (for Flutter web build)
echo "Copying to web/..."
mkdir -p "$WEB_ICONS_DIR"
cp "$BUILD_DIR/favicon-32x32.png" "$PROJECT_ROOT/web/favicon.png"
cp "$BUILD_DIR/Icon-192.png" "$WEB_ICONS_DIR/"
cp "$BUILD_DIR/Icon-512.png" "$WEB_ICONS_DIR/"
cp "$BUILD_DIR/Icon-maskable-192.png" "$WEB_ICONS_DIR/"
cp "$BUILD_DIR/Icon-maskable-512.png" "$WEB_ICONS_DIR/"

# Copy to landing page img directory
echo "Copying to landing-page/img/..."
cp "$BUILD_DIR/favicon.ico" "$PROJECT_ROOT/landing-page/img/"
cp "$BUILD_DIR/favicon-32x32.png" "$PROJECT_ROOT/landing-page/img/"
cp "$BUILD_DIR/apple-touch-icon.png" "$PROJECT_ROOT/landing-page/img/"
cp "$BUILD_DIR/favicon.svg" "$PROJECT_ROOT/landing-page/img/"

# Copy to learn static img directory
echo "Copying to learn/static/img/..."
cp "$BUILD_DIR/favicon.svg" "$PROJECT_ROOT/learn/static/img/"

echo ""
echo "✓ Done! Favicons generated and copied to deployment directories."
