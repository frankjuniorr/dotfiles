#!/usr/bin/env bash

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

upgrade() {
  if (command -v flow >/dev/null); then
    echo "Upgrading flow..."
  else
    echo "Installing flow..."
  fi

  curl -sSL https://raw.githubusercontent.com/jahvon/flow/main/scripts/install.sh | bash
}

version() {
  flow --version
}

config() {
  bat ~/.config/flow/config.yaml
}

# --------------------------------------------------------------------------------------
# MAIN
# --------------------------------------------------------------------------------------

# Menu
options=(
  "📂 Projects"
  "📱 Apps"
  "📜 Logs"
  "⬆️ Upgrade"
  "ℹ️ Version"
  "⚙️ Config"
)
result=$(
  printf "%s\n" "${options[@]}" | fzf \
    --header="$(figlet Flow)" \
    --ansi \
    --prompt="⚡ Flow: " \
    --height=20%
)

case "$result" in
"📂 Projects") projects ;;
"📱 Apps") echo "empty" ;;
"📜 Logs") logs ;;
"⬆️ Upgrade") upgrade ;;
"ℹ️ Version") version ;;
"⚙️ Config") config ;;
esac
