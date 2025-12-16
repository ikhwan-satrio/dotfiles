# NixOS Dotfiles Configuration

Personal NixOS configuration with multiple window managers and comprehensive dotfiles. This repository contains my NixOS system configuration along with various application configurations and development tools.

## Overview

This repository contains:
- NixOS system configuration
- Multiple Wayland compositor configurations (SwayWM, Hyprland, Niri)
- Comprehensive dotfiles for various tools
- Development environment configurations

### Features

- **Window Managers/Compositors**:
  - [SwayWM](./swaywm/) - Tiling Wayland compositor with i3-like keybindings
  - [Hyprland](./hyprconfig/) - Modern Wayland compositor
  - [Niri](./niri/) - Novel Wayland compositor with innovative tiling
  - [Standalone Wayland Compositor](./standalone-wayland-compositor/)

- **Configurations**:
  - Neovim setup with custom plugins and keybindings
  - Kitty terminal configuration
  - Tmux configuration with custom keybindings
  - Fish shell with custom functions
  - Various other application configurations

- **Services**:
  - Lenovo Vantage service integration
  - System services and daemon configurations

## Repository Structure

```
├── configuration.nix       # Main NixOS system configuration
├── home.nix               # Home Manager configuration
├── hardware-configuration.nix  # Hardware-specific configuration
├── flake.nix              # Nix flake definition
├── config/                # General dotfiles
├── fish/                  # Fish shell configurations
├── hyprconfig/            # Hyprland window manager configs
├── niri/                  # Niri compositor configurations
├── swaywm/                # SwayWM configurations
├── standalone-wayland-compositor/  # Standalone wayland compositor configs
└── lenovo_vantage/        # Lenovo Vantage integration
```

## Prerequisites

- Nix package manager (with flakes enabled)
- NixOS system (for system configurations)
- Git

## Installation

### For NixOS System:

1. Clone this repository:
   ```bash
   git clone https://github.com/wanto-production/dotfiles.git ~/nixos-wanto
   cd nixos-wanto
   ```

2. Build and switch to the system configuration:
   ```bash
   sudo nixos-rebuild switch --flake .#nixos-btw
   ```

### Using Home Manager (for non-NixOS systems):

1. Install Home Manager:
   ```bash
   nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz home-manager
   nix-channel --update
   ```

2. Build and activate the home configuration:
   ```bash
   home-manager switch --flake .#nixos-btw
   ```

## Development Environment

Enter the development environment with preconfigured tools:

```bash
# Enter development shell with all necessary tools
nix develop

# Or build and test the flake
nix flake check
```

## Customizing

### Window Manager Selection

Each window manager has its own subdirectory with dedicated configurations:
- For SwayWM: Modify `./swaywm/` configurations
- For Hyprland: Modify `./hyprconfig/` configurations  
- For Niri: Modify `./niri/` configurations

### Services

- Lenovo Vantage auto-startup service can be found in `./lenovo_vantage/`
- Additional services can be configured in `configuration.nix`

## Key Bindings

### SwayWM Keybinds
See `./swaywm/config` for detailed keybindings configuration.

### Tmux Keybinds
| Function | Shortcut |
|----------|----------|
| Prefix | `Ctrl + a` |
| Split horizontally | `Prefix + \|` |
| Split vertically | `Prefix + -` |
| Navigate panes | `Prefix + h/j/k/l` |
| Resize panes | `Alt + h/j/k/l` |

## Troubleshooting

1. **Nix flake evaluation fails**:
   ```bash
   nix flake update
   ```

2. **Configuration changes not applying**:
   - For system: `sudo nixos-rebuild switch --flake .`
   - For home: `home-manager switch --flake .`

3. **Missing packages**: Check `flake.nix` for available packages

## Contributing

Feel free to fork this repository and submit pull requests for improvements or bug fixes.

## License

This project is licensed under MIT License - see the LICENSE file for details.

## Credits

Maintained by wanto-production
