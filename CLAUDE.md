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

The `bin/dotfiles` script auto-installs dependencies (`gum`, Ansible), detects the OS, and runs the Ansible playbook in `src/`. It always prompts for a "BECOME password" up front (own `read -rs`, not Ansible's `--ask-become-pass`) and feeds it to `ansible-playbook` via a temp vars file — a deliberate workaround for a real ansible-core 2.21.x bug ("Duplicate become password prompt encountered") that `--ask-become-pass` hits whenever the `become` task comes from a dynamically included role, which is every task here since `main.yml` selects roles via `include_role`. See `bin/dotfiles` around the `BECOME password` prompt for details.

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
├── templates/             # Jinja2 templates (used for op-sourced secrets)
└── handlers/              # Service reload handlers
```

`tasks/main.yaml` in every role uses `ansible_distribution` to include `Archlinux.yaml` or `Ubuntu.yaml`.

### Key Variables (`src/group_vars/all/`)
`all.yaml` was split into two files — do not recreate `all.yaml`:
- `vars.yaml` — plain vars: `primary_installation_path`, `scripts_installation_path`, `default_roles`, `fonts_list`, `go.packages`, `github_email` (not secret — already public in every commit)

There is no `vault.yml` anymore — the two secrets it used to hold (`vault_github_token`, `vault_github_ssh_public_key`) are now read live from 1Password instead. See "Secrets (1Password CLI)" below.

### Pre-tasks (`src/pre_tasks/`)
One pre-task always runs before roles:
1. `whoami.yaml` — captures current user into `host_user` fact

### Secrets in Templates
`git` and `dotfiles` roles render templates (`git-credentials-personal.j2`, `private-env.sh.j2`) from vars named `vault_github_ssh_public_key`/`vault_github_token` (names kept for template compatibility, no longer vault-sourced) plus the plain `github_email`. Each role's `tasks/main.yaml` reads the real value live via `op read` right before the template task, and passes it in through that task's own `vars:` block. Both roles run an `op whoami` check first (`register: op_status`) and gate everything on `op_status.rc == 0` — on a machine/VM where 1Password isn't authenticated (e.g. this repo's Omarchy test VM, by design), the read and the template task both no-op cleanly instead of failing. `bin/dotfiles` prints a `gum`-styled reminder at the end of a `git`/`dotfiles`/`all`-tagged run if `op` is missing or unauthenticated, since otherwise the skip is silent. Current 1Password item paths: `op://Personal/GitHub SSH/public_key` and `op://Personal/Github Token/credential` — if either item is renamed/restructured in the vault, update the `op read` calls in `src/roles/git/tasks/main.yaml` and `src/roles/dotfiles/tasks/main.yaml` to match. 1Password itself is still used at the OS level too (SSH agent, commit signing via `op-ssh-sign` — `gpg.format = ssh`/`gpg.ssh.program` are set unconditionally in `src/roles/git/files/config.personal`).

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

### Secrets (1Password CLI)
No Ansible-Vault anymore — `src/group_vars/all/vault.yml` was removed, along with `--vault-password-file` from both `bin/dotfiles` and the Justfile's `ansible_cmd`, and the `just secrets-*` recipes. The vault's only two secrets (`vault_github_token`, `vault_github_ssh_public_key`) are now read live via `op read` in the `git`/`dotfiles` roles, gated on `op whoami` succeeding — see "Secrets in Templates" above for the exact mechanism and item paths. This was a deliberate removal, not just a migration detail: since `group_vars/all/vault.yml` is auto-loaded by Ansible before any task runs regardless of `--tags`, a missing `~/.config/homelab-iac/.vault_pass` (e.g. on a freshly formatted machine) used to fail the *entire* playbook, not just the 2 git/github tasks. `~/.config/homelab-iac/.vault_pass` itself still exists on disk and is still used by the separate `homelab-iac` project — this repo just no longer references it.

The pre-commit hook (`scripts/pre-commit.sh`) no longer has any vault-encryption step; it now only handles the `beautiful_output` toggle, executable-bit fixups, and re-staging. Install it once with:
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
