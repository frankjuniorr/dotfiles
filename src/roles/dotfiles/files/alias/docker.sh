#################################################################
# Docker Functions
#################################################################

# função auxiliar que destrói todo o ambiente docker na máquina
# ----------------------------------------------------------------------
d-destroy() {
  yes | docker system prune -a
  yes | docker volume prune
}

# Docker PS formatted to print only my most used fields
# ----------------------------------------------------------------------
d-ps() {
  docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Size}}"
}

# Entra no shell de um container docker que esteja em execução, de maneira interativa com fzf
# ----------------------------------------------------------------------
d-shell() {
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
d-ephemeral() {
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

  docker run --rm -it \
    -e TERM=xterm-256color \
    "${env_vars[@]}" \
    "$image" \
    sh -c "$cmd_str"
}

# Exibe o log um container docker que esteja em execução, de maneira interativa com fzf
# ----------------------------------------------------------------------
d-logs() {
  local container_name=$(docker ps --format "{{.Names}}" | fzf --height=20% --prompt="Selecione o container: ")

  # Se nenhum container foi selecionado, sai
  if [ -z "$container_name" ]; then
    echo "Nenhum container selecionado."
    exit 1
  fi

  # Executa o bash interativo no container selecionado
  docker logs "$container_name"
}
