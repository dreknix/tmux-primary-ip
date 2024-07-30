# Tmux Primary IP

A tmux plugin that displays the primary IP address in the status bar.

The plugin introduces a new `#{primary-ip}` format.

The status bar is updated every `status-interval` seconds. If the option is not
set, the status bar is updated every 15 seconds.

## Installation with Tmux Plugin Manager

Add plugin to the list of TPM plugins in `~/.config/tmux/tmux.conf`:

```
set -g plugin 'dreknix/tmux-primary-ip'
```

Hit `prefix + I` to install the plugin and source it.

The `#{primary-ip}` interpolation should now work.

## Customisation

The plugin can be used with the [Catppuccin theme](https://github.com/catppuccin/tmux).
Add the following script to `custom/primary_ip.sh`:

``` bash
#!/usr/bin/env bash

show_primary_ip() {
  local index=$1

  local icon="#(tmux show-option -gqv '@primary_ip_icon')"
  local color=$(get_tmux_option "@primary_ip_color" "$thm_magenta")
  local text=$(get_tmux_option "@primaray_ip_text" "#{primary-ip}")

  local module=$( build_status_module "$index" "$icon" "$color" "$text" )

  echo "$module"
}
```

Add `set -g @primary_ip_with_icon 'no'` into `tmux.conf` to hide icon output.
Add `primary_ip` to `@catppuccin_status_modules_left` or
`@catppuccin_status_modules_right`.

## License

[MIT](https://github.com/dreknix/tmux-primary-ip/blob/main/LICENSE)
