{
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
    # ./modules/pipewires.nix
    # ./modules/vscode.nix
    # ./modules/hypridle.nix
    ./modules/noctalia.nix
    ./modules/browsers.nix
    ./modules/zsh.nix
    ./modules/vesktop.nix
    ./modules/gtk.nix
    ./modules/xdg.nix
    inputs.spicetify-nix.homeManagerModules.spicetify
    inputs.noctalia.homeModules.default
  ];

  # === HOME FILES (FIXED) ===
  home.file = {
    ".config/vesktop/themes".source = ../../../vesktop-themes;
    ".config/vesktop/themes".recursive = true;
    ".config/vesktop/themes".force = true;

    # ".config/fish".source = ../../../fish/.config/fish;
    # ".config/fish".recursive = true;

    ".config/niri".source = ../../../niri/.config/niri;
    ".config/niri".recursive = true;

    ".config/hypr".source = ../../../hyprland/.config/hypr;
    ".config/hypr".recursive = true;
  };

  # === PACKAGES (OPTIMIZED) ===
  home.packages = with pkgs; [
    # LSP & Formatters
    marksman
    nixfmt
    nixd
    lua-language-server
    stylua
    basedpyright

    # Apps
    kdePackages.kdenlive
    easyeffects
    onlyoffice-desktopeditors
    tor-browser
    kitty
    obs-studio
    file-roller # Add this
    nautilus
    swappy
    vlc
    telegram-desktop
    webcamoid
    aegisub

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
  };

  # === PROGRAMS ===
  programs = {
    home-manager.enable = true;

    spicetify =
      let
        spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
      in
      {
        enable = true;

        theme = spicePkgs.themes.comfy;

        colorScheme = "Lunar";
        enabledExtensions = with spicePkgs.extensions; [
          beautifulLyrics
          shuffle
          adblock
          fullAppDisplay
        ];
      };
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
