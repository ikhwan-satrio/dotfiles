{ config, ... }:

let
  terminal = "wezterm.desktop";
  browser = "zen.desktop";
  filepicker = "yazi.desktop";
  editor = "neovim.desktop";
in
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
    terminal-exec = {
      settings = {
        default = [ terminal ];
      };
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        # File manager
        "inode/directory" = [ filepicker ];
        # Text editor
        "text/plain" = editor;
        "text/markdown" = editor;
        "text/x-python" = editor;
        "text/x-shellscript" = editor;
        "application/javascript" = editor;
        "application/json" = editor;
        # Web browser - Zen Browser
        "text/html" = browser;
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;
        "x-scheme-handler/about" = browser;
        "x-scheme-handler/unknown" = browser;
        "x-scheme-handler/chrome" = browser;
        "application/x-extension-htm" = browser;
        "application/x-extension-html" = browser;
        "application/x-extension-shtml" = browser;
        "application/xhtml+xml" = browser;
        "application/x-extension-xhtml" = browser;
        "application/x-extension-xht" = browser;
      };
      associations.added = {
        "image/png" = [
          "org.gnome.Loupe.desktop"
          "swappy.desktop"
        ];
        "text/plain" = [
          editor
          "org.gnome.gedit.desktop"
        ];
      };
    };
  };
}
