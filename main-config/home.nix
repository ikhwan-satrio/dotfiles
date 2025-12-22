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
    inputs.spicetify-nix.homeManagerModules.spicetify
    inputs.catppuccin.homeModules.catppuccin
  ];

  # === CATPPUCCIN FULL COVERAGE ===
  catppuccin = {
    enable = true;
    flavor = "mocha"; # Global flavor
    accent = "lavender";
    btop.enable = true;
    vivaldi.enable = true;
  };

  # === HOME FILES (FIXED) ===
  home.file = {
    ".config/vesktop/themes".source = ../vesktop-themes;
    ".config/vesktop/themes".recursive = true;
    ".config/vesktop/themes".force = true;

    ".config/fish".source = ../fish/.config/fish;
    ".config/fish".recursive = true;

    ".config/niri".source = ../niri/.config/niri;
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
    localsend
    obs-studio
    obsidian
    gimp
    kdePackages.ark
    nautilus
    swappy
    telegram-desktop

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

    # Themes (Catppuccin handles icons)
    dconf
    bibata-cursors
  ];

  # === XDG PORTAL ===
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
    };

    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = "org.gnome.Nautilus.desktop";
        "text/plain" = "neovim.desktop";
        "text/markdown" = "neovim.desktop";
        "text/x-python" = "neovim.desktop";
        "text/x-shellscript" = "neovim.desktop";
        "application/javascript" = "neovim.desktop";
        "application/json" = "neovim.desktop";
      };
      associations.added = {
        "image/png" = [
          "org.gnome.Loupe.desktop"
          "gimp.desktop"
        ];
        "text/plain" = [
          "neovim.desktop"
          "org.gnome.gedit.desktop"
        ];
      };
    };
  };

  # === PROGRAMS ===
  programs = {
    home-manager.enable = true;

    zapzap.enable = true;

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
        theme = spicePkgs.themes.comfy;
        colorScheme = "catppuccin-mocha";
        enabledExtensions = with spicePkgs.extensions; [
          beautifulLyrics
          shuffle
          adblock
          fullAppDisplay
        ];
      };

    vesktop = {
      enable = true;
      settings = {
        appBadge = true;
        arRPC = true;
        checkUpdates = true;
        customTitleBar = false;
        disableMinSize = true;
        minimizeToTray = true;
        tray = true;
        hardwareAcceleration = true;
        discordBranch = "stable";
        plugins = {
          MessageLogger = {
            enabled = true;
            ignoreSelf = true;
          };
          FakeNitro.enabled = true;
          AnonymiseFileNames.enable = true;
          BetterSessions.enable = true;
          BetterSettings.enable = true;
          CallTimer.enable = true;
          ClearURLs.enable = true;
          CustomRPC.enable = true;
          CustomIdle.enable = true;
          DisableCallIdle = true;
          FavoriteEmojiFirst.enable = true;
          FixImagesQuality.enable = true;
          FixYoutubeEmbeds.enable = true;
          FriendsSince.enable = true;
          GameActivityToggle.enable = true;
          GifPaste.enable = true;
          ImageZoom.enable = true;
          KeepCurrentChannel.enable = true;
          LastFMRichPresence.enable = true;
          MessageLatency.enable = true;
          ReadAllNotificationsButton.enable = true;
          YoutubeAdblock.enable = true;
          VolumeBooster.enable = true;
          Unindent.enable = true;
          NotTypingAnimation.enable = true;
          SilentTyping.enable = true;
        };
      };
    };
  };

  # === DCONF & GTK (CATPPUCCIN) ===
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Sweet-Dark";
      package = pkgs.sweet;
    };
    gtk3.extraConfig = {
      Settings = "gtk-application-prefer-dark-theme=1";
    };
    gtk4.extraConfig = {
      Settings = "gtk-application-prefer-dark-theme=1";
    };
  };
}
