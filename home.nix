{
  config,
  pkgs,
  inputs,
  ...
}:

{
  home.username = "wanto";
  home.homeDirectory = "/home/wanto";

  imports = [
    inputs.spicetify-nix.homeManagerModules.spicetify
  ];

  home.file.".config/vesktop/themes" = {
    source = ./vesktop-themes;
    recursive = true;
  };

  home.packages = with pkgs; [
    nixfmt-rfc-style
    nil
    lua-language-server
    stylua

    # themes
    papirus-icon-theme
    bibata-cursors
  ];

  # XDG Base Directory
  xdg.enable = true;

  # XDG User Directories (Documents, Downloads, dll)
  xdg.userDirs = {
    enable = true;
    createDirectories = true; # Auto-create folders

    desktop = "${config.home.homeDirectory}/Desktop";
    documents = "${config.home.homeDirectory}/Documents";
    download = "${config.home.homeDirectory}/Downloads";
    music = "${config.home.homeDirectory}/Music";
    pictures = "${config.home.homeDirectory}/Pictures";
    videos = "${config.home.homeDirectory}/Videos";

    publicShare = "${config.home.homeDirectory}/Public";
    templates = "${config.home.homeDirectory}/Templates";
  };

  # XDG MIME Types (default applications)
  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      # File Manager
      "inode/directory" = "org.gnome.Nautilus.desktop";

      # Web Browser
      "text/html" = "brave-browser.desktop";
      "x-scheme-handler/http" = "brave-browser.desktop";
      "x-scheme-handler/https" = "brave-browser.desktop";
      "x-scheme-handler/about" = "brave-browser.desktop";
      "x-scheme-handler/unknown" = "brave-browser.desktop";

      # Images
      "image/jpeg" = "org.gnome.Loupe.desktop"; # Atau "gwenview.desktop"
      "image/png" = "org.gnome.Loupe.desktop";
      "image/gif" = "org.gnome.Loupe.desktop";
      "image/webp" = "org.gnome.Loupe.desktop";
      "image/svg+xml" = "org.gnome.Loupe.desktop";

      # Videos
      "video/mp4" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop"; # .mkv
      "video/webm" = "mpv.desktop";
      "video/mpeg" = "mpv.desktop";

      # Audio
      "audio/mpeg" = "mpv.desktop";
      "audio/flac" = "mpv.desktop";
      "audio/x-wav" = "mpv.desktop";
      "audio/ogg" = "mpv.desktop";

      # Documents
      "application/pdf" = "org.gnome.Evince.desktop"; # Atau "okular.desktop"
      "application/epub+zip" = "org.gnome.Evince.desktop";

      # Text files
      "text/plain" = "neovim.desktop"; # Atau "org.gnome.gedit.desktop"
      "text/markdown" = "neovim.desktop";

      # Archives
      "application/zip" = "org.gnome.FileRoller.desktop";
      "application/x-tar" = "org.gnome.FileRoller.desktop";
      "application/x-7z-compressed" = "org.gnome.FileRoller.desktop";

      # Code files
      "text/x-python" = "neovim.desktop";
      "text/x-shellscript" = "neovim.desktop";
      "application/javascript" = "neovim.desktop";
      "application/json" = "neovim.desktop";
    };

    # Associations (multiple apps untuk satu mime type)
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

  programs.spicetify =
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

  programs.zapzap.enable = true;
  programs.brave.enable = true;

  programs.vesktop = {
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
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

  };

  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
}
