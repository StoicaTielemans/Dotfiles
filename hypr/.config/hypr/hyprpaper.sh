#!/bin/bash

# Directory containing background images
BACKGROUND_DIR=~/Pictures/Background/

# Get a list of all images in the directory
IMAGES=($(find "$BACKGROUND_DIR" -type f -name '*.png' -o -name '*.jpg'))

# Get the count of images
IMAGE_COUNT=${#IMAGES[@]}

if [ $IMAGE_COUNT -eq 0 ]; then
    echo "No images found in $BACKGROUND_DIR"
    exit 1
fi

# Select random images for each display
RANDOM_IMAGE1=${IMAGES[$RANDOM % $IMAGE_COUNT]}
RANDOM_IMAGE2=${IMAGES[$RANDOM % $IMAGE_COUNT]}
RANDOM_IMAGE3=${IMAGES[$RANDOM % $IMAGE_COUNT]}

# Create hyprpaper.conf
CONFIG_FILE=~/.config/hypr/hyprpaper.conf

echo "preload=$RANDOM_IMAGE1" > $CONFIG_FILE
echo "preload=$RANDOM_IMAGE2" >> $CONFIG_FILE
echo "preload=$RANDOM_IMAGE3" >> $CONFIG_FILE

echo "wallpaper=DP-2,$RANDOM_IMAGE1" >> $CONFIG_FILE
echo "wallpaper=DP-3,$RANDOM_IMAGE2" >> $CONFIG_FILE
echo "wallpaper=HDMI-A-1,$RANDOM_IMAGE3" >> $CONFIG_FILE

echo "Hyprpaper configuration updated with random backgrounds."

# Reload Hyprpaper
# hyprctl hyprpaper reload

