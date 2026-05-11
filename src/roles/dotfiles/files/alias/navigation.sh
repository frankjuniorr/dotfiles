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

alias cat='bat'
alias cd='z'
cx() {
  cd "$@" && ls
}

mkx() {
  local folder_name="$1"

  if [ -z "$folder_name" ]; then
    folder_name=$(gum input \
      --cursor.foreground=2 \
      --no-show-help \
      --placeholder="Type the folder name")
  fi

  if [ ! -d "$folder_name" ]; then
    mkdir "$folder_name"
  fi
  cx "$folder_name"
}

# FZF commands
# ----------------------------------------------------------------------
# used only with STDIN, to preview any file list
# example: ls | file_preview
alias file_preview="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"
