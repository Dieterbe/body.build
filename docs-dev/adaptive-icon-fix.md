# Android Adaptive Icon Fix

## Problem
The app icon was rendering incorrectly on Android 8.0+ devices, appearing as a small square on a white circle background (legacy mode). This happened because the app only had legacy `ic_launcher.png` files without adaptive icon support.

## Solution
Implemented **Android Adaptive Icons** following the [Android Icon Design Specifications](https://developer.android.com/distribute/google-play/resources/icon-design-specifications).

## Changes Made

### 1. Created Foreground SVG
- **File**: `app_icon_foreground.svg`
- Contains the barbell graphic without the green background
- Used as the foreground layer for adaptive icons

### 2. Updated Icon Generation Script
- **File**: `scripts/generate_app_icons.sh`
- Now generates three types of icons for each density:
  - `ic_launcher.png` - Legacy icon (backwards compatibility)
  - `ic_launcher_foreground.png` - Adaptive icon foreground layer (barbell)
  - `ic_launcher_background.png` - Adaptive icon background layer (solid #7dd3a0 green)
- Switched from ImageMagick to Inkscape for better SVG rendering (dieter note: actually no, cause i added some "inkscape-only" syntax to set labels on some things)
- Adaptive icons are 1.5x the size of legacy icons (108dp vs 72dp safe zone)

### 3. Created Adaptive Icon XML Configuration
- **File**: `android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml`
- Defines the adaptive icon structure for Android 8.0+ (API 26+)
- References the foreground and background drawables

## How It Works

**Android 8.0+ (API 26+)**:
- Uses the adaptive icon defined in `mipmap-anydpi-v26/ic_launcher.xml`
- Combines foreground (barbell) and background (green) layers
- Android applies the device's preferred shape (circle, square, rounded square, etc.)
- Icon looks native to each device's design language

**Android 7.1 and below**:
- Falls back to legacy `ic_launcher.png` files
- Shows the full square icon with green background

## Generated Files

### Android Adaptive Icons
All densities now include:
- `android/app/src/main/res/mipmap-mdpi/` (72x72 adaptive, 48x48 legacy)
- `android/app/src/main/res/mipmap-hdpi/` (108x108 adaptive, 72x72 legacy)
- `android/app/src/main/res/mipmap-xhdpi/` (144x144 adaptive, 96x96 legacy)
- `android/app/src/main/res/mipmap-xxhdpi/` (216x216 adaptive, 144x144 legacy)
- `android/app/src/main/res/mipmap-xxxhdpi/` (288x288 adaptive, 192x192 legacy)
- `android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml`

### iOS Icons
No changes needed - iOS icons continue to work as before.

## Testing
To test the fix:
1. Build and install the app on an Android 8.0+ device
2. Check the app icon on the home screen
3. The icon should now appear as a properly shaped icon (circle/rounded square) with the barbell centered on the green background
4. No more white circle background in legacy mode

## Regenerating Icons
To regenerate icons after modifying the SVG source files:
```bash
bash scripts/generate_app_icons.sh
```

**Requirements**:
- Inkscape (for SVG to PNG conversion)
- ImageMagick (for solid color backgrounds)
