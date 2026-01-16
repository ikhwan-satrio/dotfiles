{
  programs.discord = {
    enable = false;
    settings = {
      arRPC = "on"; # UBAH: dari true ke "on"
      withOpenASAR = true;
    };
  };

  programs.vesktop = {
    enable = true;
    settings = {
      appBadge = true;
      arRPC = "on"; # UBAH: dari true ke "on"
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
        CustomRPC.enable = true; # Ini penting untuk RPC
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
}
