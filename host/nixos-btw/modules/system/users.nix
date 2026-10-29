{ ... }: {

  flake.nixosModules.users =
    {
      inputs,
      pkgs,
      lib,
      self,
      ...
    }:
    {
      users.users.wanto = {
        isNormalUser = true;
        description = "wanto";
        shell = pkgs.fish;
        extraGroups = [
          "networkmanager"
          "wheel"
          "storage"
          "podman"
          "adbusers"
          "dialout"

          "video" # Hardware video acceleration
          "render" # GPU rendering access
        ];
      };
    };
}
