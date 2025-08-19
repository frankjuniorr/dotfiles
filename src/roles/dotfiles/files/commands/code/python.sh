#!/bin/env bash

set -e

source ${HOME}/.bin/__utils.sh

# ----------------------------------------------------------------------
# alias rápido que habilita um venv padrão no python
enable_venv() {

  os_name=$(grep "^NAME=" /etc/os-release | cut -d '=' -f2 | sed 's/"//g')

  case $os_name in
  "Ubuntu")
    if ! dpkg -s python3-venv >/dev/null 2>&1; then
      echo "⚠️  Package 'python3-venv' is not installed."
      echo "   Install it with:"
      echo "   sudo apt install python3-venv"
      return 1
    fi
    ;;
  "Arch Linux")
    if ! pacman -Qi python-virtualenv >/dev/null 2>&1; then
      echo "⚠️  Package 'python-virtualenv' is not installed."
      echo "   Install it with:"
      echo "   sudo pacman -S python-virtualenv"
      return 1
    fi
    ;;
  esac

  python3 -m venv .venv
  source venv/bin/activate
}

# ----------------------------------------------------------------------
# alias rápido que desabilita um venv no python
disable_venv() {
  deactivate
}

shell() {
  python3
}

zen() {
  python3 -c "import this"
}

# --------------------------------------------------------------------------------------
# MAIN
# --------------------------------------------------------------------------------------

# Menu
options=("Enable venv" "Disable venv" "Shell" "Zen")
result=$(printf "%s\n" "${options[@]}" | fzf \
  --ansi \
  --prompt="Python: " \
  --height=20%)

case "$result" in
"Enable venv") enable_venv ;;
"Disable venv") disable_venv ;;
"Shell") shell ;;
"Zen") zen ;;
esac
