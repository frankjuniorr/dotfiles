#!/bin/bash

# -----------------------------
# Validar dependências
# -----------------------------
for cmd in fd fzf zoxide; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "❌ Missing dependency: $cmd"
    return 1
  fi
done

# -----------------------------
# Defaults
# -----------------------------
local base_dir="."
local use_zoxide=false
local show_hidden=false
local max_depth=5

# -----------------------------
# Help
# -----------------------------
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  cat <<EOF
📁 cf - Change Folder (fzf + fd + zoxide)

Usage:
  cf [path]
  cf -z, --zoxide
  cf --hidden
  cf -h, --help

Examples:
  cf
  cf ~/projects
  cf --hidden
  cf -z

Notes:
  • Ignores: node_modules, .git
  • Adds selected folder to zoxide
  • Uses 'cx' if available
EOF
  return 0
fi

# -----------------------------
# Parse args
# -----------------------------
while [[ $# -gt 0 ]]; do
  case "$1" in
  -z | --zoxide)
    use_zoxide=true
    shift
    ;;
  --hidden)
    show_hidden=true
    shift
    ;;
  *)
    base_dir="$1"
    shift
    ;;
  esac
done

# -----------------------------
# FZF UI
# -----------------------------
local preview_cmd='lsd --color always --tree --depth 2 {} 2>/dev/null || tree -L 2 {}'

local fzf_opts=(
  --height 80%
  --layout=reverse
  --cycle
  --border
  --ansi
  --prompt="📁 Select folder > "
  --preview="$preview_cmd"
  --preview-window="right:60%"
)

local selected

# -----------------------------
# Zoxide mode
# -----------------------------
if $use_zoxide; then
  selected=$(
    zoxide query -l | fzf "${fzf_opts[@]}" \
      --header="📦 Zoxide • ENTER open • CTRL-C cancel"
  )

else
  if [[ ! -d "$base_dir" ]]; then
    echo "❌ Invalid directory: $base_dir"
    return 1
  fi

  fd_cmd=(
    fd
    --type d
    "$base_dir"
    --max-depth "$max_depth"
    --exclude node_modules
    --exclude .git
  )

  if $show_hidden; then
    fd_cmd+=(--hidden)
  fi

  selected=$(
    "${fd_cmd[@]}" | fzf "${fzf_opts[@]}" \
      --header="📁 Browsing: $base_dir • ENTER open"
  )
fi

# -----------------------------
# Pós seleção
# -----------------------------
if [[ -z "$selected" ]]; then
  echo "⚠️ No folder selected"
  return 0
fi

if command -v cx >/dev/null 2>&1; then
  cx "$selected"
else
  cd "$selected" || return
  ls
fi
