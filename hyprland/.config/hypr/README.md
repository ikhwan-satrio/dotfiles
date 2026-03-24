# Hyprland Dotfiles

Welcome to my Hyprland configuration! This repository contains my personal Hyprland tiling window manager setup with a beautiful color scheme and productivity-focused keybindings.

## shell

[Noctalia-shell](https://github.com/noctalia-dev/noctalia-shell)

## Overview

- **Window Manager**: [Hyprland](https://hyprland.org/)
- **Compositor**: Hyprland's built-in compositor
- **Color Scheme**: Custom dark theme with lavender accents based on Material Design colors
- **Cursor Theme**: Catppuccin Mocha Lavender Cursors

## Features

- **Pseudotiling**: Enabled by default with `SUPER + P`
- **Custom Keybinds**: Intuitive and productivity-focused shortcuts
- **Mouse Support**: Full mouse-based window management
- **Multi-workspace**: 10 workspaces with easy navigation
- **Media Controls**: Integrated audio and media controls
- **Screen Capture**: Screenshot functionality with hyprshot
- **Scratchpad**: Special workspace accessible with `SUPER + S`

## Key Applications

- **Terminal**: Kitty
- **File Manager**: Thunar
- **Browser**: Brave
- **Clipboard Manager**: Cliphist with wl-clipboard
- **Launcher**: Noctalia-shell (custom launcher)

## Keybindings

### Application Shortcuts
- `SUPER + RETURN` - Launch terminal
- `SUPER + E` - Launch file manager
- `SUPER + B` - Launch browser
- `SUPER + V` - Clipboard history
- `SUPER + R` - Application launcher

### Window Management
- `SUPER + F` - Toggle fullscreen
- `SUPER + SHIFT + F` - Toggle fake fullscreen
- `SUPER + T` - Toggle floating
- `SUPER + P` - Toggle pseudotiling
- `SUPER + J` - Toggle split
- `SUPER + C` - Center window
- `SUPER + O` - Pin window
- `SUPER + Q` - Close window

### Focus Movement
- `SUPER + H/L/K/J` or `SUPER + Arrow Keys` - Move focus in direction
- `SUPER + ALT + H/L/K/J` or `SUPER + ALT + Arrow Keys` - Move window in direction
- `SUPER + CTRL + H/L/K/J` or `SUPER + CTRL + Arrow Keys` - Resize window

### Workspace Navigation
- `SUPER + [1-0]` - Switch to workspace 1-10
- `SUPER + Mouse Wheel` or `SUPER + TAB` - Cycle through workspaces
- `SUPER + SHIFT + [1-0]` - Move window to workspace 1-10
- `SUPER + CTRL + [1-0]` - Move window to workspace 1-10 (silent)

### Screenshots
- `PRTSC` - Screenshot active monitor to file
- `SHIFT + PRTSC` - Screenshot region to file
- `SUPER + PRTSC` - Screenshot active window
- `CTRL + PRTSC` - Screenshot to clipboard
- `CTRL + SHIFT + PRTSC` - Screenshot region to clipboard

### Media Controls
- `XF86AudioRaiseVolume` - Increase volume
- `XF86AudioLowerVolume` - Decrease volume
- `XF86AudioMute` - Mute/unmute audio
- `XF86AudioMicMute` - Mute/unmute microphone
- `XF86AudioPlay/Pause` - Play/pause media
- `XF86AudioNext/Prev` - Next/previous track
- `SUPER + SHIFT + P` - Toggle play/pause

### System Controls
- `SUPER + SHIFT + Q` - Session menu (logout/reboot/shutdown)
- `SUPER + W` - Wallpaper selector
- `SUPER + SHIFT + W` - Random wallpaper

### Special Features
- `SUPER + S` - Toggle scratchpad (special workspace)
- `SUPER + SHIFT + S` - Move window to scratchpad
- Mouse dragging with `SUPER` - Move floating windows
- Mouse right-click + `SUPER` - Resize windows

## Configuration Structure

The configuration is organized into multiple files for easier management:

- `hyprland.conf` - Main configuration file, sources all other configs
- `scheme.conf` - Color scheme definitions
- `variables.conf` - Variables for keybindings and applications
- `configs/`
  - `animations.conf` - Animation settings
  - `decoration.conf` - Window decorations
  - `env.conf` - Environment variables
  - `general.conf` - General settings (gaps, borders, etc.)
  - `gestures.conf` - Touchpad/mouse gesture settings
  - `input.conf` - Input device settings
  - `keybinds.conf` - All keybindings
  - `misc.conf` - Miscellaneous settings
  - `monitor.conf` - Monitor configuration
  - `plugins.conf` - Plugin configuration
  - `startup.conf` - Applications to run at startup
  - `windowrule.conf` - Window management rules

## Dependencies

For this configuration to work properly, you need:

- Hyprland
- Kitty terminal
- Thunar file manager
- Brave browser
- Noctalia-shell (for launcher and system controls)
- Hyprshot (for screenshots)
- Cliphist (for clipboard history)
- wl-clipboard (for clipboard functionality)
- Playerctl (for media controls)
- Gnome-keyring (for password management)
- Polkit agent
- Trash-cli (for automatic trash cleanup)

## Installation

1. Install Hyprland and dependencies
2. Backup your existing Hyprland configuration
3. Clone this repository to `~/.config/hypr/`
4. Adjust the `variables.conf` file to match your preferred applications
5. Restart Hyprland or reboot

## Customization

- Modify `scheme.conf` to change the color scheme
- Adjust `variables.conf` to set your preferred applications
- Modify `configs/keybinds.conf` to change keybindings
- Add/remove startup applications in `configs/startup.conf`

## Notes

- The configuration uses a custom mouse sensitivity setting for "epic-mouse-v1"
- The dwindle layout with pseudotiling is the primary window management style
- Window borders are customized with lavender for active and gray for inactive windows
- Gaps are set to 5px inside and 10px outside windows

