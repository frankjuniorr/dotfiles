# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

Personal dotfiles manager for Arch Linux + Hyprland (HyDE) and Ubuntu 24.04 LTS + GNOME. Uses Ansible roles to install applications and symlink config files. Each role handles distribution-specific logic and may integrate with 1Password for secrets.

## Running Dotfiles

```bash
# Install all default roles (prompts for role via gum if no arg given)
bin/dotfiles

# Install a single role
bin/dotfiles "neovim"

# Or via environment variable
ROLE=tmux bin/dotfiles
```

The `bin/dotfiles` script auto-installs dependencies (`gum`, Ansible), detects the OS, and runs the Ansible playbook in `src/`. It uses `--vault-password-file ~/.config/homelab-iac/.vault_pass` — no `become` password prompt.

## Ansible Playbook Commands

Run these from the `src/` directory:

```bash
# Run a specific role directly
ansible-playbook main.yml --tags "neovim"

# Run all default roles
ansible-playbook main.yml

# Install Ansible Galaxy requirements first (if new collection needed)
ansible-galaxy install -r requirements/common.yml
```

## IAC (Proxmox)

```bash
# Interactive Proxmox deployment via Docker
just iac-proxmox
# or directly:
cd iac && bash iac-proxmox.sh
```

## Architecture

### Entry Point
`bin/dotfiles` → `src/main.yml` (Ansible playbook) → individual roles in `src/roles/`

### Role Structure
Every role follows the same pattern:
```
src/roles/<name>/
├── tasks/
│   ├── main.yaml          # Includes distro-specific task file
│   ├── Archlinux.yaml     # Tasks for Arch Linux
│   └── Ubuntu.yaml        # Tasks for Ubuntu
├── files/                 # Static config files to symlink
├── templates/             # Jinja2 templates (used for secrets via 1Password)
└── handlers/              # Service reload handlers
```

`tasks/main.yaml` in every role uses `ansible_distribution` to include `Archlinux.yaml` or `Ubuntu.yaml`.

### Key Variables (`src/group_vars/all/`)
`all.yaml` was split into two files — do not recreate `all.yaml`:
- `vars.yaml` — plain vars: `primary_installation_path`, `scripts_installation_path`, `default_roles`, `fonts_list`, `go.packages`
- `vault.yml` — Ansible-Vault encrypted secrets (always encrypted in git; managed via `just secrets-*`)

### Pre-tasks (`src/pre_tasks/`)
Two pre-tasks always run before roles:
1. `whoami.yaml` — captures current user into `host_user` fact
2. `detect_1password.yaml` — sets `op_installed` fact (controls whether 1Password-dependent tasks run)

### 1Password Integration
Roles that need secrets (git credentials, GitHub token, SSH keys) use the `op` CLI. They conditionally skip if `op_installed` is false. Templates like `private-env.sh.j2` and `git-credentials-personal.j2` read secrets at provision time.

### Symlinks Pattern
Roles symlink config files from `roles/<name>/files/` to the appropriate `~/.config/<tool>/` location. The neovim role removes and recreates the entire `~/.config/nvim/` directory on each run.

### Default Role Install Order
System base → CLI tools → terminal/shell (zsh, tmux) → DevOps tools (docker, terraform, go) → Kubernetes stack (kubectl, k9s, helm) → GUI apps → config roles (dotfiles, hyde)

### Secrets (Ansible-Vault)
Secrets live in `src/group_vars/all/vault.yml`, encrypted with AES256. The vault password is stored at `~/.config/homelab-iac/.vault_pass` (shared with `homelab-iac`).

```bash
just secrets-keygen    # generate vault password file (one-time setup)
just secrets-edit      # open vault in $EDITOR
just secrets-view      # print decrypted secrets to terminal
just secrets-encrypt   # encrypt vault.yml (idempotent)
just secrets-decrypt   # decrypt vault.yml permanently (use with care)
```

The pre-commit hook (`scripts/pre-commit.sh`) auto-encrypts `vault.yml` if it is unencrypted before any commit. Install it once with:
```bash
just install-hooks
```

### Custom Ansible Callback
`src/callback_plugins/beautiful_output.py` — custom plugin for styled playbook output. Disabled by default in `src/ansible.cfg` (commented out). Toggle with:
```bash
just plugin on    # enable beautiful_output
just plugin off   # disable (default; use when debugging)
```

## Adding a New Role

1. Create `src/roles/<name>/tasks/main.yaml`, `Archlinux.yaml`, `Ubuntu.yaml`
2. Add config files to `src/roles/<name>/files/`
3. Add the role name to `default_roles` in `src/group_vars/all.yaml` in the correct order
4. Test with: `bin/dotfiles "<name>"`
