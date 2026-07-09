{
  lib,
  inputs,
  pkgs,
  ...
}:
{

  imports = [ inputs.spicetify-nix.homeManagerModules.spicetify ];

  # programs.spicetify =
  #   let
  #     spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
  #   in
  #   {
  #     enable = true;
  #
  #     theme = spicePkgs.themes.comfy;
  #
  #     colorScheme = "Lunar";
  #     enabledExtensions = with spicePkgs.extensions; [
  #       beautifulLyrics
  #       shuffle
  #       adblock
  #       fullAppDisplay
  #     ];
  #   };
}
