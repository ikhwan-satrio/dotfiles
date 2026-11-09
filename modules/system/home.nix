{ ... }: {

  flake.nixosModules.home =
    {
      inputs,
      pkgs,
      lib,
      self,
      ...
    }:
    {

      imports = [
        inputs.home-manager.nixosModules.home-manager
      ];

      home-manager.backupFileExtension = "hm-backup";
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = { inherit inputs; };
      home-manager.users.wanto = import ../../home-manager/home.nix;
    };
}
