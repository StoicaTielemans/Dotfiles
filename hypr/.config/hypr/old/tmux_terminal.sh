#!/bin/bash

# Check if tmux session "default" exists
if tmux has-session -t default 2>/dev/null; then
  # Session exists, attach to it
  ghostty -e tmux attach-session -t default
else
  # Session doesn't exist, create new one
  ghostty -e tmux new-session -s default
fi
