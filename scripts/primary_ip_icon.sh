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

  if=$(echo "$result" | cut -f1 -d:)

  case "${if}" in
    en|et)
      printf "%s" "${icon_ethernet}"
      ;;
    wl)
      printf "%s" "${icon_wifi}"
      ;;
    vp)
      printf "%s" "${icon_vpn}"
      ;;
    *)
      printf "%s" "${icon_unknown}"
      ;;
  esac
}

main() {
  get_icon_settings
  print_icon
}
main
