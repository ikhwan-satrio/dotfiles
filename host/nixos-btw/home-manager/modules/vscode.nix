{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        dracula-theme.theme-dracula
        vscodevim.vim
        yzhang.markdown-all-in-one
        pkief.material-icon-theme
      ];
      userSettings = {
        "editor.fontSize" = 14;
        "editor.tabSize" = 2;
        "files.autoSave" = "afterDelay";
        "workbench.colorTheme" = "Dracula Theme";
        "workbench.iconTheme" = "material-icon-theme";
        "security.passwordStore" = "basic";

        # JetBrains Mono Nerd Font untuk terminal
        "terminal.integrated.fontFamily" = "JetBrainsMono Nerd Font";
        "terminal.integrated.fontSize" = 14;

        # Sidebar di kanan
        "workbench.sideBar.location" = "right";

        # Activity bar (tombol extension, explorer, etc) di atas sidebar
        "workbench.activityBar.location" = "top";
      };
    };
  };
}
