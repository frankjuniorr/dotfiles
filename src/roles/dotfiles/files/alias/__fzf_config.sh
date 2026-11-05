# FZF - ENVIRONMENT VARIABLES
# PS: these environment variables are duplicated, and there are on '~/.bin/env.sh' (loaded by '~/.zshrc')
# (sesh no longer depends on them: ~/.bin/__sesh_start uses the built-in `sesh picker`, not fzf)
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
