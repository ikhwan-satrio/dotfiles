{ self, ... }:
{
  flake.nixosModules.base =
    {
      inputs,
      pkgs,
      lib,
      ...
    }:
    let
      modules = with self.nixosModules; [
        boot
        env
        gaming
        hardware
        home
        local
        packages
        programs
        security
        services
        users
        virtualization
        xdg
      ];
    in
    {
      imports = [
        /etc/nixos/hardware-configuration.nix
        inputs.noctalia.nixosModules.default
        inputs.nixos-plymouth.nixosModules.default
      ]
      ++ modules;

      documentation = {
        nixos.enable = false;

        man.enable = true;
        info.enable = true;
        doc.enable = true;
      };

      nixpkgs = {
        config.permittedInsecurePackages = [
          "beekeeper-studio-6.1.4"
          "nodejs-20.20.2"
          "nodejs-slim-20.20.2"
        ];
        config.allowUnfree = true;
        config.android_sdk.accept_license = true;
        overlays = [
          inputs.rust-overlay.overlays.default
          (final: prev: {
            mozc-server = prev.mozc-server.overrideAttrs (oldAttrs: {
              postPatch =
                builtins.replaceStrings
                  [ "src/gui/dictionary_tool/dictionary_tool.ui" ]
                  [ "src/gui/dictionary_tool/nonexistent_file_to_silence_error" ]
                  (oldAttrs.postPatch or "");
            });
          })

        ];
      };

      nix = {
        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          trusted-users = [
            "root"
            "wanto"
          ];

          max-jobs = "auto";
          cores = 0;
        };
        optimise = {
          automatic = true;
          dates = [ "weekly" ];
        };

        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 3d";
        };
      };

      system.stateVersion = "26.05";
    };
}
