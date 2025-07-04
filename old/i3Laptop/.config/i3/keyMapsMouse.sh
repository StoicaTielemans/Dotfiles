#!/bin/bash
# set XKB layout
setxkbmap -layout us

# turn on mousekeys
xkbset m

# stop mousekeys expiring after a timeout
xkbset exp =m

# Map keysym to other keysym
xmodmap -e "keycode 49 = grave"

# Get the ID of your mouse
mouse_id=$(xinput list | grep -i 'mouse' | grep -o 'id=[0-9]*' | grep -o '[0-9]*')

# Map mouse button 8 to keycode 49 (grave key)
xinput set-button-map $mouse_id 1 2 3 4 5 6 7 49

