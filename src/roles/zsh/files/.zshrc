if [ -f "${HOME}/.atuin/bin/env" ];then
  source "${HOME}/.atuin/bin/env"
fi

if which atuin > /dev/null 2>&1 ;then
  eval "$(atuin init zsh --disable-up-arrow)"
fi

if which zoxide > /dev/null 2>&1 ;then
  eval "$(zoxide init zsh)"
fi


# PATH
############################################################
path=(
    $path               # Keep existing PATH entries
    $HOME/.bin/
    $HOME/.local/bin
    $HOME/.krew/bin
    /usr/local/go/bin
)

# Remove duplicate entries and non-existent directories
typeset -U path

# TODO: Precisa mesmo dessa linha?
export PATH


# Load all others dotfiles
if [ -d ${HOME}/.config/dotfiles ]; then
   for dotfiles in ${HOME}/.config/dotfiles/*; do
      source $dotfiles
   done
fi

# OH-MY-ZSH
############################################################
#export ZSH="$HOME/.oh-my-zsh"
#ZSH_THEME=""

#DISABLE_AUTO_TITLE="true"

#plugins=(
#    zsh-syntax-highlighting
#    zsh-autosuggestions
#   )

# source $ZSH/oh-my-zsh.sh

# SSH
############################################################
# carregando o agent ssh, e adicionando as chaves
# if ! ps aux | grep "ssh-agent -s" | grep -v grep > /dev/null;then
#     eval "$(ssh-agent -s)" > /dev/null
# fi

# # procure tudo que não for:
# # - com o nome de "config"
# # - com o nome de "known_hosts"
# # - com o nome de "authorized_keys"
# # - com o nome de "com formato"
# # Ou seja, procure todas as chaves privadas dentro do diretório do ssh
# if [ -d ~/.ssh ];then
#   ssh_private_keys=($(find ~/.ssh -type f ! -iname "config" ! -iname "known_hosts" ! -iname "authorized_keys" ! -name "*.*"))

#   for private_key in $ssh_private_keys; do
#       ssh-add "$private_key" > /dev/null 2>&1
#   done
# fi

# export STARSHIP_CONFIG=~/.config/starship/starship.toml
# eval "$(starship init zsh)"