{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

{
  home.username = "wanto";
  home.homeDirectory = "/home/wanto";
  home.stateVersion = "26.05";

  imports = [
    ./modules/yazi.nix
    ./modules/fish.nix
    ./modules/browsers.nix
    ./modules/vesktop.nix
    ./modules/xdg.nix
    ./modules/spicetify.nix
    ./modules/fuzzel.nix
    # ./modules/gtk.nix
    # ./modules/zed.nix
    # ./modules/git.nix
  ];

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    "$HOME/.deno/bin"
    "$HOME/.cache/.bun/bin"
  ];

  # === PACKAGES (OPTIMIZED) ===
  home.packages = with pkgs; [
    # LSP & Formatters
    clang-tools
    arduino-language-server
    marksman
    lua-language-server
    stylua
    basedpyright
    ruff

    # yazi
    yaziPlugins.omni-trash

    # Apps
    easyeffects
    gimp
    kitty
    swappy
    mpv
    telegram-desktop
    aegisub
    chatterino2

    # Terminal
    posting
    matugen
    zoxide
    starship
    eza
    stow
    fastfetch
    btop
    fzf

    # Themes
    papirus-icon-theme
    dconf
  ];

  # === ENV ===
  home.sessionVariables = {
    BROWSER = "vivaldi";
    EDITOR = "nvim";
    VISUAL = "nvim";
    STEEL_HOME = "$HOME/.steel";
  };

  # === PROGRAMS ===
  programs = {
    home-manager.enable = true;
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

}
