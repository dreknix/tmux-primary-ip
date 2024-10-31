#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${CURRENT_DIR}/helpers.sh"

# script global variables
icon_ethernet=''
icon_wifi=''
icon_vpn=''
icon_unknown=''

# script global variables
icon_ethernet_default='󰈀'
icon_wifi_default='󰖩'
icon_vpn_default=''
icon_unknown_default=''

# icons are set as script global variables
get_icon_settings() {
  icon_ethernet=$(get_tmux_option '@primary_ip_icon_ethernet' "${icon_ethernet_default}")
  icon_wifi=$(get_tmux_option '@primary_ip_icon_wifi' "${icon_wifi_default}")
  icon_vpn=$(get_tmux_option '@primary_ip_icon_vpn' "${icon_vpn_default}")
  icon_unknown=$(get_tmux_option '@primary_ip_icon_unknown' "${icon_unknown_default}")
}

print_icon() {
  result=$(get_primary_ip)

  icon=$(echo "$result" | cut -f1 -d:)

  icon_name="icon_${icon}"
  printf "%s" "${!icon_name}"
}

main() {
  get_icon_settings
  print_icon
}
main
