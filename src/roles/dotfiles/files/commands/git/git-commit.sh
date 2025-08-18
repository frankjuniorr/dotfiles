#!/bin/env bash

set -e

source ${HOME}/.bin/__utils.sh

# undo commit, and files back to the 'stage area'
undo() {
  git reset --soft HEAD^
}

# Add the current modifications in git status to the last commit (HEAD), and force push.
amend() {
  git add . && git commit --amend --no-edit && git push --force-with-lease
}

# Create a new commit interactively
new() {

  __is_cmd_installed gum

  # Verifica se há modificações no "git status".
  # - ! git diff --quiet : Verifica se há modificações "not staged"
  # - ! git diff --cached --quiet : Verifica se há modificações "staged"
  if ! git diff --quiet || ! git diff --cached --quiet; then
    local commit_title=$(gum input --cursor.foreground=2 --no-show-help --placeholder="Type the commit message")
    local commit_body=$(gum write --cursor.foreground=2 --no-show-help --placeholder="Type the commit description")
    local current_branch=$(git branch --show-current)

    test -z "$commit_title" && echo "The commit title cannot be empty" && return 1

    if [ -z "$commit_body" ]; then
      git commit -a -m \""$commit_title"\"
    else
      git commit -a -m \""$commit_title"\" -m \""$commit_body"\"
    fi
    git push -u origin "$current_branch"
  else
    echo "Nothing to commit"
    return 0
  fi
}

# Function to squash multiple commits into a single one.
# You pass the number as a parameter, like this:
# git_squash_commits 5: It will consider the last 5 commits to squash.
squash() {
  local amount_commits="$1"

  if [ -n "$amount_commits" ]; then
    current_branch=$(git branch | grep "^*" | awk '{print $2}')
    git rebase -i HEAD~$amount_commits
    git push origin +${current_branch}
  else
    echo "type the amount of commits"
    return 1
  fi
}

# Function to squash multiple commits into a single one.
# It uses the number of times the last commit message was repeated.
squash_equals() {
  local last_repeated_commit_count
  last_repeated_commit_count=$(git log --format=%s -n 20 | uniq -c | head -n 1 | awk '{print $1}')

  echo current_branch="$(git branch --show-current)"
  echo "$last_repeated_commit_count"

  git rebase -i HEAD~"${last_repeated_commit_count}"
  git push origin +"${current_branch}"
}

# --------------------------------------------------------------------------------------
# MAIN
# --------------------------------------------------------------------------------------

# Menu
options=("Undo" "New" "Amend" "Squash" "Squash equals")
result=$(printf "%s\n" "${options[@]}" | fzf \
  --ansi \
  --prompt="Git Commit: " \
  --height=20%)

case "$result" in
"Undo")
  undo
  ;;
"New")
  new
  ;;
"Amend")
  amend
  ;;
"Squash")
  squash
  ;;
"Squash equals")
  squash_equals
  ;;
esac
