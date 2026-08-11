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
├── templates/             # Jinja2 templates (used for vault-sourced secrets)
└── handlers/              # Service reload handlers
```

`tasks/main.yaml` in every role uses `ansible_distribution` to include `Archlinux.yaml` or `Ubuntu.yaml`.

### Key Variables (`src/group_vars/all/`)
`all.yaml` was split into two files — do not recreate `all.yaml`:
- `vars.yaml` — plain vars: `primary_installation_path`, `scripts_installation_path`, `default_roles`, `fonts_list`, `go.packages`, `github_email` (not secret — already public in every commit)
- `vault.yml` — Ansible-Vault encrypted secrets (always encrypted in git; managed via `just secrets-*`): `vault_github_token`, `vault_github_ssh_public_key`

### Pre-tasks (`src/pre_tasks/`)
One pre-task always runs before roles:
1. `whoami.yaml` — captures current user into `host_user` fact

### Secrets in Templates
`git` and `dotfiles` roles render templates (`git-credentials-personal.j2`, `private-env.sh.j2`) directly from vault vars (`vault_github_ssh_public_key`, `vault_github_token`) plus the plain `github_email`. These template tasks are gated with `when: <vault_var> is defined` rather than a hardcoded flag — they no-op cleanly when `vault.yml` isn't present (e.g. the Docker CLI-only image, which excludes `vault.yml` via `.dockerignore`). No secrets are fetched live via the `op` CLI at provision time anymore (that pattern, and the `op_installed` fact/`detect_1password.yaml` pre-task that gated it, was retired). 1Password itself is still used at the OS level (SSH agent, commit signing via `op-ssh-sign`) — just not as an Ansible-time secret source anymore.

### Symlinks Pattern
Roles symlink config files from `roles/<name>/files/` to the appropriate `~/.config/<tool>/` location. The neovim role removes and recreates the entire `~/.config/nvim/` directory on each run.

### Omarchy Config Collision Policy
Omarchy owns `~/.config` by copying (`cp -R`/`cp -f` via `omarchy-refresh-config`, `omarchy-reinstall-configs`, and update migrations), not by symlinking. A **directory** symlink at a path Omarchy also populates gets silently written through — Omarchy's copy lands inside this git repo. Rules, in priority order:

1. **Never symlink a directory at a path Omarchy also populates** (check `~/omarchy/config/` in a local clone of the [Omarchy repo](https://github.com/basecamp/omarchy)). Symlink individual files instead — see the `btop` role for the pattern (Omarchy writes `~/.config/btop/themes/current.theme` next to our `btop.conf` symlink).
2. **Prefer composing over overwriting** where the tool supports an include mechanism, so Omarchy's own file is left untouched: `git` (`config.personal` + `[include] path`), `starship` (`STARSHIP_CONFIG` env var instead of fighting `~/.config/starship.toml`).
3. **Cede ownership** where Omarchy's default is fine and not worth maintaining a fork of (e.g. `lazygit` in omarchy_mode).
4. Where overwriting is unavoidable, symlink at the file level and rely on the `configs` playbook tag (`bin/dotfiles --mode omarchy configs`) — installed as the `omarchy` role's `post-update` hook — to reapply the symlink after any `omarchy-update`/`omarchy-migrate` run.

Full rationale and the file-by-file collision matrix live in the "Migração pro Omarchy" plan notes (not in this repo).

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
