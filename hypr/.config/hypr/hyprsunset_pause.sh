#!/bin/bash

if pgrep -x "hyprsunset" >/dev/null; then
  echo "Hyprsunset is running, killing it..."
  pkill -x hyprsunset
else
  echo "Hyprsunset is not running, starting it..."
  hyprsunset &
fi
