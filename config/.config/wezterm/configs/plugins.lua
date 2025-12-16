local wez = require 'wezterm'
local module = {}

function module.apply_to_config(config)
  local bar = wez.plugin.require 'https://github.com/adriankarlen/bar.wezterm'
  bar.apply_to_config(config, {
    position = 'bottom',
    max_width = 32,
    padding = {
      left = 1,
      right = 1,
      tabs = {
        left = 0,
        right = 2,
      },
    },
    separator = {
      space = 1,
      left_icon = wez.nerdfonts.fa_long_arrow_right,
      right_icon = wez.nerdfonts.fa_long_arrow_left,
      field_icon = wez.nerdfonts.indent_line,
    },
    modules = {
      tabs = {
        active_tab_fg = 4,
        inactive_tab_fg = 6,
        new_tab_fg = 2,
      },
      workspace = {
        enabled = true,
        icon = wez.nerdfonts.cod_window,
        color = 8,
      },
      leader = {
        enabled = true,
        icon = wez.nerdfonts.oct_rocket,
        color = 2,
      },
      zoom = {
        enabled = false,
        icon = wez.nerdfonts.md_fullscreen,
        color = 4,
      },
      pane = {
        enabled = true,
        icon = wez.nerdfonts.cod_multiple_windows,
        color = 7,
      },
      username = {
        enabled = true,
        icon = wez.nerdfonts.fa_user,
        color = 6,
      },
      hostname = {
        enabled = true,
        icon = wez.nerdfonts.cod_server,
        color = 8,
      },
      clock = {
        enabled = true,
        icon = wez.nerdfonts.md_calendar_clock,
        format = '%H:%M',
        color = 5,
      },
      cwd = {
        enabled = true,
        icon = wez.nerdfonts.oct_file_directory,
        color = 7,
      },
      spotify = {
        enabled = false,
        icon = wez.nerdfonts.fa_spotify,
        color = 3,
        max_width = 64,
        throttle = 15,
      },
    },
  })
end

return module
