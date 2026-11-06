<img alt="Icon" src="https://dotfiles.github.io/images/dotfiles-logo.png?raw=true" align="middle" height="114" width="400">

![](https://img.shields.io/badge/-Linux-000000.svg?style=for-the-badge&logo=Linux&logoColor=white)
![](https://img.shields.io/badge/-ubuntu_24.04-2C001E.svg?style=for-the-badge&logo=ubuntu&logoColor=white)
![](https://img.shields.io/badge/-gnome-3584e4.svg?style=for-the-badge&logo=gnome&logoColor=white)
![](https://img.shields.io/badge/-arch_linux-1793D1.svg?style=for-the-badge&logo=archlinux&logoColor=white)
![](https://img.shields.io/badge/-hyprland-15649b.svg?style=for-the-badge&logo=hyprland&logoColor=white)

# Dotfiles

##### Inspired from `dotfiles` of [TechDufus](https://github.com/techdufus/dotfiles)

My dotfiles, for personal use.

This repository supports **Omarchy**, **Arch Linux** and **Ubuntu**, and is driven by Ansible roles (`src/roles/`) that install applications and symlink their config files.
- For **Omarchy** (Arch + Hyprland), use `--mode omarchy`. Omarchy owns most of `~/.config`, so the roles compose with it instead of overwriting it (see `CLAUDE.md`, "Omarchy Config Collision Policy").
- For **Arch Linux**, use the default mode (the OS is auto-detected).
- For **Ubuntu**, it was intended to be used with the standard Ubuntu LTS (using **GNOME**).

# Install

```shell
cd ~
git clone https://github.com/frankjuniorr/dotfiles
cd dotfiles

# install the dotfiles
cd ~/dotfiles/bin
./dotfiles                    # Arch / Ubuntu (OS is auto-detected)
./dotfiles --mode omarchy     # Omarchy
```

Another alternative to use this binary file is installing only 1 ansible role, example:
```bash
cd ~/dotfiles/bin
./dotfiles "dropbox"
./dotfiles --mode omarchy "mise"
```
This code install only the dropbox role, for example. Without an argument, `bin/dotfiles` prompts for the role (or `all`).

`bin/dotfiles` always asks for the `sudo` ("BECOME") password up front, and installs its own dependencies (`gum`, Ansible) on first run.

# Usage
The bin/dotfiles binary installs several applications and creates symbolic links to their respective configuration files.
It also installs my aliases and functions, organized as follows:
- A file for aliases, called `alias.sh`
- A file for functions, called `functions.sh`
- A directory named `commands` in the codebase, which maps to a `~/.bin` folder in the OS. This is used for larger scripts

## Tools are installed with mise
Like Omarchy, this repo uses [`mise`](https://mise.jdx.dev) as the installer for CLI dev tools (bat, fd, fzf, neovim, tmux, navi, atuin, sesh, yazi, kubectl, helm, k9s, terraform, go, ...) on Omarchy, Arch and Ubuntu.
- The `mise` role runs right after `git`; roles declare their tools through the shared `src/roles/common/tasks/mise_tool.yml` (`mise use --global <tool>@latest`).
- The system package manager (pacman/apt) is only used for what mise can't provide: GUI apps, system services, libraries, and things needed before mise exists (`jq`, `yq`, `zsh`, `docker`, `tmuxinator`, ...).
- On Omarchy, tools it already ships (bat, fd, zoxide, eza, starship, fzf, neovim) are skipped.
- `mise` only activates in interactive shells; Ansible tasks that call a mise-installed tool must put `~/.local/share/mise/shims` on `PATH` (or use `mise exec --`).

## Cheatsheets and the Omarchy menu
`navi` cheatsheets live in `src/roles/navi/files/cheats/` (including one for `mise`). On Omarchy, the `omarchy` role adds **Dotfiles**, **Mise** and **Snippets** entries to the Omarchy menu (`~/.config/omarchy/extensions/omarchy-menu.jsonc`).

# Docker image
A CLI-only environment (`--tags cli`) is built from the `Dockerfile` and published to `ghcr.io/frankjuniorr/dotfiles-env` by GitHub Actions: pushes and PRs only run the Dockerfile lint, while pushing a `v*` tag runs the full pipeline (build, smoke test, Trivy scan, SBOM, cosign signature).
```bash
just docker-build    # build locally
just docker-smoke    # build + run scripts/smoke-test.sh
just docker-up       # run the container
```
