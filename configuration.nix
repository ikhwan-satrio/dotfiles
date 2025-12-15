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
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

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
    alacritty
    fish
    rustc
    cargo
    zoxide
    starship
    stow
    fastfetch
    gnome-disk-utility
    nautilus
    ghostty
    polkit_gnome
    qt6Packages.qt6ct
    brave
    xwayland-satellite
    app2unit
    papirus-icon-theme
    bibata-cursors

    # neovim
    wl-clipboard
    lua5_1
    luarocks
    tree-sitter
    unzip
    wget
    git
    neovim
    nixfmt-rfc-style
    nil
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
