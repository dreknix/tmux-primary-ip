#!/usr/bin/env bash

set_tmux_option() {
  local option="$1"
  local value="$2"
  tmux set-option -gq "$option" "$value"
}

get_tmux_option() {
  local option="$1"
  local default_value="$2"
  local option_value="$(tmux show-option -gqv "$option")"
  if [ -z "$option_value" ]; then
    echo "$default_value"
  else
    echo "$option_value"
  fi
}

get_primary_ip() {
  if="NONE"
  route_str="$(ip route get 8.8.8.8 | head -1)"
  if [ -n "${route_str}" ]
  then
    if echo "${route_str}" | /usr/bin/grep -q " via "
    then
      ip=$(echo "${route_str}" | cut -d' ' -f7)
    else
      ip=$(echo "${route_str}" | cut -d' ' -f5)
    fi

    if=$(ip address show to "${ip}" | head -1 | cut -f2 -d: | tr -d ' ' | cut -c1-2)
  fi

  case "${if}" in
    NONE)
      ip="no internet"
      ;;
  esac

  printf "%s:%s" "${if}" "${ip}"
}
