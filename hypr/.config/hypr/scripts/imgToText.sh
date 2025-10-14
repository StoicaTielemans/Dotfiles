#!/usr/bin/env bash

# Description:
# Select a region on screen and convert the image to text using OCR (tesseract).
# Requirements: grim, slurp, tesseract, wl-clipboard (optional)

# Check if required tools are installed
for cmd in grim slurp tesseract; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: '$cmd' is not installed or not in PATH."
    exit 1
  fi
done

# Optional clipboard support
HAS_CLIPBOARD=no
if command -v wl-copy >/dev/null 2>&1; then
  HAS_CLIPBOARD=yes
fi

# Take area selection
echo "Select area to extract text..."
GEOM=$(slurp)
if [ -z "$GEOM" ]; then
  echo "Selection cancelled."
  exit 1
fi

# Temporary image path
TEMP_IMG=$(mktemp /tmp/img2text_XXXXXX.png)

# Take screenshot
grim -g "$GEOM" "$TEMP_IMG"

# Extract text with tesseract
echo "Extracting text..."
TEXT=$(tesseract "$TEMP_IMG" stdout)

# Show result
echo "------- OCR Result -------"
echo "$TEXT"
echo "--------------------------"

# Copy to clipboard if possible
if [ "$HAS_CLIPBOARD" = "yes" ]; then
  echo "$TEXT" | wl-copy
  echo "Text copied to clipboard."
fi

# Cleanup
rm -f "$TEMP_IMG"
