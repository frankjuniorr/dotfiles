#################################################################
# NAVIGATION COMMANDS
#################################################################

# Navigation alias
# ----------------------------------------------------------------------
alias ..="cd .."
alias cd..="cd .."

alias ...="cd ../.."
alias .2="cd ../.."

alias ....="cd ../../.."
alias .3="cd ../.."

alias .....="cd ../../../.."
alias .4="cd ../.."

alias back="cd -"

alias ls='lsd'

# grep padrão com cores automáticas
alias grep='grep --color=auto'
# fgrep padrão com cores automáticas
alias fgrep='fgrep --color=auto'
# egrep padrão com cores automáticas
alias egrep='egrep --color=auto'

alias mkdir='mkdir -p'

alias cat='bat'
alias cd='z'
cx() {
  cd "$@" && ls
}

# FZF commands
# ----------------------------------------------------------------------
# used only with STDIN, to preview any file list
# example: ls | file_preview
alias file_preview="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"

# Alternative to `cd` using `fzf`
change-dir() {
  local initial_query="$1"
  local selected_dir
  local fzf_options=('--preview=lsd --tree --depth 2 {}' '--preview-window=right:60%')
  fzf_options+=(--height "80%" --layout=reverse --preview-window right:60% --cycle)
  local max_depth=7

  if [[ -n "$initial_query" ]]; then
    fzf_options+=("--query=$initial_query")
  fi

  selected_dir=$(fd --type d \
    --max-depth "$max_depth" \
    --exclude .git \
    --exclude node_modules \
    --exclude .venv \
    --exclude target \
    --exclude .cache |
    fzf "${fzf_options[@]}")

  if [[ -n "$selected_dir" && -d "$selected_dir" ]]; then
    cd "$selected_dir" || return 1
    ls
  else
    return 1
  fi
}
