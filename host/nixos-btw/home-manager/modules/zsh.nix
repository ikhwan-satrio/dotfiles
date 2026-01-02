{
  config,
  pkgs,
  ...
}:
{
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";

    # Pakai plugin manual (lebih cepat dari Oh My Zsh)
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
        file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
      }
      {
        name = "catppuccin-zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "zsh-syntax-highlighting";
          rev = "06d519c20798f0ebe275fc3a8101841faaeee8ea";
          sha256 = "sha256-Q7KmwUd9fblprL55W0Sf4g7lRcemnhjh4/v+TacJSfo=";
        };
        file = "themes/catppuccin_mocha-zsh-syntax-highlighting.zsh";
      }
    ];

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    shellAliases = {
      ls = "eza --icons --group-directories-first -1";
      ll = "eza --icons --group-directories-first -lah";
      la = "eza --icons --group-directories-first -A";
      l = "eza --icons --group-directories-first -lh";
      ns = "sudo nixos-rebuild switch --flake ~/nixos-wanto#nixos-btw --impure";
    };

    initContent = ''
      export PATH=$HOME/.local/bin:$PATH

      # Lazy load completions (speed optimization)
      autoload -Uz compinit
      if [[ -n $ZDOTDIR/.zcompdump(#qN.mh+24) ]]; then
        compinit -d $ZDOTDIR/.zcompdump
      else
        compinit -C -d $ZDOTDIR/.zcompdump
      fi

      # Starship, direnv, zoxide, fzf
      command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
      command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"
      command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
      command -v fzf >/dev/null 2>&1 && eval "$(fzf --zsh)"

      # --- ASDF ---
      if command -v asdf >/dev/null 2>&1; then
          if [[ -z "$ASDF_DATA_DIR" ]]; then
              _asdf_shims="$HOME/.asdf/shims"
          else
              _asdf_shims="$ASDF_DATA_DIR/shims"
          fi
          if [[ ! "$PATH" == *"$_asdf_shims"* ]]; then
              export PATH="$_asdf_shims:$PATH"
          fi
          unset _asdf_shims
      fi

      # --- Bun ---
      if [[ -d "$HOME/.cache/.bun" ]]; then
          export BUN_INSTALL="$HOME/.cache/.bun"
          export PATH="$BUN_INSTALL/bin:$PATH"
          eval "$(bun completions)"  # Uncomment jika perlu
      fi

      # --- Composer ---
      if command -v composer >/dev/null 2>&1; then
          export PATH="$(asdf where php)/.composer/vendor/bin:$PATH"
      fi

      # --- Java ---
      if command -v java >/dev/null 2>&1; then
          export JAVA_HOME=$(java -XshowSettings:properties -version 2>&1 | grep "java.home" | awk '{print $3}')
      fi

      # --- Golang ---
      if command -v go >/dev/null 2>&1; then
          export GOPATH="$HOME/go"
          export PATH="$GOPATH/bin:$PATH"
      fi

      # --- Rust/Cargo ---
      if command -v cargo >/dev/null 2>&1; then
          export PATH="$HOME/.cargo/bin:$PATH"
      fi

      # --- Functions ---
      function nsp() {
          nix-shell --run zsh
      }

      function toggle_screen_timeout() {
          if systemctl --user is-active --quiet swayidle-niri.service; then
              systemctl --user stop swayidle-niri.service
              echo "Screen timeout disabled"
          else
              systemctl --user start swayidle-niri.service
              echo "Screen timeout enabled"
          fi
      }

      function toggle_conservation_mode() {
          local path="/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode"
          if [[ -f "$path" ]]; then
              local current_status=$(cat "$path")
              if [[ "$current_status" -eq 1 ]]; then
                  echo "Conservation Mode: OFF"
                  echo 0 | sudo tee "$path"
              else
                  echo "Conservation Mode: ON"
                  echo 1 | sudo tee "$path"
              fi
          else
              echo "File $path tidak ditemukan. Apakah Conservation Mode didukung?"
          fi
      }

      # Spicetify PATH
      export PATH="$HOME/.spicetify:$PATH"
    '';
  };
}
