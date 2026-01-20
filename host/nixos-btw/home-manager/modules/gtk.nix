{ pkgs, ... }:

{
  qt = {
    enable = true;
    platformTheme.name = "gtk3"; # atau qtct/kvantum
    style = {
      name = "kvantum";
      package = pkgs.catppuccin-kvantum;
    };
  };

  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };

    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
  };

}
