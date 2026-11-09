# AGENTS.md

## Build & switch

```bash
# Main rebuild (also available as `ns` alias in fish)
sudo nixos-rebuild switch --flake .#nixos-btw --impure

# Validate
nix flake check

# Enter dev shell
nix develop
```

## Structure

- **`flake.nix`** — flake-parts entrypoint; imports `modules/` and `hosts/` via import-tree
- **`modules/`** — shared flake/NixOS modules auto-registered as `flake.nixosModules.*` (`base`, `boot`, `hardware`, ...)
- **`hosts/<host>/default.nix`** — per-host `flake.nixosConfigurations.<host>`; add a new directory here to add a host
- **`home-manager/`** — shared user-level home-manager config and modules (fish, browsers, gtk, xdg, vesktop, vscode, noctalia)
- **`pkgs/`** — custom package expressions (cockpit-machines, free-download-manager, smooth-scroll)
- **`config/`** — static dotfiles (kitty, starship, tmux, fastfetch, neofetch) — *not* nix-managed; ~/stow or manual copy
- **`vesktop-themes/`** — imported into home-manager via `home.file`

## Quirks

- `home-manager.backupFileExtension = "hm-backup"` — existing files get renamed with `.hm-backup` suffix on home-manager apply
- `modules/` and `hosts/` are imported with import-tree: every `.nix` file below them is auto-imported, and paths containing `/_` are ignored. Prefix non-module files/directories with `_` (e.g. `_hardware-configuration.nix`)
- Flake requires `--impure` for nixos-rebuild (uses `/etc/nixos/hardware-configuration.nix` + unfree)
- Gitignore only covers `.git-credentials` and `.gitconfig` — be careful with secrets
- No tests, no CI, no formatter/lint config in repo
- `nixpkgs` uses `nixos-unstable` branch; `allowUnfree = true`
- CachyOS kernel, Hyprland (Wayland), SDDM display manager, Intel Alder Lake GPU
- Timezone `Asia/Jakarta`, locale `en_US.UTF-8` with Indonesian secondary locale settings
- User `wanto`, state version `26.05`
