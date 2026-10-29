{ ... }: {
  flake.nixosModules.packages =
    {
      inputs,
      pkgs,
      lib,
      self,
      ...
    }:
    {
      programs.nix-ld = {
        enable = true;
      };

      fonts.packages = with pkgs; [
        noto-fonts-cjk-sans
        nerd-fonts.fira-code
        nerd-fonts.jetbrains-mono
      ];

      environment.systemPackages = with pkgs; [
        # Development tools
        emacs
        arduino-cli
        xwayland-satellite
        starship-jj
        jujutsu
        github-cli
        aria2
        tree
        deno
        nodejs_24
        gcc
        bun
        unzip
        wget
        curl
        uv
        devbox
        opencode
        distrobox
        yazi
        go
        steel
        flatpak-builder
        (rust-bin.stable.latest.default.override {
          extensions = [
            "rust-src"
            "rust-analyzer"
          ];
          targets = [ "x86_64-unknown-linux-gnu" ];
        })
        ffmpeg
        secretspec

        # Gaming
        mangohud

        # Container tools
        podman-compose
        podman-desktop

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
    };
}
