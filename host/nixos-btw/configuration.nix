{
  # config,
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
    nixos.enable = false;

    man.enable = true;
    info.enable = true;
    doc.enable = true;
  };

  nixpkgs = {
    config.permittedInsecurePackages = [
      "nodejs-20.20.2"
      "nodejs-slim-20.20.2"
    ];
    config.allowUnfree = true;
    config.android_sdk.accept_license = true;
    overlays = [
      inputs.rust-overlay.overlays.default
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

      max-jobs = "auto";
      cores = 0;
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
    };

    kernelPackages = pkgs.linuxPackages_latest;
    # kernelPackages = pkgs.linuxKernel.packages.linux_6_18;
    consoleLogLevel = 3;
    initrd = {
      verbose = false;
      kernelModules = [
        "ideapad_laptop"
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
      "i915.enable_psr=1" # panel self refresh (bagus untuk laptop)
    ];

    # GRUB bootloader
    loader = {
      grub = rec {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = false;
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
    networkmanager = {
      enable = true;
    };
    firewall.allowedTCPPorts = [
      3000
      8000
      5173
      8080
      8081
    ];
  };

  # ============================================================================
  # HARDWARE
  # ============================================================================

  zramSwap = {
    enable = true;
    priority = 100;
    algorithm = "zstd";
    memoryPercent = 50;
  };

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
        vulkan-loader
        mesa

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
    playerctld.enable = true;
    
    ollama = {
      enable = true;
      package = pkgs.ollama-vulkan;
    };

    fstrim = {
      enable = true;
      interval = "weekly";
    };

    irqbalance.enable = true;

    # Display Manager
    displayManager = {
      sddm = {
        enable = true;
        theme = "pixie";

        package = pkgs.kdePackages.sddm;

        # Required dependencies for Qt6 themes
        extraPackages = [
          pkgs.kdePackages.qtsvg
          pkgs.kdePackages.qtdeclarative
          pkgs.kdePackages.qt5compat
        ];

        settings = {
          Theme = {
            CursorSize = 24;
          };
        };
      };
    };

    # X Server configuration
    xserver = {
      enable = true;
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
  # SYSTEMD SERVICES
  # ============================================================================

  # ============================================================================
  # SECURITY
  # ============================================================================

  security = {
    polkit.enable = true;
    rtkit.enable = true;
    pam.services.sddm.enableGnomeKeyring = true;
    doas.enable = true;
    sudo.extraConfig = ''
      Defaults pwfeedback
    '';
  };

  # ============================================================================
  # VIRTUALIZATION
  # ============================================================================

  virtualisation = {
    containers.enable = true;
    waydroid.enable = false;
    podman = {
      enable = true;
      dockerSocket.enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # ============================================================================
  # XDG PORTAL (Screen Sharing)
  # ============================================================================

  xdg.portal = {
    enable = true;
    wlr.settings.screencast = {
      chooser_type = "dmenu";
      chooser_cmd = "${pkgs.fuzzel}/bin/fuzzel --dmenu";
      max_fps = 30;
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-termfilechooser
    ];
    config = {
      sway = {
        default = lib.mkForce [ "wlr" "gtk" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      };
    };
  };

  environment.etc."xdg/xdg-desktop-portal-termfilechooser/config".text = ''
    [filechooser]
    cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
    default_dir=$HOME
  '';

  # ============================================================================
  # LOCALIZATION
  # ============================================================================

  time.timeZone = "Asia/Jakarta";

  i18n = {
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "id_ID.UTF-8/UTF-8"
      "ja_JP.UTF-8/UTF-8"
    ];
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
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          fcitx5-mozc
          fcitx5-gtk
          qt6Packages.fcitx5-configtool
        ];
      settings.inputMethod = {
        GroupOrder."0" = "Default";
        "Groups/0" = {
          Name = "Default";
          "Default Layout" = "us";
          DefaultIM = "keyboard-us";
        };
        "Groups/0/Items/0".Name = "keyboard-us";
        "Groups/0/Items/1".Name = "mozc";
      };
      ignoreUserConfig = true;
      };
    };
  };

  # ============================================================================
  # PROGRAMS
  # ============================================================================

  programs = {
    niri.enable = false;
    sway = {
      enable = true;
      extraPackages = lib.mkForce [];
    };
    xwayland = {
      enable = true;
    };
    fish = {
      enable = true;
      shellInit = ''
        set fish_greeting # Disable greeting
        set -gx fish_variables_path $HOME/.local/share/fish/fish_variables
      '';
    };
    direnv.enable = true;
    # adb.enable = true;
    localsend = {
      enable = true;
      openFirewall = true;
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };

    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-pipewire-audio-capture
        obs-vaapi
        obs-gstreamer
        obs-move-transition
      ];
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
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "wheel"
      "storage"
      "podman"
      "adbusers"
      "dialout"

      "video" # Hardware video acceleration
      "render" # GPU rendering access
    ];
  };

  # ============================================================================
  # SYSTEM PACKAGES
  # ============================================================================

  programs.nix-ld = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    # Development tools
    arduino-cli
    xwayland-satellite
    starship-jj
    jujutsu
    github-cli
    aria2
    tree
    yarn-berry
    deno
    nodejs_24
    gcc
    android-tools
    aube
    bun
    unzip
    wget
    curl
    uv
    jdk21
    devbox
    opencode
    distrobox
    yazi
    (rust-bin.stable.latest.default.override {
      extensions = [
        "rust-src"
        "rust-analyzer"
      ];
    })
    steel

    # Gaming
    mangohud

    # Container tools
    podman-compose

    # Desktop support
    grim
    slurp
    fuzzel
    playerctl
    cliphist
    bibata-cursors
    bluez-tools
    bluez
    gnome-disk-utility
    qt6Packages.qt6ct
    qt6Packages.qtstyleplugin-kvantum
    app2unit
    brightnessctl
    translate-shell
    crosspipe
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    (inputs.pixie-sddm.packages.${pkgs.stdenv.hostPlatform.system}.pixie-sddm.override {
      primaryColor = "#B3C8FF";
      accentColor = "#3F5F91";
      autoColor = true;
      backgroundColor = "#1A1C1E";
      textColor = "#E2E2E6";
      fontFamily = "JetBrains Mono";
      fontSize = 13;
    })
    wf-recorder
    inputs.iris.packages.${pkgs.system}.default

    # System utilities
    ntfs3g
    efibootmgr
    gnome-keyring
    xdg-terminal-exec
    libva-utils

    # Editor and tools
    helix
    neovim
    wl-clipboard
    lua5_1
    love
    luarocks
    tree-sitter
    git
    trash-cli
    glib
    imagemagick
    ghostscript
    tectonic
    mermaid-cli
    ripgrep
    fd
    sqlite
  ];

  # ============================================================================
  # ENVIRONMENT VARIABLES
  # ============================================================================

  environment.sessionVariables = {
    JAVA_HOME = "${pkgs.jdk21}/lib/openjdk";
    ANDROID_HOME = "$HOME/Android/Sdk";
      
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";

    STEEL_HOME = "$HOME/.steel";
    DXVK_FRAME_RATE = "60";
    VDPAU_DRIVER = "va_gl";
    __GLX_VENDOR_LIBRARY_NAME = "mesa";
    WLR_NO_HARDWARE_CURSORS = "1";
    LIBVA_DRIVER_NAME = "iHD";
  };

  environment.variables = {
    TMPDIR = "/tmp";
    QT_QPA_PLATFORMTHEME = "qt6ct";
  };

  # ============================================================================
  # FONTS
  # ============================================================================

  fonts.packages = with pkgs; [
    noto-fonts-cjk-sans
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];

  # ============================================================================
  # SYSTEM VERSION
  # ============================================================================

  system.stateVersion = "26.05";
}
