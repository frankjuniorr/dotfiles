#!/bin/env bash

set -e

source ${HOME}/.bin/__utils.sh

projects() {
  selected_project=$(flow workspace list -o json |
    jq -r '.workspaces[] | select(.tags[] == "projects") | .displayName' |
    fzf --ansi --prompt="Select a Project: " --height=20%)

  flow browse --workspace="$selected_project"
}

logs() {
  flow logs
}

# --------------------------------------------------------------------------------------
# MAIN
# --------------------------------------------------------------------------------------

# Menu
options=("Projects" "Apps" "Logs")
result=$(printf "%s\n" "${options[@]}" | fzf \
  --ansi \
  --prompt="Flow: " \
  --height=20%)

case "$result" in
"Projects") projects ;;
"Apps") echo "empty" ;;
"Logs") logs ;;
esac
