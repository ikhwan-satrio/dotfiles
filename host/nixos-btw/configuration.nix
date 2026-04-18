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
    inputs.nixos-plymouth.nixosModules.default
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

  documentation = {
    nixos.enable = false; # Disable NixOS manual

    # Keep man pages & info
    man.enable = true;
    info.enable = true;
    doc.enable = true;
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      inputs.nix-cachyos-kernel.overlays.pinned
      inputs.claude-code.overlays.default
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
      # theme = "deus_ex";
      # themePackages = with pkgs; [
      #   (adi1090x-plymouth-themes.override {
      #     selected_themes = [ "deus_ex" ];
      #   })
      # ];
    };
    
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-lts;
    consoleLogLevel = 3;
    initrd = {
      verbose = false;
      kernelModules = [
        "i915"
      ];
    };
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
      "video=eDP-1:1920x1080@60"
      "loglevel=3"
      "rd.udev.log_level=3"

      "i915.enable_guc=3" # Enable GuC/HuC firmware
      "i915.force_probe=46a3" # Force probe Alder Lake GPU
      "i915.enable_fbc=1" # framebuffer compression, hemat memory bandwidth
      "i915.enable_psr=2" # panel self refresh (bagus untuk laptop)
    ];

    # GRUB bootloader
    loader = {
      grub = rec {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        configurationLimit = 3;
        extraEntriesBeforeNixOS = true;
        theme = inputs.distro-grub-themes.packages.${system}.nixos-grub-theme;
        splashImage = "${theme}/splash_image.jpg";
      };
      efi.canTouchEfiVariables = true;
    };

    tmp = {
      useTmpfs = true;
      tmpfsSize = "4G";
      cleanOnBoot = true;
    };
  };

  # ============================================================================
  # SPECIALIZATIONS
  # ============================================================================

  # ============================================================================
  # NETWORKING
  # ============================================================================

  networking = {
    hostName = "nixos-wanto";
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 3000 ];
  };

  # ============================================================================
  # HARDWARE
  # ============================================================================

  hardware = {
    bluetooth.enable = true;
    cpu.intel.updateMicrocode = true;

    # Enable firmware updates
    enableRedistributableFirmware = true;

    # Intel Graphics Hardware Acceleration
    graphics = {
      enable = true;
      enable32Bit = true;

      extraPackages = with pkgs; [
        # Modern Intel GPUs (Gen 12+, Alder Lake)
        libvdpau-va-gl # VDPAU via VA-API
        intel-vaapi-driver # fallback driver i965
        intel-media-driver # VAAPI (iHD) - hardware video decode/encode
        intel-compute-runtime # OpenCL & Level Zero compute
        vpl-gpu-rt # oneVPL - Quick Sync Video runtime
      ];
    };
  };

  # ============================================================================
  # SERVICES
  # ============================================================================

  services = {
    ollama = {
      enable = true;
    };

    # Display Manager
    displayManager = {
      ly = {
        enable = true;
        x11Support = true;
        # settings = {
        #   animation = "matrix";
        # };
      };
    };

    throttled = {
      enable = true;
      extraConfig = ''
        [GENERAL]
        Enabled: True
        Sysfs_Power_Path: /sys/class/power_supply/AC*/online
        Update_Rate_s: 5

        [BATTERY]
        PL1_Tdp_W: 15
        PL1_Duration_s: 28
        PL2_Tdp_W: 20
        PL2_Duration_s: 0.002
        Trip_Temp_C: 85
        Update_Rate_s: 5

        [AC]
        PL1_Tdp_W: 28
        PL1_Duration_s: 28
        PL2_Tdp_W: 35
        PL2_Duration_s: 0.002
        Trip_Temp_C: 95
        Update_Rate_s: 5
      '';
    };
    
    cockpit = {
      enable = true;
      port = 9090;
      plugins = with pkgs; [
        cockpit-podman
        cockpit-machines
      ];
      settings = {
        WebService = {
          AllowUnencrypted = true; # kalau tidak pakai HTTPS
        };
      };
    };

    # X Server configuration
    xserver = {
      # Intel modesetting driver
      videoDrivers = [ "modesetting" ];

      xkb = {
        layout = "us";
        variant = "";
      };
    };

    gnome = {
      gnome-keyring.enable = true;
    };

    # Desktop services
    printing.enable = true;
    udisks2.enable = true;
    gvfs.enable = true;
    noctalia-shell = {
      enable = true;
    };
    flatpak.enable = true;

    # Power management
    power-profiles-daemon.enable = false;
    tuned.enable = true;
    upower.enable = true;

    # Audio
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
  };

  # ============================================================================
  # SECURITY
  # ============================================================================

  security = {
    polkit.enable = true;
    rtkit.enable = true;

    sudo.extraConfig = ''
      Defaults pwfeedback
    '';
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
      xdg-desktop-portal-hyprland
    ];
    config = {
      common.default = [ "hyprland" ];
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
    # niri.enable = true;
    hyprland.enable = true;
    zsh.enable = true;
    # fish = {
    #   enable = false;
    #   shellInit = ''
    #     set -gx fish_variables_path $HOME/.local/share/fish/fish_variables
    #   '';
    # };
    # adb.enable = true;
    localsend = {
      enable = true;
      openFirewall = true;
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
      package = pkgs.steam.override {
        extraArgs = "-system-composer";
      };
    };
  };

  # ============================================================================
  # GAMING
  # ============================================================================
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
        inhibit_screensaver = 1;
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
      };
      cpu = {
        park_cores = "no";
        pin_cores = "yes";
      };
    };
  };

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642;
    "vm.swappiness" = 10;
    "kernel.sched_autogroup_enabled" = 0;
    "net.core.rmem_max" = 2500000;
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

      "video" # Hardware video acceleration
      "render" # GPU rendering access
    ];
  };

  # ============================================================================
  # SYSTEM PACKAGES
  # ============================================================================

  environment.systemPackages = with pkgs; [
    # Development tools
    nodejs_22
    gcc
    android-tools
    bun
    deno
    pnpm
    gnumake
    zig
    unzip
    wget
    curl
    uv
    jdk21
    kotlin
    gradle
    go

    # Gaming
    steam
    steam-run
    mangohud # overlay FPS, GPU, CPU usage
    gamemode # optimasi performa saat gaming

    # PHP & Composer
    php85
    php85Packages.composer
    php85Extensions.zip
    php85Extensions.curl
    php85Extensions.openssl
    php85Extensions.pdo_mysql
    php85Extensions.gd
    php85Extensions.intl
    php85Extensions.mbstring
    php85Extensions.bcmath
    php85Extensions.sockets
    php85Extensions.pdo_sqlite

    # Container tools
    podman-compose
    # qemu
    # libvirt

    #cockpit utility
    cockpit-podman
    cockpit
    cockpit-machines
    # virt-viewer

    # Hyprland/Desktop support
    hyprpolkitagent
    hyprshot
    bibata-cursors
    bluez-tools
    bluez
    gnome-disk-utility
    qt6Packages.qt6ct
    qt6Packages.qtstyleplugin-kvantum
    xwayland-satellite
    app2unit

    # System utilities
    efibootmgr
    gnome-keyring
    proton-vpn-cli
    xdg-terminal-exec

    # Editor and tools
    tmux
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
    mermaid-cli
    ripgrep # rg (grep super cepat)
    fd # fd (find modern)
    sqlite # SQLite3 (frecency/history)
    claude-code-bun
  ];

  # ============================================================================
  # ENVIRONMENT VARIABLES
  # ============================================================================

  environment.sessionVariables = {
    # Locale passthrough
    # LANG = config.i18n.defaultLocale;
    # LC_ALL = config.i18n.defaultLocale;

    # Timezone passthrough
    # TZ = config.time.timeZone;

    JAVA_HOME = "${pkgs.jdk21}/lib/openjdk";
    DXVK_FRAME_RATE = "60";
    VDPAU_DRIVER = "va_gl";
    __GLX_VENDOR_LIBRARY_NAME = "mesa";
    WLR_NO_HARDWARE_CURSORS = "1"; # fix cursor glitch di Hyprland/Niri
    LIBVA_DRIVER_NAME = "iHD"; # Force modern iHD backend
  };

  environment.variables = {
    TMPDIR = "/tmp";
    QT_QPA_PLATFORMTHEME = "qt6ct";
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

  system.stateVersion = "26.05";
}
