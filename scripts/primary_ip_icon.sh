#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${CURRENT_DIR}/helpers.sh"

result=$(get_primary_ip)

if=$(echo "$result" | cut -f1 -d:)

case "${if}" in
  en|et)
    printf "󰈀"
    ;;
  wl)
    printf "󰖩"
    ;;
  vp)
    printf ""
    ;;
  *)
    printf ""
    ;;
esac
