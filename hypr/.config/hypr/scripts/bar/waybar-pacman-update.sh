#!/usr/bin/env bash

# Script for Waybar custom module: shows package updates with tooltip

# Check for updates (Arch Linux example: pacman + paru for AUR)
updates=$(checkupdates 2>/dev/null)
aur_updates=$(paru -Qua 2>/dev/null)

# Combine all updates
all_updates=$(printf "%s\n%s" "$updates" "$aur_updates" | sort)

# Count updates
count=$(echo "$all_updates" | grep -c .)

# Prepare JSON output for Waybar
if [[ $count -gt 0 ]]; then
  text="⬆ $count updates"
  tooltip=""

  # Format tooltip: old version -> new version, one package per line
  while IFS= read -r line; do
    # Split fields
    pkg=$(echo "$line" | awk '{print $1}')
    old_ver=$(echo "$line" | awk '{print $2}')
    new_ver=$(echo "$line" | awk '{print $4}')

    if [[ -n "$new_ver" ]]; then
      tooltip+="$pkg : $old_ver → $new_ver\n"
    else
      tooltip+="$pkg : $old_ver\n"
    fi
  done <<<"$all_updates"

  # Escape JSON special chars
  tooltip=$(echo -e "$tooltip" | sed 's/\\/\\\\/g; s/"/\\"/g')

  # Output JSON
  jq -nc --arg text "$text" --arg tooltip "$tooltip" '{text: $text, tooltip: $tooltip}'
else

fi
