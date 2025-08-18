#!/bin/env bash

set -e

source ${HOME}/.bin/__utils.sh

# --------------------------------------------------------------------------------------
# MAIN
# --------------------------------------------------------------------------------------

# Menu
options=("By name" "By email" "Last commit")
result=$(printf "%s\n" "${options[@]}" | fzf \
  --ansi \
  --prompt="Show git Log: " \
  --height=20%)

log_by_name() {
  git log -n 20 --oneline --date=short --pretty=format:"%Cgreen%h%Creset %Cred%ad%Creset %Cblue% %aN%Creset %s"
}

log_by_email() {
  git log -n 20 --oneline --date=short --pretty=format:"%Cgreen%h%Creset %Cred%ad%Creset %Cblue% %ae%Creset %s"
}

last_commit() {
  git log -1 --pretty=%s
}

case "$result" in
"By name") log_by_name ;;
"By email") log_by_email ;;
"Last commit") last_commit ;;
esac
