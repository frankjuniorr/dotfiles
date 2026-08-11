#!/bin/bash

# sesh session picker, bound directly in zsh so it works from any terminal
# and any environment (Omarchy, HyDE, Ubuntu — anywhere zsh runs), not just
# from inside kitty. kitty.conf (hyde role) still binds ctrl+shift+s at the
# terminal-app level for HyDE; this widget is the terminal-agnostic
# equivalent. There's also a SUPER+ALT+S Hyprland bind (omarchy role) that
# opens a fresh terminal running this same script from anywhere — useful
# when there's no shell open yet. This widget only fires once you already
# have a zsh prompt.
if [[ -o interactive ]]; then
  __sesh_widget() {
    if [ -x ~/.bin/__sesh_start ]; then
      ~/.bin/__sesh_start
    fi
    zle reset-prompt
  }
  zle -N __sesh_widget

  # Ctrl+Shift+S — only reaches zsh as a distinct sequence on terminals that
  # speak the Kitty/CSI-u keyboard protocol (kitty, foot, wezterm, ghostty).
  # Most terminals collapse Ctrl+Shift+<letter> to the same byte as
  # Ctrl+<letter>, so this is a nice-to-have, not something to rely on.
  bindkey '^[[83;6u' __sesh_widget

  # Alt+S — universal fallback. Works on every terminal without needing any
  # special keyboard protocol (Alt sends ESC by default almost everywhere).
  bindkey '\es' __sesh_widget
fi
