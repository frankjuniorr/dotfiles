# FZF - ENVIRONMENT VARIABLES
# PS: this is necessary to fzf config works together 'sesh' into kitty keybing.
# But this environment variables are duplicated, and there are on '~/.bin/env.sh' (loaded by '~/.zshrc')
############################################################
export FZF_BASE="/home/${USER}/bin"

if [ -f "${FZF_BASE}/key-bindings.zsh" ]; then
  source "${FZF_BASE}/key-bindings.zsh"
fi
export FZF_DEFAULT_COMMAND="fd --type f --color=never"

# Show fzf in fullscreen
# export FZF_DEFAULT_OPTS="--height=100% --border=rounded --reverse"

export FZF_DEFAULT_OPTS="
  --border rounded
  --border-label-pos center
  --layout reverse
  --info right
  --prompt ' : '
  --pointer ''
  --marker '✓'
  --preview-window 'right:65%'
  --ansi
  --tmux 90%"
############################################################
