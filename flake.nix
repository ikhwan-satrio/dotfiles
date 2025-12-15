{
  description = "NixOS configuration with Noctalia";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, ... }: {
    nixosConfigurations.awesomebox = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";  # Tambahkan baris ini
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        ./noctalia.nix
      ];
    };
  };
}
