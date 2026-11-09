{ ... }: {

  flake.nixosModules.local =
    {
      inputs,
      pkgs,
      lib,
      self,
      ...
    }:
    {
      time.timeZone = "Asia/Jakarta";

      i18n = {
        supportedLocales = [
          "en_US.UTF-8/UTF-8"
          "id_ID.UTF-8/UTF-8"
          "ja_JP.UTF-8/UTF-8"
        ];
        defaultLocale = "en_US.UTF-8";
        extraLocaleSettings = {
          LC_ADDRESS = "id_ID.UTF-8";
          LC_IDENTIFICATION = "id_ID.UTF-8";
          LC_MEASUREMENT = "id_ID.UTF-8";
          LC_MONETARY = "id_ID.UTF-8";
          LC_NAME = "id_ID.UTF-8";
          LC_NUMERIC = "id_ID.UTF-8";
          LC_PAPER = "id_ID.UTF-8";
          LC_TELEPHONE = "id_ID.UTF-8";
          LC_TIME = "id_ID.UTF-8";
        };
        inputMethod = {
          enable = true;
          type = "fcitx5";
          fcitx5 = {
            waylandFrontend = true;
            addons = with pkgs; [
              fcitx5-mozc
              fcitx5-gtk
              qt6Packages.fcitx5-configtool
            ];
            settings.inputMethod = {
              GroupOrder."0" = "Default";
              "Groups/0" = {
                Name = "Default";
                "Default Layout" = "us";
                DefaultIM = "keyboard-us";
              };
              "Groups/0/Items/0".Name = "keyboard-us";
              "Groups/0/Items/1".Name = "mozc";
            };
            ignoreUserConfig = true;
          };
        };
      };

    };
}
