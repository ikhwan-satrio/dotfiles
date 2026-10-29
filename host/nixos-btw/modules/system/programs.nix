{ ... }: {

  flake.nixosModules.programs =
    {
      inputs,
      pkgs,
      lib,
      self,
      ...
    }:
    {
      programs = {
        niri.enable = false;
        sway = {
          enable = true;
          extraPackages = lib.mkForce [ ];
        };
        xwayland = {
          enable = true;
        };
        fish = {
          enable = true;
          shellInit = ''
            set fish_greeting # Disable greeting
            set -gx fish_variables_path $HOME/.local/share/fish/fish_variables
          '';
        };
        direnv.enable = true;
        localsend = {
          enable = true;
          openFirewall = true;
        };
        steam = {
          enable = true;
          remotePlay.openFirewall = true;
          dedicatedServer.openFirewall = true;
          localNetworkGameTransfers.openFirewall = true;
          extraCompatPackages = with pkgs; [
            proton-ge-bin
          ];
        };

        obs-studio = {
          enable = true;
          plugins = with pkgs.obs-studio-plugins; [
            wlrobs
            obs-pipewire-audio-capture
            obs-vaapi
            obs-gstreamer
          ];
        };
      };
    };
}
