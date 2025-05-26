#!/usr/bin/env bash

# Dependencies: grim, slurp, tesseract, wl-copy, notify-send (optional)

IMG="/tmp/ocr_screenshot.png"
TXT="/tmp/ocr_result.txt"

# Take a screenshot of selected area
grim -g "$(slurp)" "$IMG" || exit 1

# Run OCR
tesseract "$IMG" "$TXT" &>/dev/null || {
  notify-send "OCR Error" "Failed to extract text"
  exit 2
}

# Copy text to clipboard
cat "$TXT.txt" | wl-copy

# Optional: notify
notify-send "OCR Complete" "Text copied to clipboard"
