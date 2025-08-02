#!/bin/bash

# Ref: https://github.com/paulmillr/dotfiles/blob/master/home/.zshrc.sh
# alias to get weather
alias weather='curl pt.wttr.in'

# used only with STDIN, to preview any file list
# example: ls | file_preview
alias file_preview="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"

alias servers="sshs --config ~/.ssh/config"

################################################################################
#  COMMAND SHADOWS
################################################################################
alias ls='lsd'

# grep padrão com cores automáticas
alias grep='grep --color=auto'
# fgrep padrão com cores automáticas
alias fgrep='fgrep --color=auto'
# egrep padrão com cores automáticas
alias egrep='egrep --color=auto'

alias mkdir='mkdir -p'

alias lg='lazygit'
alias ld='lazydocker'

alias mux='tmuxinator'
alias tx='tmux'

alias cat='bat'
alias cd='z'
cx() { cd "$@" && ls; }

# alias de navegação
alias ..="cd .."
alias cd..="cd .."

alias ...="cd ../.."
alias .2="cd ../.."

alias ....="cd ../../.."
alias .3="cd ../.."

alias .....="cd ../../../.."
alias .4="cd ../.."

alias back="cd -"

# alias pro 'free'
# -m  - memória
# -t  - exibe uma linha a mais com o total de memória
# -h  - leitura mais humana
alias free="free -mth"

# get and print folder size for all folders, recursively
alias sizer='du -h -c'

alias k="kubecolor"

################################################################################
#  ALIAS AND FUNCTIONS ALIASES
################################################################################
# lista os alias de forma mais amigável
alias aliases="alias | sed 's/=.*//'"

# lista todas as funções de forma mais amigável
alias functions="declare -f | grep '^[a-z].* ()' | sed 's/{$//'"

# print $path mais amigável
alias path='echo $PATH | tr ":" "\n" | sort'

# Mostra todas as interfaces de rede, highlighted, e de mais fácil visualização.
alias ips='ip -c -br a'

# Função auxiliar, para todos os comandos
__is_cmd_installed() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "$cmd is not installed. Please install it first."
    return 1
  fi
}
