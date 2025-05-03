<img alt="Icon" src="https://dotfiles.github.io/images/dotfiles-logo.png?raw=true" align="middle" height="114" width="400">

![](https://img.shields.io/badge/-Linux-000000.svg?style=for-the-badge&logo=Linux&logoColor=white)
![](https://img.shields.io/badge/-ubuntu_24.04-2C001E.svg?style=for-the-badge&logo=ubuntu&logoColor=white)
![](https://img.shields.io/badge/-gnome-3584e4.svg?style=for-the-badge&logo=gnome&logoColor=white)
![](https://img.shields.io/badge/-arch_linux-1793D1.svg?style=for-the-badge&logo=archlinux&logoColor=white)
![](https://img.shields.io/badge/-hyprland-15649b.svg?style=for-the-badge&logo=hyprland&logoColor=white)

# Dotfiles

##### Inspired from `dotfiles` of [TechDufus](https://github.com/techdufus/dotfiles)

My dotfiles, for personal use.

This repository supports both **Arch Linux** and **Ubuntu**.
- For **Arch Linux**, it was designed to be used with [Hyprland](https://wiki.hyprland.org/) using [HyDE](https://github.com/HyDE-Project/HyDE) as a pre-configuration.
- For **Ubuntu**, it was intended to be used with the standard Ubuntu LTS (using **GNOME**).


# Install

```shell
cd ~
git clone https://github.com/frankjuniorr/dotfiles
cd dotfiles

# only for Arch Linux + Hyprland + HyDE
cd scripts
./hyde-init.sh

# after reboot, install the dotfiles
cd ~/dotfiles/bin
./dotfiles
```

Another alternative to use this binary file is installing only 1 ansible role, example:
```bash
cd ~/dotfiles/bin
./dotfiles "dropbox"
```
This code install only the dropbox role, for example.

# Usage
The bin/dotfiles binary installs several applications and creates symbolic links to their respective configuration files.
It also installs my aliases and functions, organized as follows:
- A file for aliases, called `alias.sh`
- A file for functions, called `functions.sh`
- A directory named `commands` in the codebase, which maps to a `~/.bin` folder in the OS. This is used for larger scripts

