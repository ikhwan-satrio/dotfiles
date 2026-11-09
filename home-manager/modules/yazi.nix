{ pkgs, lib, ... }:

{
  programs.yazi = {
    enable = true;
    plugins = {
      inherit (pkgs.yaziPlugins) mount omni-trash;
    };

    settings = {
      keymap = ''
        [[mgr.prepend_keymap]]
        on   = "R"
        run  = "plugin omni-trash"
        desc = "Open Omni Trash"

        [[mgr.prepend_keymap]]
        on = "M"
        run = "plugin mount"
        desc = "Mount/unmount/eject disk"
      '';
    };
  };
}
