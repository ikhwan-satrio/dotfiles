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

    # themes
    papirus-icon-theme
    bibata-cursors
  ];

  programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
    in
    {
      enable = true;

      theme = spicePkgs.themes.nightlight;

      enabledExtensions = with spicePkgs.extensions; [
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
