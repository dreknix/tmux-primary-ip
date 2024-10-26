#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "${CURRENT_DIR}/scripts/helpers.sh"

primary_ip_interpolations=(
  "\#{primary_ip}"
  "\#{primary_ip_icon}"
)
primary_ip_commands=(
  "#($CURRENT_DIR/scripts/primary_ip.sh)"
  "#($CURRENT_DIR/scripts/primary_ip_icon.sh)"
)

do_interpolation() {
  local all_interpolated="$1"
  for ((i=0; i<${#primary_ip_commands[@]}; i++)); do
    all_interpolated=${all_interpolated//${primary_ip_interpolations[$i]}/${primary_ip_commands[$i]}}
  done
  echo "$all_interpolated"
}

update_tmux_option() {
  local option="$1"
  local option_value="$(get_tmux_option "$option")"
  local new_option_value="$(do_interpolation "$option_value")"
  set_tmux_option "$option" "$new_option_value"
}

main() {
  update_tmux_option "status-right"
  update_tmux_option "status-left"
}

main
