#!/bin/bash

# Directory to save the screenshots
SCREENSHOT_DIR=~/Pictures/Screenshots

# Ensure the directory exists
mkdir -p $SCREENSHOT_DIR

# Filename for the screenshot
FILENAME=$SCREENSHOT_DIR/screenshot-$(date +%Y-%m-%d-%H%M%S).png

# Take a screenshot of a selected region
grim -g "$(slurp)" $FILENAME

# Copy the screenshot to the clipboard
wl-copy < $FILENAME

echo "Screenshot saved to $FILENAME and copied to clipboard."

