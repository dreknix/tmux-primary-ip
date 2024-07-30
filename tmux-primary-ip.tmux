#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

primary_ip="#($CURRENT_DIR/scripts/primary-ip.sh)"
primary_ip_interpolation_string="\#{primary-ip}"

do_interpolation() {
  local string="$1"
  local interpolated="${string/$primary_ip_interpolation_string/$primary_ip}"
  echo "$interpolated"
}

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

update_tmux_option() {
  local option="$1"
  local option_value="$(get_tmux_option "$option")"
  local new_option_value="$(do_interpolation "$option_value")"
  set_tmux_option "$option" "$new_option_value"
}

main() {

  # initialize icon
  "${CURRENT_DIR}/scripts/primary-ip.sh" > /dev/null 2>&1

  update_tmux_option "status-right"
  update_tmux_option "status-left"

  if [ -z "$(get_tmux_option '@primary_ip_with_icon' '')" ]
  then
    set_tmux_option "@primary_ip_with_icon" "yes"
  fi
}

main
