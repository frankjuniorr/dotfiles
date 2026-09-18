#!/usr/bin/env bash

ensure_plugin_on() {
  if command -v just >/dev/null 2>&1; then
    just plugin on
  else
    sed -i '/^# *stdout_callback = beautiful_output/s/^# *//' src/ansible.cfg
    echo "Plugin 'beautiful_output' ATIVADO via fallback (sed)."
  fi
}

add_git_files() {
  FILES=$(git diff --cached --name-only --diff-filter=ACMR)
  if [ -n "$FILES" ]; then
    git add $FILES
  fi
}

ensure_scripts_executable() {
  chmod +x scripts/*.sh
  chmod +x bin/*
  chmod +x .git/hooks/pre-commit
  chmod +x src/roles/dotfiles/files/commands/*
}

ensure_scripts_executable
ensure_plugin_on
add_git_files

exit 0
