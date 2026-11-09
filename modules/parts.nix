{
  systems = [ "x86_64-linux" ];

  perSystem =
    {
      pkgs,
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          nil
          nixfmt
          statix
        ];
      };

      formatter = pkgs.nixfmt;
    };
}
