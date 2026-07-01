FROM archlinux:base-devel

ARG UID=1000
ARG USER=frank

LABEL org.opencontainers.image.source="https://github.com/frankjuniorr/dotfiles"
LABEL org.opencontainers.image.description="Personal CLI environment — Frank's dotfiles"

# Initialize pacman keyring and create non-root user (required for AUR/makepkg)
RUN pacman-key --init && pacman-key --populate && \
    useradd -m -u ${UID} -G wheel -s /bin/zsh -l ${USER} && \
    echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Copy repo to the same path used by docker-compose volume mount
COPY --chown=${USER}:${USER} . /home/${USER}/.dotfiles/

USER ${USER}
WORKDIR /home/${USER}

# All provisioning in one layer so cleanup actually reduces image size
# --mount=type=secret exposes the vault password only during this RUN step;
# it is never written to any image layer and does not appear in docker history.
RUN --mount=type=secret,id=vault_pass,uid=1000,target=/run/secrets/vault_pass \
    set -eo pipefail && \
    # Install AUR helper — build from source (avoids yay-bin's GitHub binary download, which can 502)
    sudo pacman -Sy --noconfirm --needed git go && \
    git clone https://aur.archlinux.org/yay.git /tmp/yay && \
    (cd /tmp/yay && makepkg -si --noconfirm) && \
    rm -rf /tmp/yay && \
    \
    # Install Ansible and Galaxy dependencies
    sudo pacman -S --noconfirm --needed ansible && \
    ansible-galaxy collection install community.general && \
    ansible-galaxy install -r ~/.dotfiles/src/requirements/common.yml && \
    \
    # Run playbook — CLI roles only, no 1Password (vault.yml excluded via .dockerignore)
    cd ~/.dotfiles/src && \
    ANSIBLE_STDOUT_CALLBACK=default \
    ansible-playbook -i hosts.ini main.yml \
        --tags "cli" \
        --vault-password-file /run/secrets/vault_pass \
        -e '{"op_installed": false, "is_docker_build": true}' && \
    \
    # Remove Ansible and its galaxy collections (build-time only)
    sudo pacman -Rns --noconfirm ansible ansible-core python-resolvelib 2>/dev/null || true && \
    sudo rm -rf /usr/lib/python*/site-packages/ansible* \
                /usr/lib/python*/site-packages/ansible_collections && \
    \
    # Clear all caches
    yay -Scc --noconfirm && \
    sudo pacman -Scc --noconfirm && \
    go clean -cache 2>/dev/null || true && \
    sudo rm -rf /tmp/* /root/.ansible ~/.ansible \
                ~/.cache/pip ~/.cargo/registry 2>/dev/null || true

ENTRYPOINT ["/usr/bin/tmux", "new-session", "-As", "main"]
