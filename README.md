# NixOS Dotfiles

Personal multi-host NixOS flake configuration with Hyprland, home-manager, and CachyOS kernel.

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
| `flake.nix` | flake-parts entrypoint; imports `modules/` and `hosts/` via import-tree |
| `modules/` | Shared flake/NixOS modules, auto-registered as `flake.nixosModules.*` |
| `hosts/<host>/default.nix` | Per-host `flake.nixosConfigurations.<host>` |
| `home-manager/` | Shared user-level home-manager config and modules |
| `pkgs/` | Custom package expressions |
| `config/` | Static dotfiles (kitty, tmux, starship, fastfetch) — not nix-managed |
| `vesktop-themes/` | Discord Vesktop themes, pulled in via home-manager |

## Adding a host

1. Create `hosts/<host>/default.nix` defining `flake.nixosConfigurations.<host>`.
2. Rebuild with `--flake .#<host>`.

Because `hosts/` is imported with import-tree, a new host directory is picked up automatically. Paths containing `/_` are ignored by import-tree, so keep non-module files prefixed with `_`.

Each host reads hardware config from `/etc/nixos/hardware-configuration.nix`, so builds must use `--impure`.

## Key details

- **Host**: `nixos-btw` (add more hosts under `hosts/`)
- **User**: `wanto`
- **State version**: `26.05`
- **Nixpkgs**: `nixos-unstable`, unfree enabled
- **Hardware**: Intel Alder Lake GPU, CachyOS kernel
- **Display**: Hyprland (Wayland), SDDM, GRUB
- **home-manager backup**: existing files get `.hm-backup` suffix
- **No tests/CI** in this repo
