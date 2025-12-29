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

        "text/html" = "vivaldi-stable.desktop";
        "x-scheme-handler/http" = "vivaldi-stable.desktop";
        "x-scheme-handler/https" = "vivaldi-stable.desktop";
        "x-scheme-handler/about" = "vivaldi-stable.desktop";
        "x-scheme-handler/unknown" = "vivaldi-stable.desktop";
      };
      associations.added = {
        "image/png" = [
          "org.gnome.Loupe.desktop"
          "swappy.desktop"
        ];
        "text/plain" = [
          "neovim.desktop"
          "org.gnome.gedit.desktop"
        ];
      };
    };
  };

}
