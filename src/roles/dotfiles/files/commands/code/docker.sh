#!/bin/env bash

set -e

source ${HOME}/.bin/__utils.sh

# função auxiliar que destrói todo o ambiente docker na máquina
# ----------------------------------------------------------------------
destroy() {
  yes | docker system prune -a
  yes | docker volume prune
}

# Docker PS formatted to print only my most used fields
# ----------------------------------------------------------------------
ps() {
  docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Size}}"
}

# Entra no shell de um container docker que esteja em execução, de maneira interativa com fzf
# ----------------------------------------------------------------------
shell() {
  local container_name=$(docker ps --format "{{.Names}}" | fzf --height=20% --prompt="Selecione o container: ")

  # Se nenhum container foi selecionado, sai
  if [ -z "$container_name" ]; then
    echo "Nenhum container selecionado."
    exit 1
  fi

  # Executa o bash interativo no container selecionado
  docker exec -it "$container_name" bash
}

# ----------------------------------------------------------------------
ephemeral() {
  local docker_color="#0db7ed"
  local images=(
    "ubuntu:24.04"
    "archlinux:latest"
    "rockylinux:9.3"
    "alpine:latest"
  )

  local image
  local image=$(printf '%s\n' "${images[@]}" | fzf --height=20% --prompt="Escolha a imagem: ")

  if [ -z "$image" ]; then
    gum style --foreground="$docker_color" "Any docker image was selected"
    return 1
  fi

  local update_cmd
  local env_vars
  case "$image" in
  ubuntu:* | debian:*)
    init_cmd=(
      "apt-get update"
      "apt-get install -y tzdata vim bash curl wget figlet"
      "clear"
      "figlet \"$image\""
      "exec bash"
    )
    env_vars=(
      "-e" "DEBIAN_FRONTEND=noninteractive"
      "-e" "TZ=America/Recife"
    )
    ;;
  archlinux:*)
    init_cmd=(
      "pacman -Syu --noconfirm"
      "pacman -Sy --noconfirm vim bash curl wget figlet"
      "clear"
      "figlet \"$image\""
      "exec bash"
    )
    env_vars=()
    ;;
  rockylinux:* | centos:* | fedora:*)
    init_cmd=(
      "dnf update -y"
      "dnf install -y vim bash ncurses epel-release"
      "dnf install -y figlet"
      "clear"
      "figlet \"$image\""
      "exec bash"
    )
    env_vars=()
    ;;
  alpine:*)
    init_cmd=(
      "apk update"
      "apk add vim bash curl wget figlet"
      "clear"
      "figlet \"$image\""
      "exec bash"
    )
    env_vars=()
    ;;
  *)
    init_cmd=("sh" "-c" "echo 'Nenhum gerenciador de pacotes detectado' && exec sh")
    ;;
  esac

  gum style --foreground="$docker_color" "Docker Image: $image"
  gum style --foreground="$docker_color" "Commands:"

  cmd_str=$(printf '%s && ' "${init_cmd[@]}")
  cmd_str=${cmd_str% && }

  gum style --foreground="$docker_color" "$cmd_str"

  local container_name=$(echo "$image" | cut -d ":" -f1)
  docker run --rm -it \
    -e TERM=xterm-256color \
    --name "$container_name" \
    "${env_vars[@]}" \
    "$image" \
    sh -c "$cmd_str"
}

# Exibe o log um container docker que esteja em execução, de maneira interativa com fzf
# ----------------------------------------------------------------------
logs() {
  local container_name=$(docker ps --format "{{.Names}}" | fzf --height=20% --prompt="Selecione o container: ")

  # Se nenhum container foi selecionado, sai
  if [ -z "$container_name" ]; then
    echo "Nenhum container selecionado."
    exit 1
  fi

  # Executa o bash interativo no container selecionado
  docker logs "$container_name"
}

tui() {
  lazydocker
}

# --------------------------------------------------------------------------------------
# MAIN
# --------------------------------------------------------------------------------------

# Menu
options=(
  "📋 ps"
  "🐳 shell"
  "⚡ ephemeral"
  "📜 logs"
  "🎛️ tui"
  "💥 destroy"
)
result=$(printf "%s\n" "${options[@]}" | fzf \
  --header="$(figlet Docker)" \
  --ansi \
  --prompt="⚡ Docker: " \
  --height=20%)

case "$result" in
"📋 ps") ps ;;
"🐳 shell") shell ;;
"⚡ ephemeral") ephemeral ;;
"📜 logs") logs ;;
"🎛️ tui") tui ;;
"💥 destroy") destroy ;;
esac
