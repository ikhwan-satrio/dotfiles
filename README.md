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
  - [Niri](./niri/) - Novel Wayland compositor with innovative tiling

- **Configurations**:
  - Neovim setup with custom plugins and keybindings
  - Wezterm terminal configuration
  - Fish shell with custom functions
  - Various other application configurations

- **Services**:
  - Lenovo Vantage service integration
  - System services and daemon configurations

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
   # minimal
   sudo nixos-rebuild switch --flake .#nixos-minimal
   
   # main
   sudo nixos-rebuild switch --flake .#nixos-btw
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
- For Niri: Modify `./niri/` configurations

### Services

- Additional services can be configured in `configuration.nix`

## Troubleshooting

1. **Nix flake evaluation fails**:
   ```bash
   nix flake update
   ```
2. **Missing packages**: Check `flake.nix` for available packages

## Contributing

Feel free to fork this repository and submit pull requests for improvements or bug fixes.

## License

This project is licensed under MIT License - see the LICENSE file for details.

## Credits

Maintained by wanto-production
