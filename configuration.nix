{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
    inputs.noctalia.nixosModules.default
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ]; # Atau "daily", "03:45"
  };

  boot = {
    plymouth = {
      enable = true;
      theme = "mac-style";
      themePackages = [ pkgs.mac-style-plymouth ];
    };

    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5; # Hanya show 4 generasi terakhir
      };
      efi.canTouchEfiVariables = true;
    };
  };

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true; # Required untuk Bluetooth
  services.printing.enable = true; # Jika tidak print
  services.udisks2.enable = true;
  services.gvfs.enable = true; # GNOME Virtual File System
  services.gnome.evolution-data-server.enable = true;
  services.noctalia-shell.enable = true;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    extraPackages = with pkgs; [
      qt6Packages.qtsvg
      qt6Packages.qtmultimedia
      qt6Packages.qtvirtualkeyboard
      sddm-astronaut
    ];
    theme = "sddm-astronaut-theme";
  };

  # === power and cpu optimization ===
  services.power-profiles-daemon.enable = true; # Required untuk Power Profile
  services.upower.enable = true; # Required untuk Battery

  # Thermald (Intel thermal management)
  services.thermald.enable = true;

  # CPU microcode updates
  hardware.cpu.intel.updateMicrocode = true; # Ganti ke amd jika pakai AMD

  virtualisation = {
    containers.enable = true;
    waydroid.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
    };
  };

  # Flatpak support
  services.flatpak.enable = true;

  # screen sharing
  xdg.portal = {
    enable = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];

    config = {
      niri = {
        default = [
          "gnome"
          "gtk"
        ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
        "org.freedesktop.impl.portal.RemoteDesktop" = [ "gnome" ];
      };
      common = {
        default = [ "gtk" ];
      };
    };
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    wireplumber.enable = true; # Tambahkan ini untuk session management
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Load bluetooth modules
  services.pulseaudio = {
    enable = false;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
  };

  security.polkit.enable = true;
  security.rtkit.enable = true; # Tambahkan untuk realtime audio

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # locales
  time.timeZone = "Asia/Jakarta";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "id_ID.UTF-8";
    LC_IDENTIFICATION = "id_ID.UTF-8";
    LC_MEASUREMENT = "id_ID.UTF-8";
    LC_MONETARY = "id_ID.UTF-8";
    LC_NAME = "id_ID.UTF-8";
    LC_NUMERIC = "id_ID.UTF-8";
    LC_PAPER = "id_ID.UTF-8";
    LC_TELEPHONE = "id_ID.UTF-8";
    LC_TIME = "id_ID.UTF-8";
  };

  programs.fish.enable = true;
  programs.niri.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.wanto = {
    isNormalUser = true;
    description = "wanto";
    extraGroups = [
      "networkmanager"
      "wheel"
      "storage"
      "podman"
    ];
    packages = with pkgs; [ ];
    shell = pkgs.fish;
  };

  environment.systemPackages = with pkgs; [
    nodejs_22
    fish
    rustc
    cargo
    bun
    gcc
    android-tools
    efibootmgr
    gnome-keyring
    (python3.withPackages (pyPkgs: with pyPkgs; [ pygobject3 ]))

    # podman
    podman-compose
    podman-desktop

    # sddm
    qt6Packages.qtsvg
    qt6Packages.qtmultimedia
    qt6Packages.qtvirtualkeyboard
    sddm-astronaut

    # niri support
    bluez-tools
    bluez
    gnome-disk-utility
    polkit_gnome
    qt6Packages.qt6ct
    xwayland-satellite
    app2unit

    # neovim
    wl-clipboard
    lua5_1
    luarocks
    tree-sitter
    unzip
    wget
    git
    neovim
  ];

  environment.variables = {
    QT_QPA_PLATFORMTHEME = "qt6ct";
    GI_TYPELIB_PATH = lib.makeSearchPath "lib/girepository-1.0" (
      with pkgs;
      [
        evolution-data-server
        libical
        glib.out
        libsoup_3
        json-glib
        gobject-introspection
      ]
    );

  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];

  system.stateVersion = "25.11";
}
