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
    gtk4 = {
      theme = {
        name = "catppuccin-mocha-blue-standard+default";
        package = pkgs.catppuccin-gtk.override {
          accents = [ "blue" ];
          size = "standard";
          variant = "mocha";
        };
      };
    };
    gtk3 = {
      theme = {
        name = "catppuccin-mocha-blue-standard+default";
        package = pkgs.catppuccin-gtk.override {
          accents = [ "blue" ];
          size = "standard";
          variant = "mocha";
        };
      };
    };
    gtk2 = {
      theme = {
        name = "catppuccin-mocha-blue-standard+default";
        package = pkgs.catppuccin-gtk.override {
          accents = [ "blue" ];
          size = "standard";
          variant = "mocha";
        };
      };
    };
  };
}
