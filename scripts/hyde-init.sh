#!/bin/env bash

cd ~ || return

# HyDE Install
sudo pacman -S --needed --noconfirm git base-devel
git clone --depth 1 https://github.com/HyDE-Project/HyDE ~/HyDE
cd ~/HyDE/Scripts || return
./install.sh

# Install more themes
cd ~/HyDE/Scripts || return

./themepatcher.sh "Greenify" https://github.com/mahaveergurjar/Theme-Gallery/tree/Greenify

# Reboot
reboot