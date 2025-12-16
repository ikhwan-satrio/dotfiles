local wezterm = require 'wezterm'
local module = {}

function module.apply_to_config(config)
  config.keys = {
    -- Tabs
    { key = 't', mods = 'CTRL|SHIFT', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
    { key = 'w', mods = 'CTRL|SHIFT', action = wezterm.action.CloseCurrentTab { confirm = true } },
    -- Tab navigation
    { key = 'Tab', mods = 'CTRL', action = wezterm.action.ActivateTabRelative(1) },
    { key = 'Tab', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateTabRelative(-1) },
    -- Tab navigation with numbers (Ctrl+Shift+1-9)
    { key = '1', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateTab(0) },
    { key = '2', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateTab(1) },
    { key = '3', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateTab(2) },
    { key = '4', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateTab(3) },
    { key = '5', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateTab(4) },
    { key = '6', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateTab(5) },
    { key = '7', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateTab(6) },
    { key = '8', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateTab(7) },
    { key = '9', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateTab(-1) },
    -- Move tabs
    { key = 'PageUp', mods = 'CTRL|SHIFT', action = wezterm.action.MoveTabRelative(-1) },
    { key = 'PageDown', mods = 'CTRL|SHIFT', action = wezterm.action.MoveTabRelative(1) },
    -- Splits
    { key = '\\', mods = 'CTRL|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = '-', mods = 'CTRL|SHIFT', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
    -- Pane navigation
    { key = 'h', mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Left' },
    { key = 'l', mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Right' },
    { key = 'k', mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Up' },
    { key = 'j', mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Down' },
    -- Resize panes
    { key = 'LeftArrow', mods = 'CTRL|SHIFT', action = wezterm.action.AdjustPaneSize { 'Left', 5 } },
    { key = 'RightArrow', mods = 'CTRL|SHIFT', action = wezterm.action.AdjustPaneSize { 'Right', 5 } },
    { key = 'UpArrow', mods = 'CTRL|SHIFT', action = wezterm.action.AdjustPaneSize { 'Up', 5 } },
    { key = 'DownArrow', mods = 'CTRL|SHIFT', action = wezterm.action.AdjustPaneSize { 'Down', 5 } },
    -- Close pane (Alt+W untuk avoid conflict dengan close tab)
    { key = 'w', mods = 'ALT', action = wezterm.action.CloseCurrentPane { confirm = true } },
    -- Ignore
    { key = 'Enter', mods = 'CTRL', action = wezterm.action.DisableDefaultAssignment },
  }
end

return module
