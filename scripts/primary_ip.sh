#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${CURRENT_DIR}/helpers.sh"

result=$(get_primary_ip)

echo "$result" | cut -f2 -d: | tr -d '\n'
