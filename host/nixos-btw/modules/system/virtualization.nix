{ ... }: {

  flake.nixosModules.virtualization =
    {
      inputs,
      pkgs,
      lib,
      self,
      ...
    }:
    {
      virtualisation = {
        containers.enable = true;
        waydroid.enable = false;
        podman = {
          enable = true;
          dockerSocket.enable = true;
          dockerCompat = true;
          defaultNetwork.settings.dns_enabled = true;
        };
      };

    };
}
