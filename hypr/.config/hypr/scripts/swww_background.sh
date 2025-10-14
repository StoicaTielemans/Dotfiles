#!/bin/sh
# For each display, changes the wallpaper to a randomly chosen image in
# a given directory at a set interval.

# start background deamon
swww-daemon

DEFAULT_INTERVAL=300 # In seconds
# See swww-img(1)
RESIZE_TYPE="fit"

while true; do
  find "$1" -type f |
    while read -r img; do
      echo "$(</dev/urandom tr -dc a-zA-Z0-9 | head -c 8):$img"
    done |
    sort -n | cut -d':' -f2- |
    while read -r img; do
      for d in $( # see swww-query(1)
        swww query | awk '{print $2}' | sed s/://
      ); do
        # Get next random image for this display, or re-shuffle images
        # and pick again if no more unused images are remaining
        [ -z "$img" ] && if read -r img; then true; else break 2; fi
        swww img --resize "$RESIZE_TYPE" --outputs "$d" "$img"
        unset -v img # Each image should only be used once per loop
      done
      sleep "${2:-$DEFAULT_INTERVAL}"
    done
done
