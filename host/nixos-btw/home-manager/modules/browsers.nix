{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  extension = shortId: guid: {
    name = guid;
    value = {
      install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
      installation_mode = "normal_installed";
    };
  };

  prefs = {
    "extensions.autoDisableScopes" = 0;
    "extensions.pocket.enabled" = false;

    # Privacy & Security
    "browser.contentblocking.category" = "strict";
    "privacy.trackingprotection.enabled" = true;
    "privacy.trackingprotection.socialtracking.enabled" = true;
    "privacy.donottrackheader.enabled" = true;

    # Performance
    "browser.cache.disk.enable" = false;
    "browser.cache.memory.enable" = true;
    "browser.cache.memory.capacity" = 524288;

    # Disable telemetry
    "datareporting.healthreport.uploadEnabled" = false;
    "toolkit.telemetry.enabled" = false;
    "toolkit.telemetry.unified" = false;
    "toolkit.telemetry.archive.enabled" = false;

    # Smooth scrolling
    "general.smoothScroll" = true;
    "mousewheel.default.delta_multiplier_y" = 275;

    # Enable userChrome.css
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

    # Hardware acceleration
    "gfx.webrender.all" = true;
    "media.ffmpeg.vaapi.enabled" = true;
    "layers.acceleration.force-enabled" = true;
  };

  extensions = [
    # Ad blocking
    (extension "ublock-origin" "uBlock0@raymondhill.net")

    # Password manager
    (extension "bitwarden-password-manager" "{446900e4-71c2-419f-a6a7-df9c091e268b}")

    # Dark mode
    (extension "darkreader" "addon@darkreader.org")

    # Privacy
    # (extension "privacy-badger17" "jid1-MnnxcxisBPnSXQ@jetpack")
    # (extension "decentraleyes" "jid1-BoFifL9Vbdl2zQ@jetpack")

    # Userscript manager
    # (extension "violentmonkey" "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}")

    # Video downloader
    # (extension "video-downloadhelper" "{b9db16a4-6edc-47ec-a1f4-b86292ed211d}")

    # Translator
    # (extension "traduzir-paginas-web" "{036a55b4-5e72-4d05-a06c-cba2dfcc134a}")

    # Tab management
    # (extension "tree-style-tab" "treestyletab@piro.sakura.ne.jp")

    # Bypass paywalls
    # (extension "bypass-paywalls-clean" "magnolia@12.34")
  ];

in
{
  home.packages = [
    (pkgs.wrapFirefox
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.zen-browser-unwrapped
      {
        extraPrefs = lib.concatLines (
          lib.mapAttrsToList (
            name: value: ''lockPref(${lib.strings.toJSON name}, ${lib.strings.toJSON value});''
          ) prefs
        );

        extraPolicies = {
          DisableTelemetry = true;
          ExtensionSettings = builtins.listToAttrs extensions;

          SearchEngines = {
            Default = "DuckDuckGo";
            Add = [
              {
                Name = "nixpkgs packages";
                URLTemplate = "https://search.nixos.org/packages?query={searchTerms}";
                IconURL = "https://wiki.nixos.org/favicon.ico";
                Alias = "@np";
              }
              {
                Name = "NixOS options";
                URLTemplate = "https://search.nixos.org/options?query={searchTerms}";
                IconURL = "https://wiki.nixos.org/favicon.ico";
                Alias = "@no";
              }
              {
                Name = "NixOS Wiki";
                URLTemplate = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
                IconURL = "https://wiki.nixos.org/favicon.ico";
                Alias = "@nw";
              }
              {
                Name = "noogle";
                URLTemplate = "https://noogle.dev/q?term={searchTerms}";
                IconURL = "https://noogle.dev/favicon.ico";
                Alias = "@ng";
              }
              {
                Name = "GitHub";
                URLTemplate = "https://github.com/search?q={searchTerms}";
                IconURL = "https://github.com/favicon.ico";
                Alias = "@gh";
              }
            ];
          };
        };
      }
    )
  ];

  programs = {
    vivaldi = {
      enable = false;
    };
  };
}
