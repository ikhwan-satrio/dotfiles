{
  inputs,
  self,
  ...
}:
{
  systems = [ "x86_64-linux" ];

  perSystem =
    {
      system,
      pkgs,
      inputs',
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          nil
          nixfmt-rfc-style
          statix
        ];
      };

      formatter = pkgs.nixfmt-rfc-style;
    };

  flake.nixosConfigurations.nixos-btw = inputs.nixpkgs.lib.nixosSystem rec {
    system = "x86_64-linux";
    specialArgs = { inherit inputs system; };
    modules = with self.nixosModules; [
      base
    ];
  };
}
