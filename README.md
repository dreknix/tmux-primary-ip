# Tmux Primary IP

A tmux plugin that displays the primary IP address in the status bar.

The plugin introduces a new `#{primary_ip}` format.

The status bar is updated every `status-interval` seconds. If the option is not
set, the status bar is updated every 15 seconds.

## Installation with Tmux Plugin Manager

Add plugin to the list of TPM plugins in `~/.config/tmux/tmux.conf`:

``` plain
set -g plugin 'dreknix/tmux-primary-ip'
```

Hit `prefix + I` to install the plugin and source it.

The `#{primary_ip}` interpolation should now work.

## Customization

The plugin can be used with the [Catppuccin theme](https://github.com/catppuccin/tmux).
Add the following configuration `custom_modules/primary_ip.conf`:

``` plain
%hidden MODULE_NAME='primary_ip'

set -ogq "@catppuccin_${MODULE_NAME}_icon" '#{l:#{primary_ip_icon}} '
set -ogqF "@catppuccin_${MODULE_NAME}_color" '#{E:@thm_lavender}'
set -ogq "@catppuccin_${MODULE_NAME}_text" '#{l:#{primary_ip}}'

source -F '#{TMUX_PLUGIN_MANAGER_PATH}/tmux/utils/status_module.conf'
```

Add the following lines into `tmux.conf`:

``` plain
set-environment -gF TMUX_PLUGIN_MANAGER_PATH '#{HOME}/.local/share/tmux/plugins/'
run '#{TMUX_PLUGIN_MANAGER_PATH}/tmux/catppuccin.tmux'
source -F '#{d:current_file}/custom_modules/primary_ip.conf'
set -agF status-right '#{E:@catppuccin_status_primary_ip}'
```

## License

[MIT](https://github.com/dreknix/tmux-primary-ip/blob/main/LICENSE)
