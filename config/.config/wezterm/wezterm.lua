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
config.window_close_confirmation = 'NeverPrompt'

-- Behavior
config.enable_wayland = true -- jika pakai Wayland
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

local tabline = wezterm.plugin.require 'https://github.com/michaelbrusegard/tabline.wez'
tabline.setup {
  options = {
    icons_enabled = true,
    theme = 'Catppuccin Mocha',
    tabs_enabled = true,
    theme_overrides = {},
    section_separators = {
      left = wezterm.nerdfonts.pl_left_hard_divider,
      right = wezterm.nerdfonts.pl_right_hard_divider,
    },
    component_separators = {
      left = wezterm.nerdfonts.pl_left_soft_divider,
      right = wezterm.nerdfonts.pl_right_soft_divider,
    },
    tab_separators = {
      left = wezterm.nerdfonts.pl_left_hard_divider,
      right = wezterm.nerdfonts.pl_right_hard_divider,
    },
  },
  sections = {
    tabline_a = { 'mode' },
    tabline_b = { 'workspace' },
    tabline_c = { ' ' },
    tab_active = {
      'index',
      { 'parent', padding = 0 },
      '/',
      { 'cwd', padding = { left = 0, right = 1 } },
      { 'zoomed', padding = 0 },
    },
    tab_inactive = { 'index', { 'process', padding = { left = 0, right = 1 } } },
    tabline_x = { 'ram', 'cpu' },
    tabline_y = { 'datetime', 'battery' },
    tabline_z = { 'domain' },
  },
  extensions = {},
}
tabline.apply_to_config(config)

config.window_decorations = 'NONE' -- hanya border resize, tanpa title bar

require('configs.keybinds').apply_to_config(config)

return config
