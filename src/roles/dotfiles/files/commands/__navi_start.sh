#!/bin/env bash

current_dir=$(pwd)
# Load FZF configs
if [ -f ~/.config/dotfiles/__fzf_config.sh ]; then
  source ~/.config/dotfiles/__fzf_config.sh
fi

cd "$current_dir"
navi
