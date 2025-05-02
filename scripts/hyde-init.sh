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

# Removing some packages
black_list_packages="pkg_black.lst"
themes_list_file="themepatcher.lst"

{
  echo "eza"
  echo "pokego-bin"
  echo "code"
  echo "firefox"
  echo "zsh-theme-powerlevel10k-git"
} >> "$black_list_packages"

###### Removing some themes
# light themes
sed -i '/Catppuccin Latte/d' $themes_list_file
sed -i '/Material Sakura/d' $themes_list_file
sed -i '/Frosted Glass/d' $themes_list_file

# dark themes
sed -i '/Rosé Pine/d' $themes_list_file
sed -i '/Synth Wave/d' $themes_list_file

# add more themes
echo "\"Greenify\" \"https://github.com/mahaveergurjar/Theme-Gallery/tree/Greenify\"" >> $themes_list_file

clear
./install.sh