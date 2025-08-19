#!/bin/env bash

set -e

source ${HOME}/.bin/__utils.sh

# desfaz as modificações do `git status` de "staged" e "not staged". Mantém os "Untracked Files" caso tenha
status_clean() {
  git reset --hard
}

# remove all untracked files, is case of you want to clean in repo.
remove_untracked() {
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    rm -rf $(git ls-files --others --exclude-standard | xargs)
  else
    echo "This is not a git repository"
    return 1
  fi
}

# --------------------------------------------------------------------------------------
# MAIN
# --------------------------------------------------------------------------------------

# Menu
options=(
  "🗑️ Remove untracked"
  "🧹 Clean"
)
result=$(printf "%s\n" "${options[@]}" | fzf \
  --header="$(figlet Git Status)" \
  --ansi \
  --prompt="⚡ Git Status: " \
  --height=20%)

case "$result" in
"🗑️ Remove untracked") remove_untracked ;;
"🧹 Clean") status_clean ;;
esac
