#!/bin/bash
SESSION="default"
# Only create if it doesn't exist
  # Window 1:
  tmux new-session -d -s $SESSION -n tree
  tmux send-keys -t "$SESSION" 'tree' C-m
  # Split horizontal
  tmux split-window -h -t "$SESSION"
# Attach to the session
tmux attach -t $SESSION