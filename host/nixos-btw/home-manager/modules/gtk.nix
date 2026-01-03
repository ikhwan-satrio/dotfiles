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
      name = "Tokyonight-Dark";
      package = pkgs.tokyonight-gtk-theme;
    };
  };

}
