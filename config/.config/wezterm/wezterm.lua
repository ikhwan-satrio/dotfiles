local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Font
config.font = wezterm.font('JetBrainsMono Nerd Font', { weight = 'Regular' })
config.font_size = 12.0
config.line_height = 1.0

config.window_padding = {
  left = 10,
  right = 10,
  top = 10,
  bottom = 0,
}

config.window_background_opacity = 1.0
config.window_decorations = 'NONE'
config.window_close_confirmation = 'NeverPrompt'

-- Behavior
config.quit_when_all_windows_are_closed = true
config.automatically_reload_config = true

-- Shell
config.default_prog = { 'fish', '-l' }

-- Tab
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false -- UBAH ke false agar selalu tampil

-- Scrollback
config.scrollback_lines = 10000

-- Color scheme
config.color_scheme = 'Noctalia'
config.color_scheme_dirs = { wezterm.home_dir .. '/.config/wezterm/colors' }

require('configs.plugins').apply_to_config(config)
require('configs.keybinds').apply_to_config(config)

return config
