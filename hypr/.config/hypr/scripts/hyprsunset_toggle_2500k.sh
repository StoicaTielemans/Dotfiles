#!/bin/bash

# Check if hyprsunset is running with the 3000K setting
if pgrep -f "hyprsunset --temperature 2500" >/dev/null; then
  # If 3000K is running, kill it and start default
  killall hyprsunset
  hyprsunset &
else
  # If not running (or default is running), kill and start 3000K
  killall hyprsunset
  hyprsunset --temperature 2500 &
fi
