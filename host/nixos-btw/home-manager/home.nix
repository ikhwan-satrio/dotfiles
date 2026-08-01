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
    ./modules/gtk.nix
    ./modules/xdg.nix
    ./modules/spicetify.nix
    ./modules/fuzzel.nix
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
    android-studio
    android-studio-tools
    marksman
    lua-language-server
    stylua
    basedpyright
    
    # yazi
    yaziPlugins.omni-trash

    # Apps
    kdePackages.kdenlive
    easyeffects
    onlyoffice-desktopeditors
    wezterm
    kitty
    file-roller # Add this
    swappy
    mpv
    telegram-desktop
    webcamoid
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
