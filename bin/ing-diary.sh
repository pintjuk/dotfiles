#!/bin/zsh

file_path=~/Notes/ingrid/diary/$(date +%Y-%m-%d).md

if [[ ! -f $file_path ]]; then
  touch $file_path
fi

tmux new-window "nvim $file_path"
