#!/bin/bash

function choose_os(){
    os=$(gum choose \
            --header "What the OS?" \
            --header.foreground="5" \
            --cursor.foreground="1" \
            --selected.foreground="2" \
            --no-show-help \
            --limit 2 \
            "ubuntu" "arch")

    if [ -z "$os" ];then
        echo "select a OS typing SPACE"
        exit 0
    fi
}

function choose_command(){
    command=$(gum choose \
            --header "What command" \
            --header.foreground="5" \
            --cursor.foreground="1" \
            --selected.foreground="2" \
            --no-show-help \
            "create" "post-install" "start" "stop" "destroy")

    if [ -z "$command" ];then
        echo "select a command typing ENTER"
        exit 0
    fi
}

choose_os
choose_command

os_list=$(echo "$os" | sed "s/^/'/" | sed "s/$/'/" | paste -sd "," -)
os_list="[$os_list]"

export OS_TYPE_LIST="$os_list"
export TAGS="$command"
export ANSIBLE_HOST="192.168.0.115"

echo "$OS_TYPE_LIST"
echo "$TAGS"

docker compose up --build
sleep 1
docker compose down