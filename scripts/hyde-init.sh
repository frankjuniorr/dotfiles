#!/bin/env bash

cd ~ || return

# Dependencies
sudo pacman -S --needed --noconfirm openssh
sudo systemctl start sshd
sudo systemctl enable sshd


# HyDE Install
sudo pacman -S --needed --noconfirm git base-devel
git clone --depth 1 https://github.com/HyDE-Project/HyDE ~/HyDE
cd ~/HyDE/Scripts || return

core_packages_file="pkg_core.lst"

# Removing some packages
sed -i 's/^eza|zsh/# &/' "$core_packages_file"
sed -i 's/^eza|fish/# &/' "$core_packages_file"
sed -i 's/^zsh-theme-powerlevel10k-git|zsh/# &/' "$core_packages_file"
sed -i 's/^pokego-bin|zsh/# &/' "$core_packages_file"
sed -i 's/^code/# &/' "$core_packages_file"
sed -i 's/^firefox/# &/' "$core_packages_file"

clear
./install.sh

# Install more themes
cd ~/HyDE/Scripts || return
./themepatcher.sh "Greenify" https://github.com/mahaveergurjar/Theme-Gallery/tree/Greenify

# Reboot
echo "rebooting in 5 seconds"
sleep 5
reboot