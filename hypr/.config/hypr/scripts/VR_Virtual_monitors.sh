#!/bin/bash
#
# racing-screens.sh
#
# Self-toggling script for the 3 headless virtual outputs used in a
# triple-screen VR racing setup. Detects whether the virtual screens
# currently exist and does the opposite each time it's run.
#
# Usage:
#   ./racing-screens.sh
#     - no virtual screens present -> creates + positions them (racing mode ON)
#     - virtual screens present    -> removes them (racing mode OFF)

set -euo pipefail

mapfile -t EXISTING_NAMES < <(hyprctl -j monitors | jq -r '.[] | select(.name | test("HEADLESS-")).name')

if [[ ${#EXISTING_NAMES[@]} -gt 0 && ${#EXISTING_NAMES[@]} -ne 3 ]]; then
  echo "Warning: found ${#EXISTING_NAMES[@]} headless outputs (expected 0 or 3): ${EXISTING_NAMES[*]}"
  echo "This usually means a previous run was interrupted. Run this script again to remove them, then run once more to create a clean set of 3."
  exit 1
fi

if [[ ${#EXISTING_NAMES[@]} -eq 0 ]]; then
  echo "Racing mode ON: creating virtual triple-screen outputs..."

  hyprctl output create headless
  hyprctl output create headless
  hyprctl output create headless

  # Hyprland assigns HEADLESS-N names itself and doesn't guarantee starting at 1,
  # so query the live names instead of hardcoding them.
  mapfile -t HEADLESS_NAMES < <(hyprctl -j monitors | jq -r '.[] | select(.name | test("HEADLESS-")).name')

  if [[ ${#HEADLESS_NAMES[@]} -lt 3 ]]; then
    echo "Warning: expected 3 headless outputs, found ${#HEADLESS_NAMES[@]}. Check 'hyprctl monitors'."
    exit 1
  fi

  # Positioned well above the real monitor row (y=10000) so the virtual
  # block never overlaps or touches real monitors in the layout. The 3
  # screens stay adjacent to each other (required for the triple-screen
  # span to render as one contiguous area), just moved as a whole block.
  hyprctl keyword monitor "${HEADLESS_NAMES[0]},1920x1080@60,0x10000,1"
  hyprctl keyword monitor "${HEADLESS_NAMES[1]},1920x1080@60,1920x10000,1"
  hyprctl keyword monitor "${HEADLESS_NAMES[2]},1920x1080@60,3840x10000,1"

  echo "Virtual outputs ready: ${HEADLESS_NAMES[*]}"

else
  echo "Racing mode OFF: removing virtual triple-screen outputs..."

  for m in "${EXISTING_NAMES[@]}"; do
    hyprctl output remove "$m"
    echo "Removed $m"
  done

  echo "Desktop back to normal."
fi
