{ config, ... }:

{
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
    };

    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = "org.gnome.Nautilus.desktop";
        "text/plain" = "neovim.desktop";
        "text/markdown" = "neovim.desktop";
        "text/x-python" = "neovim.desktop";
        "text/x-shellscript" = "neovim.desktop";
        "application/javascript" = "neovim.desktop";
        "application/json" = "neovim.desktop";
      };
      associations.added = {
        "image/png" = [
          "org.gnome.Loupe.desktop"
          "gimp.desktop"
        ];
        "text/plain" = [
          "neovim.desktop"
          "org.gnome.gedit.desktop"
        ];
      };
    };
  };

}
