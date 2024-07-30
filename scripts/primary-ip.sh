#!/usr/bin/env bash

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
  en|et)
    icon="󰈀"
    ;;
  wl)
    icon="󰖩"
    ;;
  vp)
    icon=""
    ;;
  NONE)
    icon=""
    ip="no internet"
    ;;
  *)
    icon=""
    ;;
esac

if [ "$(tmux show-option -gqv '@primary_ip_with_icon')" == "yes" ]
then
  tmux set-option -gq "@primary_ip_icon" ""
  echo "${icon} ${ip}"
else
  tmux set-option -gq "@primary_ip_icon" "${icon}"
  echo "${ip}"
fi
