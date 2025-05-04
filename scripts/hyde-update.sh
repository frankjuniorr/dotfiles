#!/bin/env bash

cd ~/HyDE/Scripts || return
./install.sh -r

# remove some fastfetchs images
files_to_be_deleted=(
    "$HOME/.config/fastfetch/logos/aisaka.icon"
    "$HOME/.config/fastfetch/logos/loli.icon"
    "$HOME/.config/fastfetch/logos/pochita.icon"
    "$HOME/.config/fastfetch/logos/geass.icon"
)

for file in "${files_to_be_deleted[@]}";do
    if [ -f "$file" ];then
        echo "removing fastfetch logos..."
        rm -rfv "$file"
    fi
done

reboot