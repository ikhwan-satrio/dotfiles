{
  description = "NixOS configuration with Noctalia";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs"; # ADD: Follow nixpkgs
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-plymouth.url = "github:BeatLink/nixos-plymouth";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    nur.url = "github:nix-community/NUR";
    distro-grub-themes.url = "github:AdisonCavani/distro-grub-themes";
    claude-code.url = "github:sadjow/claude-code-nix";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      ...
    }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.nixos-btw = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs system; };
        modules = [
          ./host/nixos-btw/configuration.nix
          inputs.home-manager.nixosModules.home-manager
        ];
      };
    };
}
