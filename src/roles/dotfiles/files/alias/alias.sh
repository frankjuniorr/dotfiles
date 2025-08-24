#!/bin/bash

################################################################################
# JAM Project
################################################################################
jam_project_folder="${HOME}/Dropbox/code/01.github/projects/jam"
jam_bin="${jam_project_folder}/jam.sh"

alias jam="bash ${jam_bin}"

# Ref: https://github.com/paulmillr/dotfiles/blob/master/home/.zshrc.sh
# alias to get weather
alias weather='curl pt.wttr.in'

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
alias disk='ncdu'

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
alias dotfiles="flow run dotfiles/dotfiles:dotfiles"

################################################################################
# DOCKER ALIAS
################################################################################
# My cusom docker commands
alias jam-docker="bash ${jam_bin} ${jam_project_folder}/menus/code/docker/docker.yaml"

#################################################################
# CODE
#################################################################
alias jam-python="bash ${jam_bin} ${jam_project_folder}/menus/code/python/python.yaml"

#################################################################
# SYSTEM
#################################################################
# My custom bluetooth commands
alias jam-bluetooth="bash ${jam_bin} ${jam_project_folder}/menus/system/bluetooth/bluetooth.yaml"
alias jam-system="bash ${jam_bin} ${jam_project_folder}/menus/system/system.yaml"

#################################################################
# FLOW
#################################################################
alias flow-menu="bash ~/.bin/system/flow.sh"
