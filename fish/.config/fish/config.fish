if status is-interactive

    command -v starship &>/dev/null && starship init fish | source
    command -v direnv &>/dev/null && direnv hook fish | source
    command -v zoxide &>/dev/null && zoxide init fish | source

    alias ls='eza --icons --group-directories-first -1'
    alias ns='sudo nixos-rebuild switch --flake ~/.dotfiles#nixos-btw'

    # --- ASDF ---
    if type -q asdf
        if test -z "$ASDF_DATA_DIR"
            set _asdf_shims "$HOME/.asdf/shims"
        else
            set _asdf_shims "$ASDF_DATA_DIR/shims"
        end

        if not contains $_asdf_shims $PATH
            set -gx --prepend PATH $_asdf_shims
        end

        set --erase _asdf_shims
    end

    # --- Bun ---
    if test -d "$HOME/.bun"
        set -gx BUN_INSTALL "$HOME/.bun"
        set -gx PATH $BUN_INSTALL/bin $PATH
        bun completions | source
    end

    # --- Composer ---
    if type -q composer
        set -gx PATH "$(asdf where php)/.composer/vendor/bin" $PATH
    end

    # --- Java ---
    if type -q java
        set -gx JAVA_HOME (java -XshowSettings:properties -version 2>&1 | grep "java.home" | awk '{print $3}')
    end

    # --- Golang ---
    if type -q go
        set -gx GOPATH "$HOME/go"
        set -gx PATH "$GOPATH/bin" $PATH
    end

    function toggle_screen_timeout
        # Cek apakah service sedang aktif (running)
        if systemctl --user is-active --quiet swayidle-niri.service
            # Jika aktif, matikan
            systemctl --user stop swayidle-niri.service
            echo "Screen timeout disabled"
        else
            # Jika tidak aktif, nyalakan
            systemctl --user start swayidle-niri.service
            echo "Screen timeout enabled"
        end
    end

    function toggle_conservation_mode
        set -l path /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode

        if test -f $path
            set -l current_status (cat $path)
            if test $current_status -eq 1
                echo "Conservation Mode: OFF"
                echo 0 | sudo tee $path
            else
                echo "Conservation Mode: ON"
                echo 1 | sudo tee $path
            end
        else
            echo "File $path tidak ditemukan. Apakah Conservation Mode didukung?"
        end
    end

    # For jumping between prompts in foot terminal
    function mark_prompt_start --on-event fish_prompt
        echo -en "\e]133;A\e\\"
    end

    fish_add_path /home/wanto/.spicetify
end
