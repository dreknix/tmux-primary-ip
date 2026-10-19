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

get_primary_ip_macos() {
  if="NONE"
  route_str="$(route -n get 8.8.8.8 2> /dev/null | grep 'interface:' | awk '{ print $2 }')"
  if [ -n "${route_str}" ]; then
    if="${route_str}"
    ip="$(ifconfig ${if} 2> /dev/null | grep 'inet ' | awk -F ' ' '{ print $2 }')"
  else
    ip="no internet"
  fi

  case "${if}" in
    en*)
      ethernet="$(ifconfig "${if}" 2> /dev/null | grep "supported media:" | grep "baseT")"
      if [ -n "${ethernet}" ]; then
        icon="ethernet"
      else
        icon="wifi"
      fi
      ;;
    tun*|utun*|ipsec*)
      icon="vpn"
      ;;
    *)
      icon="unknown"
      ;;
  esac
  printf "%s:%s" "${icon}" "${ip}"
}

get_primary_ip_freebsd () {
    if="NONE"
    route_str="$(route -n get 8.8.8.8 2> /dev/null | grep 'interface:' | awk '{ print $2 }')"
    if [ -n "${route_str}" ]; then
        if="${route_str}"
        ip="$(ifconfig ${if} 2> /dev/null | grep 'inet ' | awk -F ' ' '{ print $2 }')"
    else
      ip="no internet"
    fi

    case "${if}" in
      vt*)
        ethernet="$(ifconfig ${if} | grep 'media:' | grep 'base-T')"
        if [ -n "${ethernet}" ]; then
          icon="ethernet"
        else
          icon="wifi"
        fi
        ;;
      tun*|utun*|ipsec*|wg*|tailscale*)
        icon="vpn"
        ;;
      *)
        icon="unkown"
        ;;
    esac

    printf "%s:%s" "${icon}" "${ip}"
}

get_primary_ip_linux() {
  if="NONE"
  route_str="$(ip route get 8.8.8.8 2> /dev/null | head -1)"
  if [ -n "${route_str}" ]; then
    ip=$(echo "${route_str}" | awk '{for (i=1; i<NF; i++) if ($i == "src") {print $(i+1); break}}')
    default_if=$(echo "${route_str}" | awk '{for (i=1; i<NF; i++) if ($i == "dev") {print $(i+1); break}}')
    if=$(nmcli con show --active | grep -h "${default_if}" | awk '{print $(NF-1)}' | head -n 1)
  else
    ip="no internet"
  fi

  case "${if}" in
    ethernet)
      icon="ethernet"
      ;;
    wifi)
      icon="wifi"
      ;;
    tun|vpn|wireguard)
      icon="vpn"
      ;;
    *)
      icon="unknown"
      ;;
  esac

  printf "%s:%s" "${icon}" "${ip}"
}

get_primary_ip_uncached() {
  case "$(uname -s)" in
    Darwin*)
      get_primary_ip_macos
      ;;
    FreeBSD*)
      get_primary_ip_freebsd
      ;;
    *)
      get_primary_ip_linux
      ;;
  esac
}

file_mtime() {
  stat -c %Y "$1" 2> /dev/null || stat -f %m "$1" 2> /dev/null
}

# Every attached tmux client runs the status scripts on each refresh, and on
# Linux each run starts nmcli (a D-Bus client of NetworkManager). Cache the
# result for @primary_ip_cache_ttl seconds; 0 disables the cache.
get_primary_ip() {
  local ttl cache_dir cache mtime result
  ttl=$(get_tmux_option '@primary_ip_cache_ttl' '15')
  if ! [ "${ttl}" -gt 0 ] 2> /dev/null; then
    get_primary_ip_uncached
    return
  fi

  cache_dir="${XDG_RUNTIME_DIR:-${TMPDIR:-/tmp}}"
  cache="${cache_dir%/}/tmux-primary-ip-$(id -u)"
  if [ -f "${cache}" ]; then
    mtime=$(file_mtime "${cache}")
    if [ -n "${mtime}" ] && [ $(( $(date +%s) - mtime )) -lt "${ttl}" ]; then
      cat "${cache}"
      return
    fi
  fi

  result=$(get_primary_ip_uncached)
  printf "%s" "${result}" > "${cache}.$$" && mv -f "${cache}.$$" "${cache}"
  printf "%s" "${result}"
}
