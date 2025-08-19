#!/bin/bash

# yazi: recommended by docs: https://yazi-rs.github.io/docs/quick-start#shell-wrapper
# ----------------------------------------------------------------------
y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# ----------------------------------------------------------------------
matrix() {
  if [ -n "$WAYLAND_DISPLAY" ] && command -v unimatrix >/dev/null 2>&1; then
    unimatrix -b -s 80
  elif [ -n "$DISPLAY" ] && command -v cmatrix >/dev/null 2>&1; then
    cmatrix -b -s -u 6
  else
    echo "Nenhum comando de Matrix disponível (unimatrix ou cmatrix)." >&2
    return 1
  fi
}

# Função para copiar pro clipboard
# ----------------------------------------------------------------------
copy() {
  if [ -n "$WAYLAND_DISPLAY" ] && command -v wl-copy >/dev/null 2>&1; then
    wl-copy
  elif [ -n "$DISPLAY" ] && command -v xclip >/dev/null 2>&1; then
    xclip -selection clipboard
  else
    echo "Nenhuma ferramenta de clipboard disponível (wl-copy ou xclip)." >&2
    return 1
  fi
}

# Função para colar do clipboard
# ----------------------------------------------------------------------
paste() {
  if [ -n "$WAYLAND_DISPLAY" ] && command -v wl-paste >/dev/null 2>&1; then
    wl-paste
  elif [ -n "$DISPLAY" ] && command -v xclip >/dev/null 2>&1; then
    xclip -selection clipboard -o
  else
    echo "Nenhuma ferramenta de clipboard disponível (wl-paste ou xclip)." >&2
    return 1
  fi
}

# funcção que imrpime o conteúdo de um alias ou função no terminal.
# ----------------------------------------------------------------------
alias-show() {
  my_alias=$(echo "$1" | sed 's/()//g' | sed 's/alias //g')

  # validação
  if [ -z "$my_alias" ]; then
    echo "Digite um alias ou function no 1º paramêtro"
    return 0

  fi

  # verifique se é um alias
  if type "$my_alias" | grep -q "is an alias"; then
    type "$my_alias" | cut -d " " -f6- | bat --color=always -l bash --file-name="alias"
  # verifique se é uma function
  elif type "$my_alias" | grep -q "is a shell function"; then
    declare -f "$my_alias" | bat --color=always -l bash --file-name="function"
  else
    echo "alias ou function não encontrado"
    return 1
  fi
}

# ----------------------------------------------------------------------
alias-list() {
  local dotfiles_path="${HOME}/.config/dotfiles"

  local search_query='^alias [a-zA-Z_][a-zA-Z0-9_]*='

  grep -rE "$search_query" "${dotfiles_path}"/* >/tmp/list_alias.tmp

  alias-show "$(grep -E "$search_query" "${dotfiles_path}"/* |
    cut -d "=" -f1 |
    awk '{print $2}' |
    fzf --header-first --header="Alias" --layout reverse --preview '
      grep {}= /tmp/list_alias.tmp | cut -d ":" -f2 | sed "s/alias //g" | grep ^{}= | cut -d "=" -f2

    ')"

  rm -rf /tmp/list_alias.tmp
}

# ----------------------------------------------------------------------
alias-functions() {
  local dotfiles_path="${HOME}/.config/dotfiles"

  local search_query='^(function )?[a-zA-Z_]*\(\)'

  grep -E "$search_query" "${dotfiles_path}"/* | sed "s/ \?{//g" >/tmp/list_functions.tmp

  alias-show "$(grep --no-filename -E "$search_query" "${dotfiles_path}"/* |
    sed "s/function //g" | sed "s/ {//g" |
    fzf --header-first --header="Functions" --layout reverse --preview '
      filename=$(grep :{} /tmp/list_functions.tmp | cut -d ":" -f 1);
      function_name=$(grep :{} /tmp/list_functions.tmp | cut -d ":" -f 2);

      awk "/^(function )?$function_name\\(\\)/,/^}/" "$filename"
')"

}

# ----------------------------------------------------------------------
trash_clean() {
  echo "Limpando lixeira...."
  if [ -d "${HOME}/.local/share/Trash" ]; then
    rm -rfv ~/.local/share/Trash/*
  else
    echo "This folder ${HOME}/.local/share/Trash doens't exists"
  fi
  echo "Lixeira vazia!"
}

# alias pra recarregar o shell
# ----------------------------------------------------------------------
refresh_shell() {
  local shell_file=""

  if grep "$USER" "/etc/passwd" | grep -q bash; then
    shell_file="${HOME}/.bashrc"
  elif grep "$USER" "/etc/passwd" | grep -q zsh; then
    shell_file="${HOME}/.config/zsh/.zshrc"
  fi

  source "$shell_file" >/dev/null && echo "shell refreshed"
}

################################################################################
#  APT-GET ALIASES
################################################################################

# Função pra deletar os lock do apt-get.
# Usado principalmente, quando ele trava do nada.
# Além de reconfigurar o dpkg e resolver os pacotes quebrados
apt_get_fix() {
  test -f /var/lib/apt/lists/lock && sudo rm -rf /var/lib/apt/lists/lock
  test -f /var/cache/apt/archives/lock && sudo rm -rf /var/cache/apt/archives/lock
  test -f /var/lib/dpkg/lock && sudo rm -rf /var/lib/dpkg/lock
  test -f /var/lib/dpkg/lock-frontend && sudo rm -rf /var/lib/dpkg/lock-frontend

  sudo apt --fix-broken install
  sudo dpkg --configure -a
  echo "OK"
}
