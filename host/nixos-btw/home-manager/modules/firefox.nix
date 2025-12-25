{ connfig, pkgs, ... }:

let
  firefoxTheme = pkgs.fetchFromGitHub {
    owner = "mimipile";
    repo = "firefoxCSS";
    rev = "main"; # atau specify commit hash untuk reproducibility
    sha256 = "sha256-RMbEW7VSk79NO+5AklXYkjtyvfYvDdhqJU4qLGnmQ+s=";
  };

  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
in
{

  programs.firefox = {
    enable = true;
    nativeMessagingHosts = [ pkgs.uget-integrator ];

    profiles = {
      default = {
        id = 0;
        name = "wanto";
        isDefault = true;
        userChrome = builtins.readFile "${firefoxTheme}/userChrome.css";

        extensions.force = true;
      };
    };

    policies = {
      DisplayBookmarksToolbar = "never";

      ExtensionSettings = {
        "*".installation_mode = "allowed";
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        # dst...
      };

      Preferences = {
        "sidebar.verticalTab" = lock-true;
        "sidebar.revamp" = lock-true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = lock-true;
      };
    };
  };
}
