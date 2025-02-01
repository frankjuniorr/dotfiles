#!/bin/bash

alias matrix="cmatrix -b -s -u 6"

# Clipboard
# use: "echo mensagem | copiar"
alias cp_copy='xclip -selection c'
alias cp_paste='xclip -selection clipboard -o'

# Ref: https://github.com/paulmillr/dotfiles/blob/master/home/.zshrc.sh
# alias to get weather
alias clima='curl pt.wttr.in'

################################################################################
#  COMMAND SHADOWS
################################################################################
if type lsd > /dev/null 2>&1; then
    alias ls='lsd'
else
    # ls padrão com cores automáticas
    alias ls='ls -h --color=auto --group-directories-first'
fi

# grep padrão com cores automáticas
alias grep='grep --color=auto'
# fgrep padrão com cores automáticas
alias fgrep='fgrep --color=auto'
# egrep padrão com cores automáticas
alias egrep='egrep --color=auto'

alias cat='bat'
alias cd='z'
cx(){ cd "$@" && ls; }

# fd = package to replace "find" command
# package used by "fzf" in "FZF_DEFAULT_COMMAND" env variable
# Installation Ubuntu: sudo apt install fd-find
# The name of executable is "fdfind". So, only in Ubuntu is necessary this alias below
alias fd='fdfind'

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

################################################################################
#  GIT ALIAS
################################################################################
# olhe: http://opensource.apple.com/source/Git/Git-19/src/git-htmldocs/pretty-formats.txt

# <hash> <date> <user name> <commit message>
alias gl='git log -n 20 --oneline --date=short --pretty=format:"%Cgreen%h%Creset %Cred%ad%Creset %Cblue% %aN%Creset %s"'

# <hash> <date> <user email> <commit message>
alias gle='git log -n 20 --oneline --date=short --pretty=format:"%Cgreen%h%Creset %Cred%ad%Creset %Cblue% %ae%Creset %s"'

# imprime apenas o ultimo commit
alias git_last_commit="git log -1 --pretty=%s"

# desfaz as alteração do stage
alias git_unstage="git reset HEAD"

# pega o nome do repositório do git
alias git_repository_name="git config --get --local remote.origin.url"

# Deleta todas as branches locais, deixando só a current branch
alias git_clean_branches="git branch | grep -v \"\*\" | xargs -n 1 git branch -D && git fetch --prune"

# undo commit, and files back to the 'stage area'
alias git_undo_commit="git reset --soft HEAD^"