#!/bin/env bash

set -e

source ${HOME}/.bin/__utils.sh

# Faz o `git fetch` com o spinner do `gum`
fetch() {
  gum spin \
    --spinner.foreground=3 \
    --spinner dot \
    --title "Fetching repository..." \
    -- git fetch --prune
}

# Alias para quando eu quero dar um 'git pull', levando em conta
# APENAS o que tem no repositório.
# útil, pra quando eu faço um Amend em um commit, e quero dar um 'git pull' depois
force_pull() {
  current_branch=$(git branch | grep "^*" | awk '{print $2}')
  git fetch origin
  git reset --hard origin/${current_branch}
}

# Faz clone de um repositório git a partir da URL, e entra na pasta
clone() {

  __is_cmd_installed gum

  local repository_name="$1"
  if [ -z "$repository_name" ]; then
    local repository_name=$(gum input --no-show-help --placeholder="Digite a URL do repositório")
  fi

  local repository_folder=$(basename "$repository_name" ".git")
  git clone "$repository_name"
  cd "$repository_folder"
  ls
}

# pega o nome do repositório do git
repository_name() {
  git config --get --local remote.origin.url
}

# abre o repositório no browser
repository_web() {
  local repository_url=$(g-repository-name)
  repository_url=$(echo "$repository_url" | sed 's/gitlab@//g' | sed 's/git@//g' | sed 's/.git//g' | sed 's|:|/|g')
  google-chrome-stable "$repository_url"
}

# --------------------------------------------------------------------------------------
# MAIN
# --------------------------------------------------------------------------------------

# Menu
options=("Github Create" "Fetch" "Force pull" "Clone" "Repo name" "Repo web")
result=$(printf "%s\n" "${options[@]}" | fzf \
  --ansi \
  --prompt="Git Repository: " \
  --height=20%)

case "$result" in
"Github Create")
  bash ~/.bin/git/__gh-create.sh
  ;;
"Fetch")
  fetch
  ;;
"Force pull")
  force_pull
  ;;
"Clone")
  clone
  ;;
"Repo name")
  repository_name
  ;;
"Repo web")
  repository_web
  ;;
esac
