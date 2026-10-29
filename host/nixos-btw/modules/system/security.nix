{ ... }: {

  flake.nixosModules.security =
    {
      inputs,
      pkgs,
      lib,
      self,
      ...
    }:
    {
      networking = {
        hostName = "nixos-wanto";
        networkmanager = {
          enable = true;
        };
        firewall.allowedTCPPorts = [
          3000
          8000
          5173
          8080
          8081
          5050
          5432
        ];
      };

      security = {
        polkit.enable = true;
        rtkit.enable = true;
        pam.services.sddm.enableGnomeKeyring = true;
        doas.enable = true;
        sudo.extraConfig = ''
          Defaults pwfeedback
        '';
      };

    };
}
