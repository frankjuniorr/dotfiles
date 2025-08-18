#!/bin/env bash

# Função auxiliar, para todos os comandos
__is_cmd_installed() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "$cmd is not installed. Please install it first."
    return 1
  fi
}
