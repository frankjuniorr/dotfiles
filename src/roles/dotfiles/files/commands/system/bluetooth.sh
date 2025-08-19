#!/bin/env bash

set -e

source ${HOME}/.bin/__utils.sh

# ----------------------------------------------------------------------
restart() {
  sudo systemctl restart bluetooth.service
}

# ----------------------------------------------------------------------
connect_headphone() {
  local headphone_mac_address="FC:E8:06:8A:2E:F9"
  bluetoothctl connect "$headphone_mac_address"
}

list_devices() {
  echo "Devices connected:"
  echo "----------------------------------------"
  bluetoothctl devices
}

# --------------------------------------------------------------------------------------
# MAIN
# --------------------------------------------------------------------------------------

# Menu
options=(
  "🔄 Restart"
  "📋 List Devices"
  "🎧 Connect Headphone"
)
result=$(printf "%s\n" "${options[@]}" | fzf \
  --header="$(figlet bluetooth)" \
  --ansi \
  --prompt="⚡ Bluetooth: " \
  --height=20%)

case "$result" in
"🔄 Restart") restart ;;
"📋 List Devices") list_devices ;;
"🎧 Connect Headphone") connect_headphone ;;
esac
