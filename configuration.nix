{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    inputs.noctalia.nixosModules.default # Import Noctalia NixOS module
  ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true; # Required untuk Bluetooth
  services.power-profiles-daemon.enable = true; # Required untuk Power Profile
  services.upower.enable = true; # Required untuk Battery
  services.udisks2.enable = true;
  services.gvfs.enable = true; # GNOME Virtual File System

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.noctalia-shell.enable = true;

  # Flatpak support
  services.flatpak.enable = true;

  # screen sharing
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
    config.common.default = "*"; # Atau bisa spesifik per compositor
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
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
    ];
    packages = with pkgs; [ ];
    shell = pkgs.fish;
  };

  environment.systemPackages = with pkgs; [
    nodejs_22
    fish
    rustc
    cargo
    zoxide
    starship
    stow
    fastfetch
    ghostty
    eza
    localsend
    obs-studio

    # niri support
    nautilus
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
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];

  system.stateVersion = "25.11";
}
