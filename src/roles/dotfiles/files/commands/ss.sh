#!/usr/bin/env bash

# -----------------------------
# Validar dependências
# -----------------------------
for cmd in rg fzf nvim; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "❌ Missing dependency: $cmd"
    return 1
  fi
done

# -----------------------------
# Defaults
# -----------------------------
local query=""
local base_dir="."

# -----------------------------
# Help
# -----------------------------
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  cat <<EOF
🔎 ss - Search String (ripgrep + fzf + nvim)

Usage:
  ss <pattern>
  ss <pattern> [path]

Examples:
  ss "TODO"
  ss "function.*user" .
  ss "error" ~/projects

Notes:
  • Usa ripgrep (rg)
  • Preview com contexto
  • Abre no neovim na linha
EOF
  return 0
fi

# -----------------------------
# Parse args
# -----------------------------
if [[ $# -lt 1 ]]; then
  echo "❌ You must provide a search pattern"
  return 1
fi

query="$1"
shift

if [[ -n "$1" ]]; then
  base_dir="$1"
fi

if [[ ! -d "$base_dir" ]]; then
  echo "❌ Invalid directory: $base_dir"
  return 1
fi

# -----------------------------
# RG base
# -----------------------------
# formato: file:line:column:text
RG_CMD="rg --column --line-number --no-heading --color=always --smart-case \"$query\" \"$base_dir\""

# -----------------------------
# FZF
# -----------------------------
selected=$(
  eval "$RG_CMD" | fzf \
    --ansi \
    --height 80% \
    --layout=reverse \
    --border \
    --prompt="🔎 Search > " \
    --header="ENTER open in nvim • CTRL-C cancel" \
    --delimiter ":" \
    --preview '
      file=$(echo {} | cut -d: -f1)
      line=$(echo {} | cut -d: -f2)
      bat --style=numbers --color=always --highlight-line $line $file 2>/dev/null
    ' \
    --preview-window="right:60%"
)

# -----------------------------
# Ação
# -----------------------------
if [[ -z "$selected" ]]; then
  echo "⚠️ No match selected"
  return 0
fi

file=$(echo "$selected" | cut -d: -f1)
line=$(echo "$selected" | cut -d: -f2)

nvim +"$line" "$file"
