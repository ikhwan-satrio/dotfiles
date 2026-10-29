{ ... }: {

  flake.nixosModules.services =
    {
      inputs,
      pkgs,
      lib,
      self,
      ...
    }:
    {
      services = {
        playerctld.enable = true;

        ollama = {
          enable = true;
          package = pkgs.ollama-vulkan;
        };

        fstrim = {
          enable = true;
          interval = "weekly";
        };

        irqbalance.enable = true;

        # Display Manager
        displayManager = {
          sddm = {
            enable = true;
            theme = "pixie";

            package = pkgs.kdePackages.sddm;

            # Required dependencies for Qt6 themes
            extraPackages = [
              pkgs.kdePackages.qtsvg
              pkgs.kdePackages.qtdeclarative
              pkgs.kdePackages.qt5compat
            ];

            settings = {
              Theme = {
                CursorSize = 24;
              };
            };
          };
        };

        # X Server configuration
        xserver = {
          enable = true;
          videoDrivers = [ "modesetting" ];

          xkb = {
            layout = "us";
            variant = "";
          };
        };

        gnome = {
          gnome-keyring.enable = true;
        };

        # Desktop services
        printing.enable = true;
        udisks2.enable = true;
        gvfs.enable = true;
        flatpak.enable = true;

        # Power management
        power-profiles-daemon.enable = false;
        tuned.enable = true;
        upower.enable = true;

        # Audio
        pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
          wireplumber.enable = true;
        };
      };

    };
}
