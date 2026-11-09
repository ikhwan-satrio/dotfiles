{ ... }: {

  flake.nixosModules.xdg =
    {
      inputs,
      pkgs,
      lib,
      self,
      ...
    }:
    {
      xdg.portal = {
        enable = true;
        wlr.settings.screencast = {
          chooser_type = "dmenu";
          chooser_cmd = "${pkgs.fuzzel}/bin/fuzzel --dmenu";
          max_fps = 30;
        };
        extraPortals = with pkgs; [
          xdg-desktop-portal-wlr
          xdg-desktop-portal-termfilechooser
        ];
        config = {
          sway = {
            default = lib.mkForce [
              "wlr"
              "gtk"
            ];
            "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
            "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
          };
        };
      };

      environment.etc."xdg/xdg-desktop-portal-termfilechooser/config".text = ''
        [filechooser]
        cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
        default_dir=$HOME
      '';

    };
}
