#!/bin/bash
# Toggle mute/unmute based on the input parameter
if [ "$1" == "mute" ]; then
    pactl set-source-mute @DEFAULT_SOURCE@ 1
elif [ "$1" == "unmute" ]; then
    pactl set-source-mute @DEFAULT_SOURCE@ 0
fi

