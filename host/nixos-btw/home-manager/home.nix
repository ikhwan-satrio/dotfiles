{
  config,
  pkgs,
  inputs,
  ...
}:

{
  home.username = "wanto";
  home.homeDirectory = "/home/wanto";
  home.stateVersion = "25.11";

  imports = [
    ./modules/vesktop.nix
    ./modules/vscode.nix
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

    ".config/fish".source = ../../../fish/.config/fish;
    ".config/fish".recursive = true;

    ".config/niri".source = ../../../niri/.config/niri;
    ".config/niri".recursive = true;
  };

  # === PACKAGES (OPTIMIZED) ===
  home.packages = with pkgs; [
    # LSP & Formatters
    nixfmt-rfc-style
    nil
    lua-language-server
    stylua

    # Apps
    uget
    uget-integrator
    easyeffects
    onlyoffice-desktopeditors
    tor-browser
    wezterm
    obs-studio
    obsidian
    gimp
    kdePackages.ark
    nautilus
    swappy
    vlc
    telegram-desktop
    whatsapp-electron

    # Terminal
    pipes-rs
    unimatrix
    matugen
    zoxide
    starship
    eza
    stow
    fastfetch
    btop

    # Themes
    papirus-icon-theme
    dconf
    bibata-cursors
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

    # zapzap.enable = true;

    vivaldi = {
      enable = true;
      nativeMessagingHosts = [ pkgs.uget-integrator ];
    };

    spicetify =
      let
        spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
      in
      {
        enable = true;

        theme = spicePkgs.themes.text;

        colorScheme = "TokyoNight";
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
