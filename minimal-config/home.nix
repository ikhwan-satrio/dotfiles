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

  # === FILES ===
  home.file = {
    ".config/vesktop/themes" = {
      source = ../vesktop-themes;
      recursive = true;
    };
    ".config/fish" = {
      source = ../fish/.config/fish;
      recursive = true;
    };
    ".config/niri" = {
      source = ../niri/.config/niri;
      recursive = true;
    };
  };

  # === PACKAGES ===
  home.packages = with pkgs; [
    # Dev Tools
    nixfmt-rfc-style
    nil
    lua-language-server
    stylua

    # Apps
    uget
    uget-integrator
    wezterm
    kdePackages.ark
    nautilus
    swappy

    # Terminal
    pipes-rs
    unimatrix
    btop
    matugen
    zoxide
    starship
    eza
    stow
    fastfetch

    # Themes
    dconf
    papirus-icon-theme
    bibata-cursors
  ];

  # === XDG ===
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
      publicShare = "${config.home.homeDirectory}/Public";
      templates = "${config.home.homeDirectory}/Templates";
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

  # === DCONF ===
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

  # === PROGRAMS ===
  programs = {
    home-manager.enable = true;

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

  # === GTK ===
  gtk = {
    enable = true;
    theme = {
      name = "Sweet-Dark";
      package = pkgs.sweet;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig = {
      Settings = "gtk-application-prefer-dark-theme=1";
    };
    gtk4.extraConfig = {
      Settings = "gtk-application-prefer-dark-theme=1";
    };
  };
}
