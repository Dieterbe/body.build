#!/bin/bash

# This script is a wrapper around the `flutter` command.
# It inspects the arguments to find the device ID, determines the platform
# from the device ID, and then calls the real `flutter` command with a
# device specific additional `--dart-define-from-file` argument.
# This is mainly useful for vscode launching, where the device is selected via the UI
# and not made explicit in the launch configs (we could do it that way, but it would mean
# many more launch configs)

# Find the real flutter executable.
# We assume it's in the PATH.
FLUTTER_CMD=$(which flutter)

if [ -z "$FLUTTER_CMD" ]; then
  echo "Error: 'flutter' command not found in PATH."
  exit 1
fi

# The arguments passed to this script by the Dart extension.
ARGS=("$@")

# Find the device ID from the arguments.
DEVICE_ID=""
# Using a C-style for loop to be able to look ahead
for ((i=0; i<${#ARGS[@]}; i++)); do
  case "${ARGS[$i]}" in
    -d|--device-id)
      DEVICE_ID="${ARGS[$i+1]}"
      break
      ;;
    --device-id=*)
      DEVICE_ID="${ARGS[$i]#*=}"
      break
      ;;
  esac
done

PLATFORM=""
if [ -n "$DEVICE_ID" ]; then
  # Get the platform from `flutter devices`.
  # This adds a small delay to the launch.
  PLATFORM_LINE=$(flutter devices | grep "$DEVICE_ID")
  if [[ "$PLATFORM_LINE" == *"android"* ]]; then
    PLATFORM="android"
  elif [[ "$PLATFORM_LINE" == *"ios"* ]]; then
    PLATFORM="ios"
  elif [[ "$PLATFORM_LINE" == *"linux"* ]]; then
    PLATFORM="linux"
  elif [[ "$PLATFORM_LINE" == *"web"* ]]; then
    PLATFORM="web"
  elif [[ "$PLATFORM_LINE" == *"macos"* ]]; then
    PLATFORM="macos"
  elif [[ "$PLATFORM_LINE" == *"windows"* ]]; then
    PLATFORM="windows"
  fi
fi

if [ -z "$PLATFORM" ]; then
  echo "Error: Could not determine platform from device ID '$DEVICE_ID'."
  exit 1
fi

DART_DEFINES_ARG="--dart-define-from-file=.vscode/dart-defines-$PLATFORM.json"
ARGS+=("$DART_DEFINES_ARG")

# Execute the real flutter command with the modified arguments.
exec "$FLUTTER_CMD" "${ARGS[@]}"
