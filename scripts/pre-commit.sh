#!/usr/bin/env bash

check_encrypt_vault_file() {
  VAULT_FILE="src/group_vars/all/vault.yml"

  if [ -f "$VAULT_FILE" ]; then
    if git show :"$VAULT_FILE" | grep -q "\$ANSIBLE_VAULT"; then
      return 0
    else
      echo "⚠️  $VAULT_FILE is not encrypted. Encrypting automatically..."
      just secrets-encrypt
      git add "$VAULT_FILE"
      echo "✅ $VAULT_FILE encrypted and re-staged."
    fi
  fi
}

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
}

ensure_scripts_executable
check_encrypt_vault_file
ensure_plugin_on
add_git_files

exit 0
