#!/bin/bash
# Generate app icons for Android and iOS from SVG source
# Requires: ImageMagick (convert command)

set -e

SVG_SOURCE="app_icon_source.svg"

if [ ! -f "$SVG_SOURCE" ]; then
    echo "ERROR: SVG file not found: $SVG_SOURCE"
    exit 1
fi

echo "Using SVG source: $SVG_SOURCE"
echo ""

# Generate Android icons
echo "Generating Android icons..."

declare -A ANDROID_SIZES=(
    ["mipmap-mdpi"]=48
    ["mipmap-hdpi"]=72
    ["mipmap-xhdpi"]=96
    ["mipmap-xxhdpi"]=144
    ["mipmap-xxxhdpi"]=192
)

for folder in "${!ANDROID_SIZES[@]}"; do
    size=${ANDROID_SIZES[$folder]}
    output_dir="android/app/src/main/res/$folder"
    mkdir -p "$output_dir"
    output_file="$output_dir/ic_launcher.png"
    echo "Generating $output_file (${size}x${size})"
    convert -background none -resize "${size}x${size}" "$SVG_SOURCE" "$output_file"
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
    convert -background none -resize "${size}x${size}" "$SVG_SOURCE" "$output_file"
done

echo ""
echo "✅ All app icons generated successfully!"
echo ""
echo "Android icons: android/app/src/main/res/mipmap-*/"
echo "iOS icons: ios/Runner/Assets.xcassets/AppIcon.appiconset/"
