#!/usr/bin/env bash
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BOLD='\033[1m'
NC='\033[0m'

PASS=0
FAIL=0

# ── Context detection ────────────────────────────────────────────────────────
# Inside a Docker container: run tools directly.
# Outside: run via `docker run` against the given image.
if [ -f /.dockerenv ]; then
    CONTEXT="inside container"
    run_cmd() { bash -c "$1" > /dev/null 2>&1; }
else
    IMAGE="${1:?Usage: smoke-test.sh <image-name>  (or run inside the container without args)}"
    CONTEXT="docker image: ${IMAGE}"
    # Source zshenv (sets ZDOTDIR) + .zshrc (sets PATH) without -i so it works without a TTY (CI)
    run_cmd() { docker run --rm --entrypoint zsh "$IMAGE" -c ". /etc/zsh/zshenv 2>/dev/null; . \${ZDOTDIR:-\$HOME}/.zshrc 2>/dev/null; $1" > /dev/null 2>&1; }
fi

# ── Check helper ─────────────────────────────────────────────────────────────
check() {
    local name="$1" cmd="$2"
    if run_cmd "$cmd"; then
        echo -e "  ${GREEN}✓${NC} ${name}"
        ((PASS++)) || true
    else
        echo -e "  ${RED}✗${NC} ${name}"
        ((FAIL++)) || true
    fi
}

# ── Tests ────────────────────────────────────────────────────────────────────
echo
echo -e "${BOLD}Smoke test — ${CONTEXT}${NC}"
echo "─────────────────────────────"

echo "Shell & terminal"
check "zsh"            "zsh --version"
check "tmux"           "tmux -V"
check "tmuxinator"     "tmuxinator version"
check "starship"       "starship --version"

echo "CLI tools"
check "bat"            "bat --version"
check "fd"             "fd --version"
check "fzf"            "fzf --version"
check "zoxide"         "zoxide --version"
check "eza"            "eza --version"
check "btop"           "command -v btop"
check "just"           "just --version"
check "atuin"          "atuin --version"
check "navi"           "navi --version"
check "yazi"           "yazi --version"
check "glow"           "glow --version"
check "ripgrep"        "rg --version"
check "sesh"           "sesh version"
check "onefetch"       "onefetch --version"

echo "System tools"
check "jq"             "jq --version"
check "yq"             "yq --version"
check "gum"            "gum --version"
check "duf"            "duf --version"
check "ncdu"           "ncdu --version"
check "sshs"           "sshs --version"

echo "Git"
check "git"            "git --version"
check "lazygit"        "lazygit --version"
check "git-delta"      "delta --version"
check "gh"             "gh --version"

echo "Editor"
check "neovim"         "nvim --version"

echo "DevOps"
check "docker CLI"     "docker --version"
check "lazydocker"     "lazydocker --version"
check "kubectl"        "kubectl version --client"
check "kubecolor"      "command -v kubecolor"
check "helm"           "helm version --short"
check "k9s"            "k9s version"
check "go"             "go version"
check "cobra-cli"      "command -v cobra-cli"
check "tfenv"          "tfenv --version"

echo "Dotfiles"
check "aliases symlink"   "test -L ~/.config/dotfiles/alias.sh"
check "functions symlink" "test -L ~/.config/dotfiles/functions.sh"
check "env symlink"       "test -L ~/.config/dotfiles/env.sh"

# ── Summary ──────────────────────────────────────────────────────────────────
echo "─────────────────────────────"
echo -e "${BOLD}Results: ${GREEN}${PASS} passed${NC}${BOLD}, ${RED}${FAIL} failed${NC}"
echo

[ "$FAIL" -eq 0 ]
