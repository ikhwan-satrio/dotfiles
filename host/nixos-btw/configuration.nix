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
    ./root-modules/starship-root.nix
    inputs.noctalia.nixosModules.default
    inputs.nur.modules.nixos.default
    inputs.silentSDDM.nixosModules.default
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
    overlays = [
      inputs.nix-cachyos-kernel.overlays.pinned
    ];
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "wanto"
      ];
      substituters = [
        "https://cache.garnix.io"
        "https://attic.xuyh0120.win/lantian"
      ];
      trusted-public-keys = [
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      ];
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 3d";
    };
  };

  # ============================================================================
  # BOOT CONFIGURATION
  # ============================================================================

  boot = {
    # Plymouth splash screen
    plymouth = {
      enable = true;
      theme = "deus_ex";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "deus_ex" ];
        })
      ];
    };

    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-lts;
    consoleLogLevel = 3;
    initrd = {
      verbose = false;
      kernelModules = [ "i915" ];
    };
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
      "video=eDP-1:1920x1080@60"
      "vt.global_cursor_default=0"
      "loglevel=3"
      "rd.udev.log_level=3"
    ];

    # GRUB bootloader
    loader = {
      grub = rec {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        configurationLimit = 3;
        theme = inputs.distro-grub-themes.packages.${system}.nixos-grub-theme;
        splashImage = "${theme}/splash_image.jpg";
      };
      efi.canTouchEfiVariables = true;
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

  systemd.services = {
    # ============================================
    # Disable tty1 (untuk smooth Plymouth → SDDM)
    # ============================================
    "getty@tty1".enable = false;
    "autovt@tty1".enable = false;

    # ============================================
    # Enable tty2 (Ctrl+Alt+F2) untuk emergency
    # ============================================
    # Sudah enabled by default, tidak perlu explicit set
    # "getty@tty2".enable = true;  # optional

    # ============================================
    # Disable tty3-6 (tidak perlu banyak-banyak)
    # ============================================
    "getty@tty3".enable = false;
    "autovt@tty3".enable = false;

    "getty@tty4".enable = false;
    "autovt@tty4".enable = false;

    "getty@tty5".enable = false;
    "autovt@tty5".enable = false;

    "getty@tty6".enable = false;
    "autovt@tty6".enable = false;
  };

  services = {
    # Display Manager
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      extraPackages = with pkgs; [
        qt6Packages.qtsvg
        qt6Packages.qtmultimedia
        qt6Packages.qtvirtualkeyboard
      ];
      settings = {
        General = {
          DisplayServer = "wayland";
        };

        X11 = {
          ServerArguments = "-dpi 157";
        };
        Wayland = {
          SessionDir = "${pkgs.niri}/share/wayland-sessions";
        };
      };

    };

    gnome.gnome-keyring.enable = true;

    # Desktop services
    printing.enable = true;
    udisks2.enable = true;
    gvfs.enable = true;
    # gnome.evolution-data-server.enable = true;
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
    niri.enable = true;
    zsh.enable = true;
    # fish = {
    #   enable = false;
    #   shellInit = ''
    #     set -gx fish_variables_path $HOME/.local/share/fish/fish_variables
    #   '';
    # };
    silentSDDM = {
      enable = true;
      theme = "rei";
    };

    localsend = {
      enable = true;
      openFirewall = true;
    };
  };

  # ============================================================================
  # USERS
  # ============================================================================

  users.users.wanto = {
    isNormalUser = true;
    description = "wanto";
    shell = pkgs.zsh;
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
    # rustc
    # cargo
    # rust-analyzer
    bun
    deno
    pnpm
    nodePackages.vercel
    # gcc
    # jdk21
    # kotlin
    # gradle
    (python3.withPackages (pyPkgs: with pyPkgs; [ pygobject3 ]))
    devenv

    # PHP dev
    (php84.buildEnv {
      # nixf: ignore sema-primop-overridden
      extensions =
        { enabled, all }:
        enabled
        ++ (with all; [
          bcmath
          gd
          intl
          mysqli
          pdo_mysql
          redis
          zip
        ]);
    })
    php84Packages.composer

    # Container tools
    podman-compose
    podman-desktop

    # SDDM theme
    qt6Packages.qtsvg
    qt6Packages.qtmultimedia
    qt6Packages.qtvirtualkeyboard

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
    proton-vpn-cli
    xdg-terminal-exec

    # Editor and tools
    neovim
    wl-clipboard
    lua5_1
    luarocks
    tree-sitter
    unzip
    wget
    git
    trash-cli # command: trash
    glib # command: gio (GNOME)
    imagemagick # command: magick, convert
    ghostscript # command: gs
    tectonic
    nodePackages.mermaid-cli # command: mmdc
  ];

  # ============================================================================
  # ENVIRONMENT VARIABLES
  # ============================================================================

  environment.sessionVariables = {
    # JAVA_HOME = "${pkgs.jdk21}/lib/openjdk";
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
