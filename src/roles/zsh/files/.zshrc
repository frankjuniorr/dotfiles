
# ~~~~~~~~~~~~~~~ Paths ~~~~~~~~~~~~~~~~~~~~~~~~
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
   for public_files in ${HOME}/.config/dotfiles/*; do
      source $public_files
   done
fi

# ~~~~~~~~~~~~~~~ Environment Variables ~~~~~~~~~~~~~~~~~~~~~~~~

# exibindo data e hora no comando 'history'
export HISTTIMEFORMAT="%d/%m/%y %T "
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt HIST_IGNORE_SPACE  # Don't save when prefixed with space
setopt HIST_IGNORE_DUPS   # Don't save duplicate lines
setopt SHARE_HISTORY      # Share history between sessions

export FZF_BASE="/home/${USER}/bin"

if [ -f "${FZF_BASE}/key-bindings.zsh" ];then
  source "${FZF_BASE}/key-bindings.zsh"
fi
export FZF_DEFAULT_COMMAND='fdfind --type f --color=never'

# Show fzf in fullscreen
export FZF_DEFAULT_OPTS="--height=100% --border=rounded --reverse"

# CTRL + T: call the fzf in current folder
# with a preview by bat
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :50 {}'"

# ALT + C: call the fzf in current folder
# with a tree preview
export FZF_ALT_C_COMMAND="fdfind --type d . --color=never"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -n 50'"

# set default editor to vim
export EDITOR=vim

export TERM="tmux-256color"

# variáveis para colorir manpages
export LESS_TERMCAP_mb=${bold_green}
export LESS_TERMCAP_md=${bold_green}
export LESS_TERMCAP_me=${text_reset}
export LESS_TERMCAP_se=${text_reset}
export LESS_TERMCAP_so=${bold_yellow}
export LESS_TERMCAP_ue=${text_reset}
export LESS_TERMCAP_us=${bold_red}

if [ -f "${HOME}/.atuin/bin/env" ];then
  source "${HOME}/.atuin/bin/env"
fi
if which atuin > /dev/null 2>&1 ;then
  eval "$(atuin init zsh --disable-up-arrow)"
fi

if which zoxide > /dev/null 2>&1 ;then
  eval "$(zoxide init zsh)"
fi


################ OH-MY-ZSH Configurations
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

DISABLE_AUTO_TITLE="true"

plugins=(
    zsh-syntax-highlighting
    zsh-autosuggestions
   )

source $ZSH/oh-my-zsh.sh


export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"

################ SSH Configurations
# carregando o agent ssh, e adicionando as chaves
if ! ps aux | grep "ssh-agent -s" | grep -v grep > /dev/null;then
    eval "$(ssh-agent -s)" > /dev/null
fi


# procure tudo que não for:
# - com o nome de "config"
# - com o nome de "known_hosts"
# - com o nome de "authorized_keys"
# - com o nome de "com formato"
# Ou seja, procure todas as chaves privadas dentro do diretório do ssh
ssh_private_keys=($(find ~/.ssh -type f ! -iname "config" ! -iname "known_hosts" ! -iname "authorized_keys" ! -name "*.*"))

for private_key in $ssh_private_keys; do
    ssh-add "$private_key" > /dev/null 2>&1
done