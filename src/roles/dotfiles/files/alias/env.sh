#!/bin/bash

# EDITOR
############################################################
# export EDITOR=vim
# export EDITOR=nvim
export EDITOR=nvim

# SSH
############################################################
export SSH_AUTH_SOCK=~/.1password/agent.sock

# Terminal
############################################################
# PS: Apparently this car only necessary on Ubuntu.
# Arch + hyprland + kitty, isn't necessary
# export TERM="tmux-256color"

# MANPAGES
############################################################
# TODO: replace by TL;DR (https://github.com/tldr-pages/tldr)
export LESS_TERMCAP_mb=${bold_green}
export LESS_TERMCAP_md=${bold_green}
export LESS_TERMCAP_me=${text_reset}
export LESS_TERMCAP_se=${text_reset}
export LESS_TERMCAP_so=${bold_yellow}
export LESS_TERMCAP_ue=${text_reset}
export LESS_TERMCAP_us=${bold_red}

# FZF
############################################################
# Load FZF configs
if [ -f ~/.config/dotfiles/__fzf_config.sh ]; then
  source ~/.config/dotfiles/__fzf_config.sh
fi

# CTRL + T: call the fzf in current folder
# with a preview by bat
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :50 {}'"

# ALT + C: call the fzf in current folder
# with a tree preview
export FZF_ALT_C_COMMAND="fd --type d . --color=never"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -n 50'"

source ~/.config/dotfiles/private-env.sh
