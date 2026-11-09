{ self, inputs, ... }:
let
  system = "x86_64-linux";
in
{
  flake.nixosConfigurations.nixos-btw = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs system; };
    modules = [
      self.nixosModules.base
      /etc/nixos/hardware-configuration.nix
      {
        networking.hostName = "nixos-wanto";
      }
    ];
  };
}
