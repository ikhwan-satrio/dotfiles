{ pkgs, ... }:

{
  home.username = "wanto";
  home.homeDirectory = "/home/wanto";

  home.packages = with pkgs; [
    nixfmt-rfc-style
    nil
  ];

  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
}
