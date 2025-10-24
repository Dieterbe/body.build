#!/bin/bash
# Generate app icons for Android and iOS from SVG source
# Requires: Inkscape for SVG rendering, ImageMagick for solid colors

set -e

SVG_SOURCE="app_icon_source.svg"
SVG_FOREGROUND="app_icon_foreground.svg"

if [ ! -f "$SVG_SOURCE" ]; then
    echo "ERROR: SVG file not found: $SVG_SOURCE"
    exit 1
fi

if [ ! -f "$SVG_FOREGROUND" ]; then
    echo "ERROR: Foreground SVG file not found: $SVG_FOREGROUND"
    exit 1
fi

echo "Using SVG source: $SVG_SOURCE"
echo "Using foreground SVG: $SVG_FOREGROUND"
echo ""

# Generate Android icons
echo "Generating Android adaptive icons..."

declare -A ANDROID_SIZES=(
    ["mipmap-mdpi"]=48
    ["mipmap-hdpi"]=72
    ["mipmap-xhdpi"]=96
    ["mipmap-xxhdpi"]=144
    ["mipmap-xxxhdpi"]=192
)

# For adaptive icons, we need foreground and background at 108dp (with 72dp safe zone)
# The foreground should be 108/72 = 1.5x the legacy icon size
declare -A ADAPTIVE_SIZES=(
    ["mipmap-mdpi"]=72
    ["mipmap-hdpi"]=108
    ["mipmap-xhdpi"]=144
    ["mipmap-xxhdpi"]=216
    ["mipmap-xxxhdpi"]=288
)

for folder in "${!ANDROID_SIZES[@]}"; do
    legacy_size=${ANDROID_SIZES[$folder]}
    adaptive_size=${ADAPTIVE_SIZES[$folder]}
    output_dir="android/app/src/main/res/$folder"
    mkdir -p "$output_dir"
    
    # Generate legacy icon (for backwards compatibility)
    legacy_file="$output_dir/ic_launcher.png"
    echo "Generating $legacy_file (${legacy_size}x${legacy_size})"
    inkscape "$SVG_SOURCE" --export-type=png --export-filename="$legacy_file" \
        --export-width=$legacy_size --export-height=$legacy_size 2>/dev/null
    
    # Generate adaptive icon foreground (barbell without background)
    foreground_file="$output_dir/ic_launcher_foreground.png"
    echo "Generating $foreground_file (${adaptive_size}x${adaptive_size})"
    inkscape "$SVG_FOREGROUND" --export-type=png --export-filename="$foreground_file" \
        --export-width=$adaptive_size --export-height=$adaptive_size 2>/dev/null
    
    # Generate adaptive icon background (solid green color as PNG)
    background_file="$output_dir/ic_launcher_background.png"
    echo "Generating $background_file (${adaptive_size}x${adaptive_size})"
    magick -size "${adaptive_size}x${adaptive_size}" xc:"#7dd3a0" "$background_file"
done

echo ""
echo "Generating iOS icons..."

# iOS icon sizes
declare -A IOS_SIZES=(
    ["Icon-App-20x20@1x.png"]=20
    ["Icon-App-20x20@2x.png"]=40
    ["Icon-App-20x20@3x.png"]=60
    ["Icon-App-29x29@1x.png"]=29
    ["Icon-App-29x29@2x.png"]=58
    ["Icon-App-29x29@3x.png"]=87
    ["Icon-App-40x40@1x.png"]=40
    ["Icon-App-40x40@2x.png"]=80
    ["Icon-App-40x40@3x.png"]=120
    ["Icon-App-60x60@2x.png"]=120
    ["Icon-App-60x60@3x.png"]=180
    ["Icon-App-76x76@1x.png"]=76
    ["Icon-App-76x76@2x.png"]=152
    ["Icon-App-83.5x83.5@2x.png"]=167
    ["Icon-App-1024x1024@1x.png"]=1024
)

ios_dir="ios/Runner/Assets.xcassets/AppIcon.appiconset"
mkdir -p "$ios_dir"

for filename in "${!IOS_SIZES[@]}"; do
    size=${IOS_SIZES[$filename]}
    output_file="$ios_dir/$filename"
    echo "Generating $output_file (${size}x${size})"
    inkscape "$SVG_SOURCE" --export-type=png --export-filename="$output_file" \
        --export-width=$size --export-height=$size 2>/dev/null
done

echo ""
echo "✅ All app icons generated successfully!"
echo ""
echo "Android icons: android/app/src/main/res/mipmap-*/"
echo "iOS icons: ios/Runner/Assets.xcassets/AppIcon.appiconset/"
