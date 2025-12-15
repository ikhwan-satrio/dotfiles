{ pkgs, ... }:

{
  home.username = "wanto";
  home.homeDirectory = "/home/wanto";

  home.packages = with pkgs; [
    nixfmt-rfc-style
    nil
    lua-language-server

    #themes
    papirus-icon-theme
    bibata-cursors
  ];

  programs.zapzap.enable = true;

  gtk = {
    enable = true;
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
