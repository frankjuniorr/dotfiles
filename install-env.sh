#!/usr/bin/env bash
set -e

IMAGE="ghcr.io/frankjuniorr/dotfiles-env:latest"
COMPOSE_URL="https://raw.githubusercontent.com/frankjuniorr/dotfiles/main/docker-compose.yml"
ENV_DIR="${HOME}/.frank-env"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()    { echo -e "${GREEN}[frank-env]${NC} $*"; }
warn()    { echo -e "${YELLOW}[frank-env]${NC} $*"; }
error()   { echo -e "${RED}[frank-env]${NC} $*" >&2; exit 1; }

# Check dependencies
command -v docker >/dev/null 2>&1 || error "Docker is not installed. Install it from https://docs.docker.com/get-docker/"
command -v docker compose version >/dev/null 2>&1 || error "Docker Compose v2 is required. Update Docker Desktop or install the plugin."

info "Setting up frank-env in ${ENV_DIR}"
mkdir -p "${ENV_DIR}"

# Download docker-compose.yml
info "Downloading docker-compose.yml..."
curl -fsSL "${COMPOSE_URL}" -o "${ENV_DIR}/docker-compose.yml"

# Pull the image
info "Pulling ${IMAGE}..."
docker pull "${IMAGE}"

# Start container
info "Starting frank-env container..."
cd "${ENV_DIR}" && docker compose up -d

# Offer to add shell alias
echo
warn "Add the following alias to your shell for quick access:"
echo
echo "  alias fe='docker exec -it frank-env tmux new-session -As main'"
echo
read -r -p "Add 'fe' alias to your shell profile now? [y/N] " reply
if [[ "${reply}" =~ ^[Yy]$ ]]; then
    PROFILE="${HOME}/.zshrc"
    [[ -n "${BASH_VERSION}" ]] && PROFILE="${HOME}/.bashrc"

    if grep -q "alias fe=" "${PROFILE}" 2>/dev/null; then
        warn "Alias already exists in ${PROFILE}"
    else
        echo "alias fe='docker exec -it frank-env tmux new-session -As main'" >> "${PROFILE}"
        info "Alias added to ${PROFILE}. Run 'source ${PROFILE}' or open a new terminal."
    fi
fi

echo
info "Done! Enter your environment with:"
echo "  docker exec -it frank-env tmux new-session -As main"
