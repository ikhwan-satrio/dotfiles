# NixOS Dotfiles

Personal NixOS flake configuration for a single-machine setup with Hyprland, home-manager, and CachyOS kernel.

## Quick start

```bash
# Build and switch
sudo nixos-rebuild switch --flake .#nixos-btw --impure

# Validate
nix flake check

# Dev shell
nix develop
```

## Structure

| Path | Purpose |
|---|---|
| `host/nixos-btw/configuration.nix` | System-level NixOS config |
| `host/nixos-btw/root-modules/` | NixOS modules (intel, grub, starship) |
| `host/nixos-btw/home-manager/` | User-level home-manager config |
| `host/pkgs/` | Custom package expressions |
| `config/` | Static dotfiles (kitty, tmux, starship, fastfetch) — not nix-managed |
| `vesktop-themes/` | Discord Vesktop themes, pulled in via home-manager |

## Key details

- **Host**: `nixos-btw` (single flake output)
- **User**: `wanto`
- **State version**: `26.05`
- **Nixpkgs**: `nixos-unstable`, unfree enabled
- **Hardware**: Intel Alder Lake GPU, CachyOS kernel
- **Display**: Hyprland (Wayland), SDDM, GRUB
- **home-manager backup**: existing files get `.hm-backup` suffix
- **No tests/CI** in this repo
