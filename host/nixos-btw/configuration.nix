{
  config,
  pkgs,
  inputs,
  lib,
  system,
  ...
}:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
    inputs.noctalia.nixosModules.default
  ];

  # ============================================================================
  # HOME MANAGER
  # ============================================================================

  home-manager.backupFileExtension = "hm-backup";
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit inputs; };
  home-manager.users.wanto = import ./home-manager/home.nix;

  # ============================================================================
  # NIX SETTINGS
  # ============================================================================

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [ inputs.s4rchiso-plymouth.overlays.default ];
  };

  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };

  # ============================================================================
  # BOOT CONFIGURATION
  # ============================================================================

  boot = {
    # Plymouth splash screen
    plymouth = {
      enable = true;
      theme = "mac-style";
      themePackages = [ pkgs.mac-style-plymouth ];
    };

    # Kernel parameters for quiet boot
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];

    # GRUB bootloader
    loader = {
      grub = rec {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        theme = inputs.distro-grub-themes.packages.${system}.nixos-grub-theme;
        splashImage = "${theme}/splash_image.jpg";
      };
      efi.canTouchEfiVariables = true;
    };

    # Tmpfs for better performance
    tmp = {
      useTmpfs = true;
      tmpfsSize = "4G";
    };
  };

  # ============================================================================
  # NETWORKING
  # ============================================================================

  networking = {
    hostName = "nixos-wanto";
    networkmanager.enable = true;
  };

  # ============================================================================
  # HARDWARE
  # ============================================================================

  hardware = {
    bluetooth.enable = true;
    cpu.intel.updateMicrocode = true;
  };

  # ============================================================================
  # SERVICES
  # ============================================================================

  services = {
    # Display Manager
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "sddm-astronaut-theme";
      extraPackages = with pkgs; [
        qt6Packages.qtsvg
        qt6Packages.qtmultimedia
        qt6Packages.qtvirtualkeyboard
        sddm-astronaut
      ];
    };

    # Desktop services
    printing.enable = true;
    udisks2.enable = true;
    gvfs.enable = true;
    gnome.evolution-data-server.enable = true;
    noctalia-shell.enable = true;
    flatpak.enable = true;

    # Power management
    power-profiles-daemon.enable = true;
    upower.enable = true;
    thermald.enable = true;

    # Audio
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    # X11 configuration
    xserver.xkb = {
      layout = "us";
      variant = "";
    };
  };

  # ============================================================================
  # SECURITY
  # ============================================================================

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  # Polkit authentication agent
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

  # ============================================================================
  # VIRTUALIZATION
  # ============================================================================

  virtualisation = {
    containers.enable = true;
    waydroid.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # ============================================================================
  # XDG PORTAL (Screen Sharing)
  # ============================================================================

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
      common.default = [ "gtk" ];
    };
  };

  # ============================================================================
  # LOCALIZATION
  # ============================================================================

  time.timeZone = "Asia/Jakarta";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
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
  };

  # ============================================================================
  # PROGRAMS
  # ============================================================================

  programs = {
    fish.enable = true;
    niri.enable = true;
  };

  # ============================================================================
  # USERS
  # ============================================================================

  users.users.wanto = {
    isNormalUser = true;
    description = "wanto";
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "wheel"
      "storage"
      "podman"
      "adbusers"
    ];
  };

  # ============================================================================
  # SYSTEM PACKAGES
  # ============================================================================

  environment.systemPackages = with pkgs; [
    # Development tools
    nodejs_22
    rustc
    cargo
    rust-analyzer
    bun
    gcc
    jdk21
    kotlin
    gradle
    (python3.withPackages (pyPkgs: with pyPkgs; [ pygobject3 ]))

    # Container tools
    podman-compose
    podman-desktop

    # SDDM theme
    qt6Packages.qtsvg
    qt6Packages.qtmultimedia
    qt6Packages.qtvirtualkeyboard
    sddm-astronaut

    # Niri/Desktop support
    bluez-tools
    bluez
    gnome-disk-utility
    polkit_gnome
    qt6Packages.qt6ct
    xwayland-satellite
    app2unit

    # System utilities
    efibootmgr
    gnome-keyring

    # Editor and tools
    neovim
    wl-clipboard
    lua5_1
    luarocks
    tree-sitter
    unzip
    wget
    git
    fish
  ];

  # ============================================================================
  # ENVIRONMENT VARIABLES
  # ============================================================================

  environment.sessionVariables = {
    JAVA_HOME = "${pkgs.jdk21}/lib/openjdk";
  };

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

  # ============================================================================
  # FONTS
  # ============================================================================

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];

  # ============================================================================
  # SYSTEM VERSION
  # ============================================================================

  system.stateVersion = "25.11";
}
