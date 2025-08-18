#!/bin/env bash

set -e

source ${HOME}/.bin/__utils.sh

branch_switch() {

  __is_cmd_installed fzf

  # Atualiza a referências do repositório
  git fetch --prune

  # Get local branches and format with green color
  local local_branches=$(git branch --format='%(refname:short) %(committerdate:relative)' | grep -v HEAD)
  local formatted_local=$(echo "$local_branches" | sed -E "s/^([^ ]+)(.*)/${color_green}\1${color_reset}${color_blue}\2${color_reset}/")

  # Get remote branches and format with red color for names and blue for dates
  local remote_branches=$(git branch -r --format='%(refname:short) %(committerdate:relative)' | grep -v HEAD | grep "^origin/")
  local formatted_remote=$(echo "$remote_branches" | sed -E "s/^([^ ]+)(.*)/${color_red}\1${color_reset}${color_blue}\2${color_reset}/")

  # Combine the lists
  all_branches=$(echo -e "${formatted_local}\n${formatted_remote}" | grep -v "^$")

  # Select branch with FZF
  branch=$(
    echo "$all_branches" |
      fzf --ansi --no-sort --height 40% --reverse --border rounded \
        --preview 'branch_name=$(echo {} | sed -E "s/^[^a-zA-Z0-9_\/\-]*(([a-zA-Z0-9_\/\-]+)( .*)?)/\2/"); git log --oneline --date=short --color --pretty="format:%C(auto)%cd %h%d %s" $branch_name | head -n 20' \
        --preview-window right:60% \
        --prompt "Switch to branch: " |
      sed -E 's/^[[:space:]]*([^ ]+).*/\1/' | # Extract just the branch name
      sed -E 's/^origin\///'                  # Remove origin/ prefix if present
  )

  # Exit if no branch was selected
  if [ -z "$branch" ]; then
    echo "No branch selected. Exiting."
    return 0
  fi

  git checkout "$branch"
}

# Deleta todas as branches locais, deixando só a current branch
branches_clean() {
  local branches=$(git branch | grep -v '^\*' | awk '{print $1}')

  if [ -n "$branches" ]; then
    echo "🧹 Apagando branches locais:"
    echo "$branches" | xargs -n1 git branch -D
  fi

  echo "🔄 Limpando referências remotas obsoletas..."
  git fetch --prune
}

# Usado para checkar se a minha branch corrente, existe no repositório ou não
branch_check() {

  __is_cmd_installed gum

  local current_branch=$(git branch --show-current)

  git fetch --prune

  if git branch -r | grep -q "origin/${current_branch}"; then
    echo "This branch $current_branch exists in the repository"
  else
    echo "This branch $current_branch doens't exists in the repository"
    if gum confirm \
      --prompt.foreground=2 \
      --selected.background=2 \
      --no-show-help \
      "Clean up local branches?"; then
      g-branch-default && g-branch-clean
    fi
  fi
}

# Volta para o default branch
branch_default() {
  local default_branch=$(git rev-parse --abbrev-ref origin/HEAD | cut -d '/' -f2)
  git checkout "$default_branch"
  git fetch --prune
  git pull
}

# Cria uma nova branch de maneira interativa
branch_new() {

  __is_cmd_installed fzf

  # faz o fetch pra atualizar as referências do repositório
  git fetch --prune

  local branch_src
  local branch_new
  local commit_title
  local commit_body
  local remote_branches

  local default_branch=$(git rev-parse --abbrev-ref origin/HEAD | cut -d '/' -f2)

  # Menu: branch de origem
  local options=("Default (${default_branch})" "other")
  local branch_selected=$(printf "%s\n" "${options[@]}" | fzf \
    --prompt="Select a source branch: " \
    --height=20%)

  if [ "$branch_selected" != "other" ]; then
    branch_src="$default_branch"
  else
    remote_branches=$(git branch -r | grep -v "origin/HEAD" | sed "s/^ *//g" | sed "s|origin/||g" | fzf \
      --prompt="Select a source branch: " \
      --height=20%)
    branch_src="$remote_branches"
  fi

  branch_new=$(gum input --cursor.foreground=2 --no-show-help --placeholder="Type the new branch name")

  git checkout "$branch_src"
  git pull
  git checkout -b "$branch_new"

  # Verifica se há modificações no "git status".
  # - ! git diff --quiet : Verifica se há modificações "not staged"
  # - ! git diff --cached --quiet : Verifica se há modificações "staged"
  if ! git diff --quiet || ! git diff --cached --quiet; then
    commit_title=$(gum input --cursor.foreground=2 --no-show-help --placeholder="Type commit message")
    commit_body=$(gum write --cursor.foreground=2 --no-show-help --placeholder="Type commit description")

    test -z "$commit_title" && echo "The commit cannot be empty" && return 1

    if [ -z "$commit_body" ]; then
      git commit -a -m \""$commit_title"\"
    else
      git commit -a -m \""$commit_title"\" -m \""$commit_body"\"
    fi

    # TODO: usar o 'gum confirm' para perguntar, se quer abrir um MR ou não.
    # caso sim:
    #   - criar um menu fixo no fzf, com os username dos "assign" do MR.
    #   - usar o `glab` para criar o MR
    # caso não:
    # encerra o comando
  fi

  git push origin -u "$branch_new"
}

# --------------------------------------------------------------------------------------
# MAIN
# --------------------------------------------------------------------------------------

# Menu
options=("Switch" "New" "Check" "Default" "Clean")
result=$(printf "%s\n" "${options[@]}" | fzf \
  --ansi \
  --prompt="Git Branch: " \
  --height=20%)

case "$result" in
"Switch") branch_switch ;;
"New") branch_new ;;
"Check") branch_check ;;
"Default") branch_default ;;
"Clean") branches_clean ;;
esac
