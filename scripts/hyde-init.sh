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
{
  echo "eza"
  echo "pokego-bin"
  echo "code"
  echo "firefox"
  echo "zsh-theme-powerlevel10k-git"
} >> "$black_list_packages"

clear
./install.sh