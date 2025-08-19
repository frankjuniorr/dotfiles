#!/bin/env bash

set -e

source ${HOME}/.bin/__utils.sh

# Função que cria uma nova branch local, a partir deu uma tag no git
new_branch_from_tag() {
  local tag="$1"

  test -z "$tag" && echo "digite o nome da tag por parametro" && return 1

  git checkout -b "$tag" "$tag"
}

# Função para renomear uma tag no git
rename() {
  local old_tag="$1"
  local new_tag="$2"

  #TODO: Remover essas validações, e adicionar um menu no 'fzf' para as tags existentes
  # Depois, usa um 'gum input' para digitar o nome da tag nova
  test -z "$old_tag" && echo "digite a tag antiga no 1º parametro" && return 1
  test -z "$new_tag" && echo "digite a tag nova no 2º parametro" && return 1

  if git rev-parse --is-inside-work-tree >/dev/null; then
    git tag "$new_tag" "$old_tag"
    git tag -d "$old_tag"
    git push origin ":refs/tags/${old_tag}"
    git push --tags
  else
    echo "ERROR: This folder is not a git repository"
    return 1
  fi
}

# --------------------------------------------------------------------------------------
# MAIN
# --------------------------------------------------------------------------------------

# Menu
options=(
  "🌿 New branch from Tag"
  "✏️ Rename"
)
result=$(printf "%s\n" "${options[@]}" | fzf \
  --header="$(figlet Git Tag)" \
  --ansi \
  --prompt="⚡ Git Tags: " \
  --height=20%)

case "$result" in
"🌿 New branch from Tag") new_branch_from_tag ;;
"✏️ Rename") rename ;;
esac
