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
      theme = "deus_ex";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "deus_ex" ];
        })
      ];
    };

    # Kernel parameters for quiet boot
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

  systemd.services."sddm-avatar" = {
    description = "Service to copy or update users Avatars at startup.";
    wantedBy = [ "multi-user.target" ];
    before = [ "sddm.service" ];
    script = ''
      set -eu
      for user in /home/*; do
          username=$(basename "$user")
          if [ -f "$user/.face.icon" ]; then
              if [ ! -f "/var/lib/AccountsService/icons/$username" ]; then
                  cp "$user/.face.icon" "/var/lib/AccountsService/icons/$username"
              else
                  if [ "$user/.face.icon" -nt "/var/lib/AccountsService/icons/$username" ]; then
                      cp "$user/.face.icon" "/var/lib/AccountsService/icons/$username"
                  fi
              fi
          fi
      done
    '';
    serviceConfig = {
      Type = "simple";
      User = "root";
      StandardOutput = "journal+console";
      StandardError = "journal+console";
    };
  };

  systemd.services.sddm = {
    after = [ "sddm-avatar.service" ];
  };

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
          # Set DPI untuk 1920x1080 @ 310mm
          ServerArguments = "-dpi 157"; # calculated DPI untuk monitor kamu
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
      openFirewall = true; # Buka port 53317 TCP/UDP otomatis
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
    rustc
    cargo
    rust-analyzer
    bun
    gcc
    jdk21
    kotlin
    gradle
    (python3.withPackages (pyPkgs: with pyPkgs; [ pygobject3 ]))
    (inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
      calendarSupport = true;
    })

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
    tectonic # Lebih modern, recommended
    nodePackages.mermaid-cli # command: mmdc
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
