#!/usr/bin/env bash

# -----------------------------
# Validar dependências
# -----------------------------
for cmd in fd fzf bat nvim; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "❌ Missing dependency: $cmd"
    return 1
  fi
done

# -----------------------------
# Defaults
# -----------------------------
local query=""
local show_hidden=false
local summary_mode=false
local base_dir="."
local max_depth=7

# -----------------------------
# Help
# -----------------------------
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  cat <<EOF
🔍 ff - Find Files (fd + fzf + bat + nvim)

Usage:
  ff <pattern>
  ff <pattern> --hidden
  ff <pattern> --summary

Examples:
  ff "*.txt"
  ff "*.js" --hidden
  ff "*.log" --summary

Notes:
  • Usa fd recursivo
  • Preview com bat
  • Abre no neovim
EOF
  return 0
fi

# -----------------------------
# Parse args
# -----------------------------
while [[ $# -gt 0 ]]; do
  case "$1" in
  --hidden)
    show_hidden=true
    shift
    ;;
  --summary)
    summary_mode=true
    shift
    ;;
  *)
    query="$1"
    shift
    ;;
  esac
done

# se não passar query, busca tudo
if [[ -z "$query" ]]; then
  query="*"
fi

# -----------------------------
# FD base
# -----------------------------
fd_cmd=(fd --type f --glob "$query" "$base_dir" \
  --max-depth "$max_depth" \
  --exclude node_modules \
  --exclude .git \
  --prune)

if $show_hidden; then
  fd_cmd+=(--hidden)
fi

# -----------------------------
# SUMMARY MODE
# -----------------------------
if $summary_mode; then
  files=()
  while IFS= read -r line; do
    files+=("$line")
  done < <("${fd_cmd[@]}")

  local total_files=${#files[@]}

  if [[ $total_files -eq 0 ]]; then
    echo "⚠️ No files found"
    return 0
  fi

  local total_size=0
  declare -A ext_count

  for f in "${files[@]}"; do
    size=$(stat -c%s "$f" 2>/dev/null || stat -f%z "$f")
    total_size=$((total_size + size))

    ext="${f##*.}"
    [[ "$f" == "$ext" ]] && ext="no_ext"

    ((ext_count["$ext"]++))
  done

  echo "📊 Summary"
  echo "-------------------------"
  echo "📁 Total files: $total_files"
  echo "💾 Total size: $(numfmt --to=iec "$total_size" 2>/dev/null || echo "$total_size bytes")"
  echo ""
  echo "📦 Extensions:"

for ext in "${(@k)ext_count}"; do
  echo "  .$ext → ${ext_count[$ext]}"
done | sort -k3 -nr

  return 0
fi

# -----------------------------
# FZF UI
# -----------------------------
preview_cmd='bat --style=numbers --color=always --line-range :300 {}'

selected=$(
  "${fd_cmd[@]}" | fzf \
    --height 80% \
    --layout=reverse \
    --border \
    --ansi \
    --prompt="🔍 Find file > " \
    --header="ENTER open in nvim • CTRL-C cancel" \
    --preview="$preview_cmd" \
    --preview-window="right:60%"
)

# -----------------------------
# Ação
# -----------------------------
if [[ -z "$selected" ]]; then
  echo "⚠️ No file selected"
  return 0
fi

nvim "$selected"
