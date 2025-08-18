#!/bin/bash

# Ref: https://github.com/paulmillr/dotfiles/blob/master/home/.zshrc.sh
# alias to get weather
alias weather='curl pt.wttr.in'

alias servers="sshs --config ~/.ssh/config"

################################################################################
#  COMMAND SHADOWS
################################################################################

alias lg='lazygit'
alias ld='lazydocker'

alias mux='tmuxinator'
alias tx='tmux'

# alias pro 'free'
# -m  - memória
# -t  - exibe uma linha a mais com o total de memória
# -h  - leitura mais humana
alias free="free -mth"

# get and print folder size for all folders, recursively
alias sizer='du -h -c'

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

# Chama o binário do meu projeto Dotfiles de qualquer lugar do terminal, passando pelo flow
alias dotfiles="flow run dotfiles/dotfiles "

################################################################################
# DOCKER ALIAS
################################################################################
# My cusom docker commands
alias d-docker="bash ~/.bin/docker/docker.sh"
